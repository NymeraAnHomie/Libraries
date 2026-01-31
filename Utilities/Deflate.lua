local Deflate = {}
Deflate.__index = Deflate

local function Split(String, Separator)
    local Result = {}
    for Part in String:gmatch("([^" .. Separator .. "]+)") do
        Result[#Result + 1] = Part
    end
    return Result
end

local function TryLoad(Path)
    local Success, Func = pcall(function()
        return load("return " .. Path)()
    end)
    if Success and type(Func) == "function" then
        return Func
    end
    return nil
end

local function FindFunction(Path)
    if type(Path) ~= "string" or Path == "" then
        return nil
    end

    local Func = TryLoad(Path)
    if Func then
        return Func
    end

    local Env = _G
    for _, Key in ipairs(Split(Path, "%.")) do
        if type(Env) ~= "table" and type(Env) ~= "userdata" then
            Env = nil
            break
        end
        local Ok, Val = pcall(function()
            return Env[Key]
        end)
        if not Ok then
            Env = nil
            break
        end
        Env = Val
        if Env == nil then break end
    end

    if type(Env) == "function" then
        return Env
    end
    return nil
end

local CompressorCandidates = {
    "syn.crypt.compress", "syn.crypto.compress", "syn.compress", "syn.deflate",
    "crypt.compress", "crypt.deflate", "compress", "zlib.compress", "zlib.deflate",
    "deflate.compress", "deflate"
}

local DecompressorCandidates = {
    "syn.crypt.decompress", "syn.crypto.decompress", "syn.decompress", "syn.inflate",
    "crypt.decompress", "crypt.inflate", "decompress", "zlib.decompress", "zlib.inflate",
    "deflate.decompress", "inflate"
}

local CompressFunction, DecompressFunction

for _, Path in ipairs(CompressorCandidates) do
    local F = FindFunction(Path)
    if F then
        CompressFunction = F
        break
    end
end

for _, Path in ipairs(DecompressorCandidates) do
    local F = FindFunction(Path)
    if F then
        DecompressFunction = F
        break
    end
end

local function Adler32(Data)
    local A, B = 1, 0
    for i = 1, #Data do
        A = (A + Data:byte(i)) % 65521
        B = (B + A) % 65521
    end
    return B * 2^16 + A
end

local function PackU32BE(Number)
    local Bytes = {}
    for i = 3, 0, -1 do
        Bytes[#Bytes + 1] = Char(bit.band(bit.rshift(Number, i * 8), 0xFF))
    end
    return Concat(Bytes)
end

local function PackU16LE(Number)
    local Lo = Number % 256
    local Hi = Floor(Number / 256) % 256
    return Char(Lo, Hi)
end

local function UnpackU16LE(String, Pos)
    Pos = Pos or 1
    local Lo = String:byte(Pos) or 0
    local Hi = String:byte(Pos + 1) or 0
    return Lo + Hi * 256
end

local function DeflateUncompressedBlock(Data)
    local Length = #Data
    if Length <= 0xFFFF then
        local LenLo = Length % 256
        local LenHi = Floor(Length / 256)
        local NLen = 0xFFFF - Length
        local NLenLo = NLen % 256
        local NLenHi = Floor(NLen / 256)
        return Char(1, LenLo, LenHi, NLenLo, NLenHi) .. Data
    end

    local Output, Index = {}, 1
    while Index <= Length do
        local Chunk = Data:sub(Index, Index + 65535 - 1)
        local Last = (Index + 65535 > Length)
        local BFinal = Last and 1 or 0
        local CLen = #Chunk
        local CLenLo = CLen % 256
        local CLenHi = Floor(CLen / 256)
        local NCLen = 0xFFFF - CLen
        local NCLenLo = NCLen % 256
        local NCLenHi = Floor(NCLen / 256)
        Output[#Output + 1] = Char(BFinal, CLenLo, CLenHi, NCLenLo, NCLenHi) .. Chunk
        Index = Index + 65535
    end
    return Concat(Output)
end

local function ZlibWrapUncompressed(Data)
    local Header = "\x78\x9C"
    local Body = DeflateUncompressedBlock(Data)
    local Adler = Adler32(Data)
    return Header .. Body .. PackU32BE(Adler)
end

local function ZlibUnwrapUncompressed(Data)
    assert(type(Data) == "string" and #Data >= 2, "Invalid zlib data")

    local Pos, OutputChunks = 3, {}

    while Pos <= #Data - 4 do
        local Hdr = Data:byte(Pos); Pos = Pos + 1
        
        local BFinal = bit.band(Hdr, 1)
        local BType  = bit.band(bit.rshift(Hdr, 1), 3)

        if BType == 0 then
            local Len  = UnpackU16LE(Data, Pos); Pos = Pos + 2
            local NLen = UnpackU16LE(Data, Pos); Pos = Pos + 2

            if bit.band(bit.bxor(Len, NLen), 0xFFFF) ~= 0xFFFF then
                error("Invalid uncompressed block lengths")
            end

            local Chunk = Data:sub(Pos, Pos + Len - 1)
            if #Chunk < Len then
                error("Incomplete uncompressed block")
            end
            OutputChunks[#OutputChunks + 1] = Chunk
            Pos = Pos + Len

            if BFinal == 1 then break end
        else
            error("Unsupported deflate block type: " .. tostring(BType))
        end
    end

    local ExpectedAdler = 0
    if Pos <= #Data - 3 then
        ExpectedAdler = bit.bor(
            bit.lshift((Data:byte(Pos)     or 0), 24),
            bit.lshift((Data:byte(Pos + 1) or 0), 16),
            bit.lshift((Data:byte(Pos + 2) or 0), 8),
            (Data:byte(Pos + 3) or 0)
        )
    end

    local Output = Concat(OutputChunks)
    if ExpectedAdler ~= 0 and Adler32(Output) ~= ExpectedAdler then
        error("Adler32 checksum mismatch")
    end

    return Output
end

local Base64Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local Base64Map = {}
for i = 1, #Base64Chars do
    Base64Map[Base64Chars:sub(i, i)] = i - 1
end

local function Base64EncodeLua(Data)
    if Data == "" then return "" end
    local Result = {}
    local Length = #Data
    local i = 1

    while i <= Length - 2 do
        local A, B, C = Data:byte(i, i + 2)
        local N = A * 65536 + B * 256 + C
        local C1 = Floor(N / 262144) % 64 + 1
        local C2 = Floor(N / 4096) % 64 + 1
        local C3 = Floor(N / 64) % 64 + 1
        local C4 = N % 64 + 1
        Result[#Result + 1] = Base64Chars:sub(C1, C1)
            .. Base64Chars:sub(C2, C2)
            .. Base64Chars:sub(C3, C3)
            .. Base64Chars:sub(C4, C4)
        i += 3
    end

    local Rem = Length - i + 1
    if Rem == 1 then
        local A = Data:byte(i)
        local N = A * 65536
        local C1 = Floor(N / 262144) % 64 + 1
        local C2 = Floor(N / 4096) % 64 + 1
        Result[#Result + 1] = Base64Chars:sub(C1, C1)
            .. Base64Chars:sub(C2, C2)
            .. "=="
    elseif Rem == 2 then
        local A, B = Data:byte(i, i + 1)
        local N = A * 65536 + B * 256
        local C1 = Floor(N / 262144) % 64 + 1
        local C2 = Floor(N / 4096) % 64 + 1
        local C3 = Floor(N / 64) % 64 + 1
        Result[#Result + 1] = Base64Chars:sub(C1, C1)
            .. Base64Chars:sub(C2, C2)
            .. Base64Chars:sub(C3, C3)
            .. "="
    end

    return Concat(Result)
end

local function Base64DecodeLua(Str)
    if type(Str) ~= "string" or #Str == 0 then
        return ""
    end
    local Output, Buffer, Bits = {}, 0, 0
    for i = 1, #Str do
        local Ch = Str:sub(i, i)
        if Ch == "=" then break end
        local Val = Base64Map[Ch]
        if Val ~= nil then
            Buffer = Buffer * 64 + Val
            Bits = Bits + 6
            while Bits >= 8 do
                Bits = Bits - 8
                local Byte = Floor(Buffer / (2 ^ Bits)) % 256
                if type(Byte) == "number" and Byte >= 0 and Byte <= 255 then
                    Output[#Output + 1] = Char(Byte)
                else
                    return Concat(Output)
                end
            end
        end
    end
    return Concat(Output)
end

local function FindBase64Functions()
    local Enc, Dec
    local Candidates = {
        "syn.crypt.base64.encode", "syn.crypt.base64.decode",
        "crypt.base64.encode", "crypt.base64.decode",
        "syn.crypt.base64_encode", "syn.crypt.base64_decode",
        "crypt.base64_encode", "crypt.base64_decode"
    }
    for i = 1, #Candidates, 2 do
        local EPath, DPath = Candidates[i], Candidates[i + 1]
        local E, D = FindFunction(EPath), FindFunction(DPath)
        if type(E) == "function" and type(D) == "function" then
            Enc, Dec = E, D
            break
        end
    end
    return Enc, Dec
end

local Base64Enc, Base64Dec = FindBase64Functions()
if not Base64Enc or not Base64Dec then
    Base64Enc = Base64EncodeLua
    Base64Dec = Base64DecodeLua
end

function Deflate.Compress(Data, Options)
    Options = Options or {}
    local Mode = Options.mode or "auto"
    local UseBase64 = Options.base64 == true

    if Mode == "auto" then
        if CompressFunction then
            local Ok, Result = pcall(CompressFunction, Data)
            if Ok then
                return UseBase64 and Base64Enc(Result) or Result
            end
        end
        local Wrapped = ZlibWrapUncompressed(Data)
        return UseBase64 and Base64Enc(Wrapped) or Wrapped
    elseif Mode == "executor" then
        assert(CompressFunction, "Executor compress not found")
        local Ok, Result = pcall(CompressFunction, Data)
        assert(Ok, "Executor compress failed")
        return UseBase64 and Base64Enc(Result) or Result
    elseif Mode == "zlib_uncompressed" then
        local Wrapped = ZlibWrapUncompressed(Data)
        return UseBase64 and Base64Enc(Wrapped) or Wrapped
    else
        error("Unknown compression mode: " .. tostring(Mode))
    end
end

function Deflate.Decompress(Data, Options)
    Options = Options or {}
    local Mode = Options.mode or "auto"
    local IsBase64 = Options.base64 == true

    local Raw = IsBase64 and Base64Dec(Data) or Data

    if Mode == "auto" then
        if DecompressFunction then
            local Ok, Result = pcall(DecompressFunction, Raw)
            if Ok then return Result end
        end
        local Ok, Result = pcall(ZlibUnwrapUncompressed, Raw)
        if Ok then return Result end
        error("No available decompressor")
    elseif Mode == "executor" then
        assert(DecompressFunction, "Executor decompress not found")
        local Ok, Result = pcall(DecompressFunction, Raw)
        assert(Ok, "Executor decompress failed")
        return Result
    elseif Mode == "zlib_uncompressed" then
        return ZlibUnwrapUncompressed(Raw)
    else
        error("Unknown decompression mode: " .. tostring(Mode))
    end
end

function Deflate.HasExecutor()
    return (CompressFunction ~= nil) or (DecompressFunction ~= nil)
end

Deflate._Internal = {
    CompressorFound = CompressFunction ~= nil,
    DecompressorFound = DecompressFunction ~= nil
}
