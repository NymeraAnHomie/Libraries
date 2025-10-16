local Json = {}
Json.__index = Json
Json.ClassName = "Json"

local function EscapeString(Value)
    return '"' .. Value:gsub('[%z\1-\31\\"]', function(Char)
        local Map = {
            ['\\'] = '\\\\',
            ['"'] = '\\"',
            ['\b'] = '\\b',
            ['\f'] = '\\f',
            ['\n'] = '\\n',
            ['\r'] = '\\r',
            ['\t'] = '\\t',
        }
        return Map[Char] or string.format("\\u%04x", Char:byte())
    end) .. '"'
end

local function SerializeValue(Value, Stack)
    Stack = Stack or {}
    local TypeOfValue = typeof(Value) or type(Value)

    if Stack[Value] then
        error("Circular reference detected")
    end

    if TypeOfValue == "nil" then
        return "null"
    elseif TypeOfValue == "boolean" then
        return tostring(Value)
    elseif TypeOfValue == "number" then
        return tostring(Value)
    elseif TypeOfValue == "string" then
        return EscapeString(Value)
    elseif TypeOfValue == "Vector3" then
        return Json.Encode({__type="Vector3", X=Value.X, Y=Value.Y, Z=Value.Z})
    elseif TypeOfValue == "Vector2" then
        return Json.Encode({__type="Vector2", X=Value.X, Y=Value.Y})
    elseif TypeOfValue == "CFrame" then
        local components = {Value:GetComponents()}
        return Json.Encode({__type="CFrame", Components=components})
    elseif TypeOfValue == "table" then
        Stack[Value] = true
        local IsArray = (#Value > 0)
        local Parts = {}

        if IsArray then
            for i = 1, #Value do
                table.insert(Parts, SerializeValue(Value[i], Stack))
            end
            Stack[Value] = nil
            return "[" .. table.concat(Parts, ",") .. "]"
        else
            for K, V in pairs(Value) do
                if type(K) ~= "string" then
                    error("JSON object keys must be strings")
                end
                table.insert(Parts, EscapeString(K) .. ":" .. SerializeValue(V, Stack))
            end
            Stack[Value] = nil
            return "{" .. table.concat(Parts, ",") .. "}"
        end
    else
        error("Unsupported type: " .. TypeOfValue)
    end
end

local function DeserializeValue(Value)
    if type(Value) ~= "table" then return Value end

    if Value.__type == "Vector3" then
        return Vector3.new(Value.X, Value.Y, Value.Z)
    elseif Value.__type == "Vector2" then
        return Vector2.new(Value.X, Value.Y)
    elseif Value.__type == "CFrame" then
        return CFrame.new(unpack(Value.Components))
    else
        local NewTable = {}
        for K, V in pairs(Value) do
            NewTable[K] = DeserializeValue(V)
        end
        return NewTable
    end
end

local function CodepointToUtf8(N)
    local F = math.floor
    if N <= 0x7f then
        return string.char(N)
    elseif N <= 0x7ff then
        return string.char(F(N / 64) + 192, N % 64 + 128)
    elseif N <= 0xffff then
        return string.char(F(N / 4096) + 224, F(N % 4096 / 64) + 128, N % 64 + 128)
    elseif N <= 0x10ffff then
        return string.char(F(N / 262144) + 240, F(N % 262144 / 4096) + 128, F(N % 4096 / 64) + 128, N % 64 + 128)
    end
    error("Invalid Unicode codepoint")
end

local function ParseUnicodeEscape(S)
    local N1 = tonumber(S:sub(1,4), 16)
    local N2 = tonumber(S:sub(7,10),16)
    if N2 then
        return CodepointToUtf8((N1 - 0xd800) * 0x400 + (N2 - 0xdc00) + 0x10000)
    else
        return CodepointToUtf8(N1)
    end
end

local function SkipWhitespace(Str, Idx)
    while Idx <= #Str and Str:sub(Idx,Idx):match("[%s\r\n\t]") do
        Idx = Idx + 1
    end
    return Idx
end

local function ParseString(Str, Idx)
    local Res = {}
    local I = Idx + 1
    while I <= #Str do
        local C = Str:sub(I,I)
        if C == '"' then
            return table.concat(Res), I + 1
        elseif C == "\\" then
            I = I + 1
            local NextChar = Str:sub(I,I)
            local Map = {b="\b", f="\f", n="\n", r="\r", t="\t", ['"']='"', ["\\"]="\\", ["/"]="/" }
            if NextChar == "u" then
                Res[#Res+1] = ParseUnicodeEscape(Str:sub(I+1,I+4))
                I = I + 4
            else
                Res[#Res+1] = Map[NextChar] or NextChar
            end
        else
            Res[#Res+1] = C
        end
        I = I + 1
    end
    error("Unterminated string")
end

local function ParseNumber(Str, Idx)
    local EndIdx = Idx
    while EndIdx <= #Str and Str:sub(EndIdx,EndIdx):match("[0-9eE%+%-%.]") do
        EndIdx = EndIdx + 1
    end
    local Num = tonumber(Str:sub(Idx,EndIdx-1))
    if not Num then error("Invalid number") end
    return Num, EndIdx
end

local function ParseLiteral(Str, Idx)
    local Literals = {["true"]=true, ["false"]=false, ["null"]=nil}
    for Lit, Val in pairs(Literals) do
        if Str:sub(Idx, Idx + #Lit - 1) == Lit then
            return Val, Idx + #Lit
        end
    end
    error("Invalid literal")
end

local function ParseArray(Str, Idx)
    local Res = {}
    Idx = Idx + 1
    Idx = SkipWhitespace(Str, Idx)
    if Str:sub(Idx,Idx) == "]" then return Res, Idx + 1 end
    while true do
        local Val
        Val, Idx = Json.Parse(Str, Idx)
        Res[#Res+1] = Val
        Idx = SkipWhitespace(Str, Idx)
        local C = Str:sub(Idx,Idx)
        if C == "]" then return Res, Idx + 1 end
        if C ~= "," then error("Expected ',' in array") end
        Idx = SkipWhitespace(Str, Idx + 1)
    end
end

local function ParseObject(Str, Idx)
    local Res = {}
    Idx = Idx + 1
    Idx = SkipWhitespace(Str, Idx)
    if Str:sub(Idx,Idx) == "}" then return Res, Idx + 1 end
    while true do
        local Key
        if Str:sub(Idx,Idx) ~= '"' then error("Expected string key") end
        Key, Idx = ParseString(Str, Idx)
        Idx = SkipWhitespace(Str, Idx)
        if Str:sub(Idx,Idx) ~= ":" then error("Expected ':' after key") end
        Idx = SkipWhitespace(Str, Idx + 1)
        local Val
        Val, Idx = Json.Parse(Str, Idx)
        Res[Key] = Val
        Idx = SkipWhitespace(Str, Idx)
        local C = Str:sub(Idx,Idx)
        if C == "}" then return Res, Idx + 1 end
        if C ~= "," then error("Expected ',' in object") end
        Idx = SkipWhitespace(Str, Idx + 1)
    end
end

local function PrettyEncode(value, indent, level)
    indent = indent or 2
    level = level or 0
    local spacing = string.rep(" ", level * indent)

    if type(value) == "table" then
        local isArray = (#value > 0)
        local parts = {}
        if isArray then
            for i, v in ipairs(value) do
                table.insert(parts, PrettyEncode(v, indent, level + 1))
            end
            return "[\n" .. spacing .. string.rep(" ", indent) ..
                table.concat(parts, ",\n" .. spacing .. string.rep(" ", indent)) ..
                "\n" .. spacing .. "]"
        else
            for k, v in pairs(value) do
                table.insert(parts,
                    spacing .. string.rep(" ", indent) ..
                    EscapeString(k) .. ": " .. PrettyEncode(v, indent, level + 1))
            end
            return "{\n" ..
                table.concat(parts, ",\n") ..
                "\n" .. spacing .. "}"
        end
    elseif type(value) == "string" then
        return EscapeString(value)
    else
        return SerializeValue(value)
    end
end

function Json.Parse(Str, Idx)
    Idx = SkipWhitespace(Str, Idx or 1)
    local C = Str:sub(Idx,Idx)
    if C == '"' then
        return ParseString(Str, Idx)
    elseif C == "{" then
        return ParseObject(Str, Idx)
    elseif C == "[" then
        return ParseArray(Str, Idx)
    elseif C:match("[0-9%-]") then
        return ParseNumber(Str, Idx)
    elseif C:match("[tnf]") then
        return ParseLiteral(Str, Idx)
    else
        error("Unexpected character: " .. C)
    end
end

function Json.Validate(str)
    return pcall(function() Json.Parse(str) end)
end

function Json.PrettyEncode(value, indent)
    return PrettyEncode(value, indent or 2)
end

function Json.Encode(Value)
    return SerializeValue(Value)
end

function Json.Decode(Str)
    return DeserializeValue(Json.Parse(Str))
end
