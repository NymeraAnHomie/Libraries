local deflate = {}

local function split(s, sep)
    local res = {}
    local pattern = "([^" .. sep .. "]+)"
    for part in s:gmatch(pattern) do
        res[#res + 1] = part
    end
    return res
end

local function try_load(path)
    local ok, f = pcall(function() return load("return " .. path)() end)
    if ok and type(f) == "function" then return f end
    return nil
end

local function find_func(path)
    if type(path) ~= "string" or path == "" then return nil end
    local f = try_load(path)
    if f then return f end
    local env = _G
    for _, key in ipairs(split(path, "%.")) do
        if type(env) ~= "table" and type(env) ~= "userdata" then
            env = nil
            break
        end
        local ok, val = pcall(function() return env[key] end)
        if not ok then
            env = nil
            break
        end
        env = val
        if env == nil then break end
    end
    if type(env) == "function" then return env end
    return nil
end

local compressor_candidates = {
    "syn.crypt.compress", "syn.crypto.compress", "syn.compress", "syn.deflate",
    "crypt.compress", "crypt.deflate", "compress", "zlib.compress", "zlib.deflate",
    "deflate.compress", "deflate"
}

local decompressor_candidates = {
    "syn.crypt.decompress", "syn.crypto.decompress", "syn.decompress", "syn.inflate",
    "crypt.decompress", "crypt.inflate", "decompress", "zlib.decompress", "zlib.inflate",
    "deflate.decompress", "inflate"
}

local compress_fn, decompress_fn
for _, p in ipairs(compressor_candidates) do
    local f = find_func(p)
    if f then
        compress_fn = f
        break
    end
end
for _, p in ipairs(decompressor_candidates) do
    local f = find_func(p)
    if f then
        decompress_fn = f
        break
    end
end

local function adler32(s)
    local a, b = 1, 0
    for i = 1, #s do
        a = (a + s:byte(i)) % 65521
        b = (b + a) % 65521
    end
    return b * 2^16 + a
end

local function pack_u32_be(n)
    local b4 = n % 256
    n = math.floor(n / 256)
    local b3 = n % 256
    n = math.floor(n / 256)
    local b2 = n % 256
    n = math.floor(n / 256)
    local b1 = n % 256
    return string.char(b1, b2, b3, b4)
end

local function pack_u16_le(n)
    local lo = n % 256
    local hi = math.floor(n / 256) % 256
    return string.char(lo, hi)
end

local function unpack_u16_le(s, pos)
    pos = pos or 1
    local lo = s:byte(pos) or 0
    local hi = s:byte(pos + 1) or 0
    return lo + hi * 256
end

local function deflate_uncompressed_block(s)
    local len = #s
    if len <= 0xFFFF then
        local len_lo = len % 256
        local len_hi = math.floor(len / 256)
        local nlen = 0xFFFF - len
        local nlen_lo = nlen % 256
        local nlen_hi = math.floor(nlen / 256)
        return string.char(1, len_lo, len_hi, nlen_lo, nlen_hi) .. s
    end
    local out = {}
    local i = 1
    while i <= len do
        local chunk = s:sub(i, i + 65535 - 1)
        local last = (i + 65535 > len)
        local bfinal = last and 1 or 0
        local clen = #chunk
        local clen_lo = clen % 256
        local clen_hi = math.floor(clen / 256)
        local nclen = 0xFFFF - clen
        local nclen_lo = nclen % 256
        local nclen_hi = math.floor(nclen / 256)
        out[#out + 1] = string.char(bfinal, clen_lo, clen_hi, nclen_lo, nclen_hi) .. chunk
        i = i + 65535
    end
    return table.concat(out)
end

local function zlib_wrap_uncompressed(s)
    local header = "\x78\x9C"
    local body = deflate_uncompressed_block(s)
    local adl = adler32(s)
    return header .. body .. pack_u32_be(adl)
end

local function zlib_unwrap_uncompressed(s)
    if type(s) ~= "string" or #s < 2 then error("invalid zlib data") end
    local pos = 1
    local cmf = s:byte(pos); pos = pos + 1
    local flg = s:byte(pos); pos = pos + 1
    if not cmf or not flg then error("invalid zlib header") end
    local out_chunks = {}
    while pos <= #s - 4 do
        local hdr = s:byte(pos)
        pos = pos + 1
        local bfinal = hdr & 1
        local btype = (hdr >> 1) & 3
        if btype == 0 then
            local len = unpack_u16_le(s, pos); pos = pos + 2
            local nlen = unpack_u16_le(s, pos); pos = pos + 2
            if ((len ~ nlen) & 0xFFFF) ~= 0xFFFF then error("invalid uncompressed block lengths") end
            local chunk = s:sub(pos, pos + len - 1)
            if #chunk < len then error("incomplete uncompressed block") end
            out_chunks[#out_chunks + 1] = chunk
            pos = pos + len
            if bfinal == 1 then break end
        else
            error("unsupported deflate btype: " .. tostring(btype))
        end
    end
    local expected_adler = 0
    if pos <= #s - 3 then
        expected_adler = ((s:byte(pos) or 0) << 24) + ((s:byte(pos + 1) or 0) << 16) + ((s:byte(pos + 2) or 0) << 8) + (s:byte(pos + 3) or 0)
    end
    local out = table.concat(out_chunks)
    if expected_adler ~= 0 then
        if adler32(out) ~= expected_adler then error("adler32 mismatch") end
    end
    return out
end

local b64_chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local b64_map = {}
for i = 1, #b64_chars do b64_map[b64_chars:sub(i, i)] = i - 1 end

local function base64_encode_lua(data)
    if data == "" then return "" end
    local res = {}
    local len = #data
    local i = 1
    while i <= len - 2 do
        local a, b, c = data:byte(i, i + 2)
        local n = a * 65536 + b * 256 + c
        local c1 = math.floor(n / 262144) % 64 + 1
        local c2 = math.floor(n / 4096) % 64 + 1
        local c3 = math.floor(n / 64) % 64 + 1
        local c4 = n % 64 + 1
        res[#res + 1] = b64_chars:sub(c1, c1) .. b64_chars:sub(c2, c2) .. b64_chars:sub(c3, c3) .. b64_chars:sub(c4, c4)
        i = i + 3
    end
    local rem = len - i + 1
    if rem == 1 then
        local a = data:byte(i)
        local n = a * 65536
        local c1 = math.floor(n / 262144) % 64 + 1
        local c2 = math.floor(n / 4096) % 64 + 1
        res[#res + 1] = b64_chars:sub(c1, c1) .. b64_chars:sub(c2, c2) .. "=="
    elseif rem == 2 then
        local a, b = data:byte(i, i + 1)
        local n = a * 65536 + b * 256
        local c1 = math.floor(n / 262144) % 64 + 1
        local c2 = math.floor(n / 4096) % 64 + 1
        local c3 = math.floor(n / 64) % 64 + 1
        res[#res + 1] = b64_chars:sub(c1, c1) .. b64_chars:sub(c2, c2) .. b64_chars:sub(c3, c3) .. "="
    end
    return table.concat(res)
end

local function base64_decode_lua(s)
    local out = {}
    local buffer = 0
    local bits = 0
    for i = 1, #s do
        local ch = s:sub(i, i)
        if ch == "=" then
            break
        end
        local val = b64_map[ch]
        if val then
            buffer = buffer * 64 + val
            bits = bits + 6
            if bits >= 8 then
                bits = bits - 8
                local byte = math.floor(buffer / (2 ^ bits)) % 256
                out[#out + 1] = string.char(byte)
            end
        end
    end
    return table.concat(out)
end

local function find_base64_fns()
    local enc, dec
    local candidates = {
        "syn.crypt.base64.encode", "syn.crypt.base64.decode",
        "crypt.base64.encode", "crypt.base64.decode",
        "syn.crypt.base64_encode", "syn.crypt.base64_decode",
        "crypt.base64_encode", "crypt.base64_decode"
    }
    for i = 1, #candidates, 2 do
        local epath = candidates[i]
        local dpath = candidates[i + 1]
        local e = find_func(epath)
        local d = find_func(dpath)
        if type(e) == "function" and type(d) == "function" then
            enc, dec = e, d
            break
        end
    end
    return enc, dec
end

local base64_enc, base64_dec = find_base64_fns()
if not base64_enc or not base64_dec then
    base64_enc = base64_encode_lua
    base64_dec = base64_decode_lua
end

function deflate.compress(data, opts)
    opts = opts or {}
    local mode = opts.mode or "auto"
    local use_base64 = opts.base64 == true
    if mode == "auto" then
        if compress_fn then
            local ok, res = pcall(compress_fn, data)
            if ok then
                if use_base64 then return base64_enc(res) end
                return res
            end
        end
        local wrapped = zlib_wrap_uncompressed(data)
        if use_base64 then return base64_enc(wrapped) end
        return wrapped
    elseif mode == "executor" then
        if not compress_fn then error("executor compress not found") end
        local ok, res = pcall(compress_fn, data)
        if not ok then error("executor compress failed") end
        if use_base64 then return base64_enc(res) end
        return res
    elseif mode == "zlib_uncompressed" then
        local wrapped = zlib_wrap_uncompressed(data)
        if use_base64 then return base64_enc(wrapped) end
        return wrapped
    else
        error("unknown mode")
    end
end

function deflate.decompress(data, opts)
    opts = opts or {}
    local mode = opts.mode or "auto"
    local is_base64 = opts.base64 == true
    local raw = data
    if is_base64 then
        raw = base64_dec(data)
    end
    if mode == "auto" then
        if decompress_fn then
            local ok, res = pcall(decompress_fn, raw)
            if ok then return res end
        end
        local ok, res = pcall(zlib_unwrap_uncompressed, raw)
        if ok then return res end
        error("no available decompressor")
    elseif mode == "executor" then
        if not decompress_fn then error("executor decompress not found") end
        local ok, res = pcall(decompress_fn, raw)
        if not ok then error("executor decompress failed") end
        return res
    elseif mode == "zlib_uncompressed" then
        return zlib_unwrap_uncompressed(raw)
    else
        error("unknown mode")
    end
end

function deflate.has_executor()
    return (compress_fn ~= nil) or (decompress_fn ~= nil)
end

deflate._internal = {
    compressor_found = compress_fn ~= nil,
    decompressor_found = decompress_fn ~= nil
}

return deflate
```0
