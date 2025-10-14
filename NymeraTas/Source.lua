-- this has no seek backward frame shit 💔
local Version = "v1.0"
local Utilities = {} -- Ignore
local Frames = {} -- Ignore

-- Variables
-- Data Types
local Vec2 = Vector2.new
local Vec3 = Vector3.new
local Dim2 = UDim2.new
local Dim = UDim.new
local DimOffset = UDim2.fromOffset
local RectNew = Rect.new
local Cfr = CFrame.new
local EmptyCfr = Cfr()
local PointObjectSpace = EmptyCfr.PointToObjectSpace
local Angle = CFrame.Angles

-- Extra Data Types
local Color = Color3.new
local Rgb = Color3.fromRGB
local Hex = Color3.fromHex
local Hsv = Color3.fromHSV
local RgbSeq = ColorSequence.new
local RgbKey = ColorSequenceKeypoint.new
local NumSeq = NumberSequence.new
local NumKey = NumberSequenceKeypoint.new

local Max = math.max
local Floor = math.floor
local Min = math.min
local Abs = math.abs
local Noise = math.noise
local Rad = math.rad
local Random = math.random
local Pow = math.pow
local Sin = math.sin
local Pi = math.pi
local Tan = math.tan
local Atan2 = math.atan2
local Cos = math.cos
local Round = math.round
local Clamp = math.clamp
local Ceil = math.ceil
local Sqrt = math.sqrt
local Acos = math.acos

local Insert = table.insert
local Find = table.find
local Remove = table.remove
local Concat = table.concat
--

-- If you had the tiniest bit of lua yk how to use this table
local Configuration = {
	MenuBind = "M", -- Toggle the Menu Visibility
	PlaybackInputs = true,
	PlaybackMouseLocation = true,
	BypassAntiCheat = false,
	PrettyFormating = false,
	Keybind = {
		Frozen = "E",
	    Wipe = "Delete",
	    Spectate = "One",
	    Create = "Two",
	    Test = "Three",
	    StepBackward = "N",
	    StepForward = "B",
	    SeekBackward = "C",
	    SeekForward = "V"
	},
	InputBlacklist = {"E", "N", "B", "C", "V"}, -- exactly the script would know when to not record the input or do
	Cursors = {
		["ArrowFarCursor"] = { -- Default
			Icon = "rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png",
			Size = DimOffset(64, 64),
			Offset = Vec2(-16, 60),
		},
		["MouseLockedCursor"] = { -- Shiftlock
			Icon = "rbxasset://textures/MouseLockedCursor.png",
			Size = DimOffset(32, 32),
			Offset = Vec2(-16, 20),
		},
	},
	
	-- Ignore all bottom
	Directory = "NymeraTas", -- u can change this idgaf tbh this the main folder on workspace
	Folders = {
		"/Records",
		"/Connections",
		--"/Trash", -- where to convert or was deleted
	},
	Ignore,
	Instances = {},
	Drawings = {},
	Connections = {},
}

--
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local InsertService = game:GetService("InsertService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local PlayersScript = LocalPlayer.PlayerScripts
local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart
local Humanoid = Character.Humanoid

local Camera = Workspace.CurrentCamera
local GuiInset = GuiService:GetGuiInset()
local Mouse = LocalPlayer:GetMouse()
local MousePosition = UserInputService:GetMouseLocation()
local GuiOffset = GuiService:GetGuiInset().Y
local IsMobile = UserInputService.TouchEnabled

local Index = 1
local Reading = false
local Writing = false
local Frozen = false
local ShiftLockEnabled = false
local Pose = ""
local HumanoidState = ""
local ReplayFile = "None"
local ReplayName = "None"

-- File Management
for _, v in ipairs(Configuration.Folders) do
    local path = Configuration.Directory .. v
    if not isfolder(path) then
        makefolder(path)
    end
end
--

-- Json
local Json = {}
Json.__index = Json
Json.ClassName = "Json"

workspace:FindFirstChild("ParseString, ParseObject; you surely made me wanna end it all also circular ref :smile:")

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
--

-- TODO: Use Humanoid States to do the Animation or use an custom Animation? [Exactly here]

-- Utilities
do
	--
    do
	    local EnableTraceback = false
	    local Signal = {}
	    local Registry = { Signals = {}, Callbacks = {} }
	    Signal.__index = Signal
	    Signal.ClassName = "Signal"
	
	    function Signal.Create()
	        local self = setmetatable({}, Signal)
	        self.Bindable = Instance.new("BindableEvent")
	        self.ArgMap = {}
	        self.Source = EnableTraceback and debug.traceback() or ""
	        return self
	    end
	
	    function Signal:Fire(...)
	        if not self.Bindable then return end
	        local key = #self.ArgMap + 1
	        self.ArgMap[key] = { ... }
	        self.Bindable:Fire(key)
	    end
	
	    function Signal:Connect(fn)
		    assert(type(fn) == "function", "Signal:Connect expects a function")
		
		    return self.Bindable.Event:Connect(function(key)
		        local args = self.ArgMap[key]
		
		        if args == nil then
		            warn("[Signal] No arguments found for key:", key)
		            return  -- skip calling fn
		        end
		
		        self.ArgMap[key] = nil
		
		        if type(args) ~= "table" then
		            fn(args)  -- call with single value
		        else
		            fn(table.unpack(args))  -- call with table values
		        end
		    end)
		end
	
	    function Signal:Wait()
	        local key = self.Bindable.Event:Wait()
	        local args = self.ArgMap[key]
	        self.ArgMap[key] = nil
	        return table.unpack(args)
	    end
	
	    function Signal:Destroy()
	        if self.Bindable then
	            self.Bindable:Destroy()
	            self.Bindable = nil
	        end
	        setmetatable(self, nil)
	    end
	
	    function Signal.Add(name, fn)
	        if type(name) == "string" and type(fn) == "function" then
	            Registry.Callbacks[name] = fn
	        end
	    end
	
	    function Signal.Run(name, ...)
	        local cb = Registry.Callbacks[name]
	        if cb then
	            return cb(...)
	        end
	    end
	
	    function Signal.Remove(name)
	        Registry.Callbacks[name] = nil
	    end
	
	    function Signal.Wrap(name)
	        return function(...)
	            local sig = Signal.Get(name)
	            if sig and sig.Fire then
	                sig:Fire(...)
	            end
	        end
	    end
	
	    function Signal.New(name)
	        if type(name) ~= "string" then
	            return Signal.Create()
	        end
	        local segments = {}
	        for segment in string.gmatch(name, "[^%.]+") do
	            table.insert(segments, segment)
	        end
	        local cursor = Registry.Signals
	        for i = 1, #segments do
	            local part = segments[i]
	            if i == #segments then
	                if not cursor[part] then
	                    cursor[part] = Signal.Create()
	                end
	                return cursor[part]
	            else
	                cursor[part] = cursor[part] or {}
	                cursor = cursor[part]
	            end
	        end
	    end
	
	    function Signal.Get(name)
	        local segments = {}
	        for segment in string.gmatch(name, "[^%.]+") do
	            table.insert(segments, segment)
	        end
	        local cursor = Registry.Signals
	        for i = 1, #segments do
	            local part = segments[i]
	            cursor = cursor and cursor[part]
	            if not cursor then
	                return nil
	            end
	        end
	        return cursor
	    end
	    --
	    Utilities.Signal = Signal -- set to global utilities for further use
	end
	
	function Utilities.GetClipboard() -- pasted from vadderhaxx 🤑🤑
		local screen = Instance.new("ScreenGui",game.CoreGui)
		local tb = Instance.new("TextBox",screen)
		tb.TextTransparency = 1

		tb:CaptureFocus()
		keypress(0x11)  
		keypress(0x56)
		task.wait()
		keyrelease(0x11)
		keyrelease(0x56)
		tb:ReleaseFocus()

		local captured = tb.Text

		tb:Destroy()
		screen:Destroy()

		return captured
	end
    
    -- this is so frikkin tuff
    Utilities.Base = {
    	AbsoluteSize = Camera.ViewportSize,
        PropertyChanged = Utilities.Signal.New(),
        ChildUpdated = Utilities.Signal.New()
	}
	
    Utilities.BlockMouseEvents = false
	Utilities.Mouse = { -- so this is like are sorta own events that fire when mouse occur (pos, clicks, etc)
	    Position = Vec2(0, 0),
	    OldPosition = Vec2(0, 0),
	    Mouse1Held = false,
	    Mouse2Held = false,
	    Moved = Utilities.Signal.New(),
	    MouseButton1Down = Utilities.Signal.New(),
	    MouseButton1Up = Utilities.Signal.New(),
	    MouseButton2Down = Utilities.Signal.New(),
	    MouseButton2Up = Utilities.Signal.New(),
	    ScrollUp = Utilities.Signal.New(),
	    ScrollDown = Utilities.Signal.New()
	}
	
	Utilities.Activations = {
		Clicked = Utilities.Signal.New(),
		Holding = Utilities.Signal.New(),
		Hovering = Utilities.Signal.New(),
		MouseEnter = Utilities.Signal.New(),
		MouseLeave = Utilities.Signal.New()
	}
	
	Utilities.KeyDown = Utilities.Signal.New()
	Utilities.KeyUp = Utilities.Signal.New()
	Utilities.InputState = {Keys = {}}
	
	UserInputService.InputChanged:Connect(function(Input, Processed)
	    if Utilities.BlockMouseEvents then return end
	    if Input.UserInputType == Enum.UserInputType.MouseMovement then
	        Utilities.Mouse.OldPosition = Utilities.Mouse.Position
	        local XY = UserInputService:GetMouseLocation()
	        Utilities.Mouse.Position = Vec2(XY.X, XY.Y)
	        Utilities.Mouse.Moved:Fire()
	    elseif Input.UserInputType == Enum.UserInputType.MouseWheel then
	        if Input.Position.Z > 0 then
	            Utilities.Mouse.ScrollUp:Fire(Input.Position.Z)
	        else
	            Utilities.Mouse.ScrollDown:Fire(Input.Position.Z)
	        end
	    end
	end)
	
	UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	    if GameProcessed then return end
	    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
	        Utilities.Mouse.Mouse1Held = true
	        Utilities.Mouse.MouseButton1Down:Fire()
	    elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
	        Utilities.Mouse.Mouse2Held = true
	        Utilities.Mouse.MouseButton2Down:Fire()
	    elseif Input.UserInputType == Enum.UserInputType.Keyboard then
	        Utilities.KeyDown:Fire(Input.KeyCode)
	        Utilities.InputState.Keys[Input.KeyCode] = true
	    end
	end)
	
	UserInputService.InputEnded:Connect(function(Input)
	    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
	        Utilities.Mouse.Mouse1Held = false
	        Utilities.Mouse.MouseButton1Up:Fire()
	    elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
	        Utilities.Mouse.Mouse2Held = false
	        Utilities.Mouse.MouseButton2Up:Fire()
	    elseif Input.UserInputType == Enum.UserInputType.Keyboard then
	        Utilities.KeyUp:Fire(Input.KeyCode)
	        Utilities.InputState.Keys[Input.KeyCode] = false
	    end
	end)
	
	--
	Utilities.Mouse.MouseButton1Down:Connect(function()
		Utilities.Activations.Clicked:Fire(nil, "Mouse", Utilities.Mouse.Position)
		Utilities.Activations.Holding:Fire(nil, true, "Mouse")
	end)
	
	Utilities.Mouse.MouseButton1Up:Connect(function()
		Utilities.Activations.Holding:Fire(nil, false, "Mouse")
	end)
	
	UserInputService.TouchTap:Connect(function(Touches)
		Utilities.Activations.Clicked:Fire(nil, "Touch", Touches[1])
	end)
	
	UserInputService.TouchLongPress:Connect(function(Touches, State)
		if State == Enum.UserInputState.Begin then
			Utilities.Activations.Holding:Fire(nil, true, "Touch")
		elseif State == Enum.UserInputState.End then
			Utilities.Activations.Holding:Fire(nil, false, "Touch")
		end
	end)
	
	-- now this is real pro
	setmetatable(Utilities.Base, {
	    __newindex = function(t, k, v)
	        local Old = rawget(t, k)
	        rawset(t, k, v)
	        t.PropertyChanged:Fire(k, v, Old)
	        t.ChildUpdated:Fire(k, v)
	    end
	})
    --
    
    --// Functions
    do
	    local Functions = {}
	
	    function Functions:Create(Class, Properties)
			local obj = Instance.new(Class)
			for p, v in pairs(Properties or {}) do
				obj[p] = v
			end
			return obj
		end
		
		function Functions:Drawing(Class, Properties)
			local drawing = Drawing.new(Class)
			for p, v in pairs(Properties or {}) do
				obj[p] = v
			end
			return drawing
		end
		--
        Utilities.Functions = Functions -- set to global utilities for further use
    end
    
    -- Tasability
    do
	    local Tasability = {}
	
	    function Tasability.ClearAllFrames()
			Frames = {}
		    Index = 1
		    Frozen = false
		    Writing = false
		    Reading = false
	    end
	
		function Tasability.ToggleFrozen()
			Frozen = not Frozen
		    Writing = not Frozen
	    end
	
		function Tasability.SpectateMode()
			Reading = false
		    Writing = false
			Frozen = false
	    end
	
		function Tasability.CreateMode()
			Writing = true
			Reading = false
		    Frozen = true
	    end
	
		function Tasability.TestTasMode()
			Reading = true
		    Writing = false
			Frozen = false
			Index = 1
	    end
	
		function Tasability.SetFrame(Value)
		    if Value < 1 or Value > #Frames then return end
		    Index = Value
		
		    local Frame = Frames[Index]
		    if not Frame then return end
		
		    HumanoidRootPart.CFrame = DeserializeValue(Frame[1])
		    Camera.CFrame = DeserializeValue(Frame[2])
		    HumanoidRootPart.Velocity = DeserializeValue(Frame[3])
		    HumanoidRootPart.AssemblyLinearVelocity = DeserializeValue(Frame[4])
		    HumanoidRootPart.AssemblyAngularVelocity = DeserializeValue(Frame[5])
            
		    Humanoid:ChangeState(Enum.HumanoidStateType[Frame[6]])
            Utilities.CameraModule.UpdateZoom(tonumber(Frame[7]))

		    Frozen = true
		end
	
		function Tasability.GetReplayFiles()
		    local FolderPath = Configuration.Directory .. Configuration.Folders[1]
		    local Files = {}
		    for _, File in ipairs(listfiles(FolderPath)) do
		        local FileName = File:match("[^/\\]+$"):gsub("%.json$", "")
		        table.insert(Files, FileName)
		    end
		    return Files
		end
	
		function Tasability.CreateFile(Name)
		    local FolderPath = Configuration.Directory .. Configuration.Folders[1]
		    local FilePath = FolderPath .. "/" .. Name .. ".json"
		
		    if isfile(FilePath) then
		        warn("File already exists: " .. FilePath)
		        return false
		    end
		
		    writefile(FilePath, "wow an empty file")
		    print("File created:", FilePath)
			return true
		end
		
		function Tasability.DeleteFile(Name)
            if Name and Name ~= "" then
                return
            end

		    local FolderPath = Configuration.Directory .. Configuration.Folders[1]
		    local FilePath = FolderPath .. "/" .. Name .. ".json"
		
		    if not isfile(FilePath) then
		        warn("File does not exist: " .. FilePath)
		        return false
		    end
		
		    delfile(FilePath)
		    print("File deleted:", FilePath)
		    return true
		end
	
		function Tasability.SaveFile(Name)
		    local FolderPath = Configuration.Directory .. Configuration.Folders[1]
		    local FilePath = FolderPath .. "/" .. Name .. ".json"
		
		    if not isfile(FilePath) then
		        warn("File does not exist: " .. FilePath)
		        return false
		    end
		
		    local Success, Encoded = pcall(function()
		        if Configuration.PrettyFormatting then
		            return Json.PrettyEncode(Frames, 4)
		        else
		            return Json.Encode(Frames)
		        end
		    end)
		
		    if not Success then
		        warn("Failed to encode Frames to JSON:", Encoded)
		        return false
		    end
		
		    writefile(FilePath, Encoded)
		    print("Saved TAS file:", FilePath, " (pretty =", tostring(Configuration.PrettyFormatting), ")")
		    return true
		end
		
		function Tasability.LoadFile(Name)
		    local FolderPath = Configuration.Directory .. Configuration.Folders[1]
		    local FilePath = FolderPath .. "/" .. Name .. ".json"
		
		    if not isfile(FilePath) then
		        warn("File does not exist: " .. FilePath)
		        return false
		    end
		
		    local Data = readfile(FilePath)
		
		    local Success, Decoded = pcall(function()
		        local Parsed, _ = Json.Parse(Data)
		        return Parsed
		    end)
		
		    if not Success or type(Decoded) ~= "table" then
		        warn("failed to decode JSON from file:", Name)
		        return false
		    end
		
		    Frames = Decoded
		    print("[yippe]: loaded TAS file:", FilePath)
		    return true
		end
		--
		Utilities.Tasability = Tasability -- set to global utilities for further use
    end
    
    -- Camera Module
    do
		local CameraModule = {}
		CameraModule.__index = CameraModule
		CameraModule.ClassName = "ModuleScript"
		CameraModule.ZoomController = nil
		CameraModule.MouseLockController = nil
		
		-- Closure Scanner
		do
			for _, Obj in next, getgc(true) do
			    if type(Obj) == "table" then
			        if rawget(Obj, "Update") and rawget(Obj, "SetZoomParameters") then
			            CameraModule.ZoomController = Obj
			        elseif rawget(Obj, "GetIsMouseLocked") and rawget(Obj, "EnableMouseLock") then
			            CameraModule.MouseLockController = Obj
			        end
			    end
			end
		end
		
		-- Zoom Controller
		function CameraModule.GetZoom()
			local ZoomCtrl = CameraModule.ZoomController
			if not ZoomCtrl then
				return 12.5
			end
		
			local Upvalues = getupvalues(ZoomCtrl.Update)
			for _, V in pairs(Upvalues) do
				if type(V) == "table" and rawget(V, "x") and rawget(V, "goal") then
					return V.x
				end
			end
		
			return 12.5
		end
		
		function CameraModule.UpdateZoom(Value)
		    if CameraModule.ZoomController then
		        CameraModule.ZoomController.SetZoomParameters(Value, 0)
		    end
		end
		
		function CameraModule.ReleaseZoom()
		    if CameraModule.ZoomController then
		        CameraModule.ZoomController.ReleaseSpring()
		    end
		end
		
		-- ShiftLock
		function CameraModule.GetShiftLock()
		    -- idfk how to do this :v: :sob:
		end
		
		function CameraModule.SetShiftLock(Value)
		    
		end
		--
		Utilities.CameraModule = CameraModule -- set to global utilities for further use
	end
    --
end




-- Helper Functions
local function ToKeyCode(Key)
    if typeof(Key) == "EnumItem" and Key.EnumType == Enum.KeyCode then
        return Key
    end
    if type(Key) == "string" then
        local CleanKey = Key:lower():gsub("%s+", "")
        for _, EnumKey in pairs(Enum.KeyCode:GetEnumItems()) do
            if EnumKey.Name:lower() == CleanKey then
                return EnumKey
            end
        end
        warn("[ToKeyCode] Could not find EnumKey for string:", Key)
    end
    return nil
end



--
-- where actually the ui starts
-- thanks for serick/void/plugiant tas for this ui fuz i couldn't figure this confusing ui lib out lol
local ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'))()
local PrefabsId = "rbxassetid://" .. ReGui.PrefabsId

-- Declare the Prefabs asset
ReGui:Init{Prefabs = InsertService:LoadLocalAsset(PrefabsId)}
ReGui:DefineElement("Textbox", {
	Base = {
		Value = "",
		Placeholder = "",
		Label = "Input text",
		Callback = EmptyFunction,
		MultiLine = false,
		NoAutoTag = true,
		Disabled = false
	},
	Create = function(Canvas, Config: InputText): InputText
		-- Unpack configuration
		local MultiLine = Config.MultiLine
		local Placeholder = Config.Placeholder
		local Label = Config.Label
		local Disabled = Config.Disabled
		local Value = Config.Value

		-- Create Text input object
		local Object = ReGui:InsertPrefab("InputBox", Config)
		local Frame = Object.Frame
		local TextBox = Frame.Input

		local Class = ReGui:MergeMetatables(Config, Object)

		Canvas:Label({
			Parent = Object,
			Text = Label,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(0, 19),
			Position = UDim2.new(1, 4),
			LayoutOrder = 2
		})

		ReGui:SetProperties(TextBox, {
			PlaceholderText = Placeholder,
			MultiLine = MultiLine
		})

		local function Callback(...)
		    local Func = Config.Callback or function() end
		    
		    if debug.info and debug.info(Func, "a") > 0 then
		        return Func(Class, ...)
		    else
		        return Func(...)
		    end
		end

		function Config:SetValue(Value: string?)
			TextBox.Text = tostring(Value)
			self.Value = Value
			return self
		end

		function Config:SetDisabled(Disabled: boolean)
			self.Disabled = Disabled
			Object.Interactable = not Disabled
			Canvas:SetColorTags({
				[Label] = Disabled and "LabelDisabled" or "Label"
			}, true)
			return self
		end

		function Config:Clear()
			TextBox.Text = ""
			return self
		end

		local function TextChanged()
			local Value = TextBox.Text
			Config.Value = Value
			Callback(Value)
		end

		-- Connect events
		TextBox.FocusLost:Connect(function(enter, inputObject)
            TextChanged()
        end)

		-- Update object state
		Config:SetDisabled(Disabled)
		Config:SetValue(Value)

		Canvas:TagElements({
			[TextBox] = "Frame"
		})

		return Class, Object
	end,
})

local Window = ReGui:TabsWindow{
    Title = "Nymera Tasability - " .. Version .. " | The newly rewrite trust",
    Size = DimOffset(550, 350),
    NoScroll = false
}

local ConsoleWindow = ReGui:Window{
    Title = "Console",
    Size = DimOffset(400, 300),
    NoScroll = true
}

local Main = Window:CreateTab{Name = "Main"}
local Info = Window:CreateTab{Name = "Info"}
local Keybind = Window:CreateTab{Name = "Keybind"}

-- Console Elements
local RealConsole = ConsoleWindow:Console{
    Enabled = true,
    ReadOnly = true
}

local ConsoleCommandInput = ConsoleWindow:Textbox{Label = "Enter command here"}
ConsoleWindow:ToggleVisibility()

-- Menu Bar
local MenuBar = Window:MenuBar()
local Menu = MenuBar:MenuItem{Text = "File Management"}

Menu:Selectable{Text = "Create File",Callback = function()
    local PopupModal = Window:PopupModal{Title = "Create File"}
    PopupModal:Textbox{Text = "Enter File Name", Placeholder = "File name...", Callback = function(_, Name)
        ReplayName = Name
    end}
    PopupModal:Button{Text = "Create", Callback = function()
        local DidCreate = Utilities.Tasability.CreateFile(ReplayName)
        if DidCreate then
            print("File created successfully: " .. ReplayName)
        else
            local ExistPopup = Window:PopupModal{Title = "File Exists"}
            ExistPopup:Button{Text = "Ok", Callback = function()
                ExistPopup:ClosePopup()
            end}
        end
        PopupModal:ClosePopup()
    end}
    PopupModal:Button{Text = "Nevermind",Callback = function()
        PopupModal:ClosePopup()
    end}
end}
Menu:Selectable{Text = "Save to File", Callback = function()
    local PopupModal = Window:PopupModal{Title = "Save File"}
    PopupModal:Combo{Text = "Select file", Placeholder = "Select file to overwrite", GetItems = Utilities.Tasability.GetReplayFiles, Callback = function(_, FileName)
        ReplayFile = FileName
    end}
    PopupModal:Button{Text = "Save", Callback = function()
        Utilities.Tasability.SaveFile(ReplayFile)
        PopupModal:ClosePopup()
    end}
    PopupModal:Button{Text = "Nevermind", Callback = function()
        PopupModal:ClosePopup()
    end}
end}
Menu:Selectable{Text = "Load File", Callback = function()
    local PopupModal = Window:PopupModal{Title = "Load File"}
    PopupModal:Combo{Text = "Select file", Placeholder = "Select file to load", GetItems = Utilities.Tasability.GetReplayFiles, Callback = function(_, FileName)
        ReplayFile = FileName
    end}
    PopupModal:Button{Text = "Load", Callback = function()
        Utilities.Tasability.LoadFile(ReplayFile)
        PopupModal:ClosePopup()
    end}
    PopupModal:Button{Text = "Nevermind", Callback = function()
        PopupModal:ClosePopup()
    end}
end}
Menu:Selectable{Text = "Delete File", Callback = function()
    local PopupModal = Window:PopupModal{Title = "Delete File"}
    PopupModal:Combo{Text = "Select file", Placeholder = "Delete file here", GetItems = Utilities.Tasability.GetReplayFiles, Callback = function(_, FileName)
        ReplayFile = FileName
    end}
    PopupModal:Button{Text = "Delete", Callback = function()
        Utilities.Tasability.DeleteFile(ReplayFile)
        PopupModal:ClosePopup()
    end}
    PopupModal:Button{Text = "Nevermind", Callback = function()
        PopupModal:ClosePopup()
    end}
end}
Menu:Selectable{Text = "Console", Callback = function()
    ConsoleWindow:ToggleVisibility()
end}
Main:Checkbox{Label = "Playback Inputs",Value = Configuration.PlaybackInputs, Callback = function(self)
    Configuration.PlaybackInputs = self.Value
end}
Main:Checkbox{Label = "Playback Mouse Location", Value = Configuration.PlaybackMouseLocation, Callback = function(self)
    Configuration.PlaybackMouseLocation = self.Value
end}
Main:Checkbox{Label = "Bypass Anti Cheat", Value = Configuration.BypassAntiCheat, Callback = function(self)
    Configuration.BypassAntiCheat = self.Value
end}
Main:Checkbox{Label = "Pretty Formating", Value = Configuration.PrettyFormating, Callback = function(self)
    Configuration.PrettyFormating = self.Value
end}
Main:Button{Text = "Jump/Edit to Last Frame", Callback = function()
    Utilities.Tasability.SetFrame(#Frames)
end}

local CurrentReplayFile = Info:Label{Text = "Current Replay File: None"}
local CurrentFrameIndex = Info:Label{Text = "Current Frame index: ???"}
local CurrentZoomValue = Info:Label{Text = "Current Zoom value: ???"}

Keybind:Keybind{Label = "Menu Bind", Value = ToKeyCode(Configuration.MenuBind), Callback = function(self, KeyId)
    Configuration.MenuBind = KeyId
end}
Keybind:Keybind{Label = "Frozen", Value = ToKeyCode(Configuration.Keybind.Frozen), Callback = function(self, KeyId)
    Configuration.Keybind.Frozen = KeyId
end}
Keybind:Keybind{Label = "Wipe", Value = ToKeyCode(Configuration.Keybind.Wipe), Callback = function(self, KeyId)
    Configuration.Keybind.Wipe = KeyId
end}
Keybind:Keybind{Label = "Spectate", Value = ToKeyCode(Configuration.Keybind.Spectate), Callback = function(self, KeyId)
    Configuration.Keybind.Spectate = KeyId
end}
Keybind:Keybind{Label = "Create", Value = ToKeyCode(Configuration.Keybind.Create), Callback = function(self, KeyId)
    Configuration.Keybind.Create = KeyId
end}
Keybind:Keybind{Label = "Test", Value = ToKeyCode(Configuration.Keybind.Test), Callback = function(self, KeyId)
    Configuration.Keybind.Test = KeyId
end}

local CursorHolder = Utilities.Functions:Create("ScreenGui", {
	Name = "okay",
	DisplayOrder = 9999,
	ZIndexBehavior = Enum.ZIndexBehavior.Global,
	Parent = gethui()
})

local MainCursor = Utilities.Functions:Create("ImageLabel", {
	Name = "okay",
	Parent = CursorHolder
})

-- Set up
Utilities.KeyDown:Connect(function(KeyCode)
    if KeyCode == ToKeyCode(Configuration.Keybind.Frozen) then
        Utilities.Tasability.ToggleFrozen()
    elseif KeyCode == ToKeyCode(Configuration.Keybind.Wipe) then
        Utilities.Tasability.ClearAllFrames()
    elseif KeyCode == ToKeyCode(Configuration.Keybind.Spectate) then
        Utilities.Tasability.SpectateMode()
    elseif KeyCode == ToKeyCode(Configuration.Keybind.Create) then
        Utilities.Tasability.CreateMode()
    elseif KeyCode == ToKeyCode(Configuration.Keybind.Test) then
        Utilities.Tasability.TestTasMode()
    elseif KeyCode == ToKeyCode(Configuration.MenuBind) then
	    Window:ToggleVisibility()
    end
end)

-- Mouse
Insert(Configuration.Connections, RunService.RenderStepped:Connect(function()
	if Configuration.PlaybackMouseLocation and Reading and not Writing then
		local MouseLocation = UserInputService:GetMouseLocation()
		--MainCursor.Position = 
	end
end))

-- Reading
Insert(Configuration.Connections, RunService.RenderStepped:Connect(function()
    if Reading and not Writing then
	    if not Character:FindFirstChild("HumanoidRootPart") then
			RunService.Heartbeat:Wait()
			return
		end
		
        if Index <= #Frames then
            local Frame = Frames[Index]
            if Frame then
                local HumanoidRootPartCFrame = DeserializeValue(Frame[1])
                local CameraCFrame = DeserializeValue(Frame[2])
                local Velocity = DeserializeValue(Frame[3])
                local AssemblyLinearVelocity = DeserializeValue(Frame[4])
                local AssemblyAngularVelocity = DeserializeValue(Frame[5])
                local State = Frame[6]
                local Zoom = Frame[7]
                
                HumanoidRootPart.CFrame = HumanoidRootPartCFrame
                HumanoidRootPart.Velocity = Velocity
                HumanoidRootPart.AssemblyLinearVelocity = AssemblyLinearVelocity
                HumanoidRootPart.AssemblyAngularVelocity = AssemblyAngularVelocity
                Camera.CFrame = CameraCFrame
                
                Humanoid:ChangeState(Enum.HumanoidStateType[State])
                Utilities.CameraModule.UpdateZoom(tonumber(Zoom)) -- tonumber useless but idaf 💔
            end

            Index = Index + 1
        else
            Index = 1
            Reading = false
        end
    end
end))

-- Writing
Insert(Configuration.Connections, RunService.PreSimulation:Connect(function()
    if Writing and not Reading and not Frozen then
        local HumanoidRootPartCFrame = HumanoidRootPart.CFrame
        local CameraCFrame = Camera.CFrame
        local Velocity = HumanoidRootPart.Velocity
        local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity
        local AssemblyAngularVelocity = HumanoidRootPart.AssemblyAngularVelocity
        local State = Humanoid:GetState().Name
		local Zoom = Utilities.CameraModule.GetZoom()
		
        Insert(Frames, {
            HumanoidRootPartCFrame,
            CameraCFrame,
            Velocity,
            AssemblyLinearVelocity,
            AssemblyAngularVelocity,
            State,
            Zoom
        })
        
        --
        Index = Index + 1
    end
end))

-- Frozen
Insert(Configuration.Connections, RunService.RenderStepped:Connect(function()
	HumanoidRootPart.Anchored = Frozen
    if Frozen and not Reading then
        local Frame = Frames[#Frames]
        if Frame then
            local HumanoidRootPartCFrame = DeserializeValue(Frame[1])
            local CameraCFrame = DeserializeValue(Frame[2])
            local Velocity = DeserializeValue(Frame[3])
            local AssemblyLinearVelocity = DeserializeValue(Frame[4])
            local AssemblyAngularVelocity = DeserializeValue(Frame[5])
            local State = Frame[6]
            local Zoom = Frame[7]
            
            HumanoidRootPart.Anchored = true
            HumanoidRootPart.CFrame = HumanoidRootPartCFrame
            HumanoidRootPart.Velocity = Velocity
            HumanoidRootPart.AssemblyLinearVelocity = AssemblyLinearVelocity
            HumanoidRootPart.AssemblyAngularVelocity = AssemblyAngularVelocity
            Camera.CFrame = CameraCFrame
            
            Humanoid:ChangeState(Enum.HumanoidStateType[State])
            Utilities.CameraModule.UpdateZoom(tonumber(Zoom)) -- tonumber useless but idaf 💔
        end
    end
end))

-- Labels
Insert(Configuration.Connections, RunService.RenderStepped:Connect(function()
    if ReplayFile then
        CurrentReplayFile.Text = "Current Replay File: " .. tostring(ReplayFile)
    else
        CurrentReplayFile.Text = "Current Replay File: None"
    end
    CurrentFrameIndex.Text = "Current Frame index: " .. tostring(Index)
    CurrentZoomValue.Text = "Current Zoom value: " .. Floor(Utilities.CameraModule.GetZoom() * 100) / 100
end))

--
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
end)

--

for i = 1, 3 do -- unnecessary but i like it
	task.wait()
end
-- man i just wnna kms :pensive:
