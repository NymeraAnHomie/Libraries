local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local LocalPlayerScripts = LocalPlayer.PlayerScripts
local Character = LocalPlayer.Character
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

local Vec2 = Vector2.new
local Vec3 = Vector3.new
local Dim2 = UDim2.new
local Dim = UDim.new
local Rect = Rect.new
local Cfr = CFrame.new
local EmptyCfr = Cfr()
local PointObjectSpace = EmptyCfr.PointToObjectSpace
local Angle = CFrame.Angles
local DimOffset = UDim2.fromOffset

local Color = Color3.new
local Rgb = Color3.fromRGB
local Hex = Color3.fromHex
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

local Kiwisense = {
	Utilities = {},
	Connections = {},
	Drawings = {},
	Signal = {
		_Callbacks = {},
		_Signals = {}
	}
}

local Utilities = Kiwisense.Utilities
local Connections = Kiwisense.Connections
local Drawings = Kiwisense.Drawings
local Signal = Kiwisense.Signal

local Library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/NymeraAnHomie/Library/refs/heads/main/OrionLib/Source.lua')))()
local Flags = OrionLib.Flags

local CFrames = {
	--["Teleport"] = Cfr()
}

do
    local EnableTraceback = false
    local Registry = { Signals = {}, Callbacks = {} }
    Signal.__index = Signal
    Signal.ClassName = "Signal"

    function Signal.New()
        local Self = setmetatable({}, Signal)

        Self.Bindable = Instance.new("BindableEvent")
        Self.ArgMap = {}
        Self.Source = EnableTraceback and traceback() or ""

        Self.Bindable.Event:Connect(function(Key)
            Self.ArgMap[Key] = nil
            if (not Self.Bindable) and (not next(Self.ArgMap)) then
                Self.ArgMap = nil
            end
        end)

        return Self
    end

    function Signal:Fire(...)
        if not self.Bindable then return end
        local Args = { ... }
        local Key = 1 + #self.ArgMap
        self.ArgMap[Key] = Args
        self.Bindable:Fire(Key)
    end

    function Signal:Connect(Fn)
        assert(type(Fn) == "function", "Connect expects a function")
        return self.Bindable.Event:Connect(function(Key)
            Fn(unpack(self.ArgMap[Key]))
        end)
    end

    function Signal:Wait()
        local Key = self.Bindable.Event:Wait()
        local Args = self.ArgMap[Key]
        if Args then
            return unpack(Args)
        else
            error("Missing Arg Data")
        end
    end

    function Signal:Destroy()
        if self.Bindable then
            self.Bindable:Destroy()
            self.Bindable = nil
        end
        setmetatable(self, nil)
    end

    function Signal.Add(Name, Fn)
        if type(Name) == "string" and type(Fn) == "function" then
            Registry.Callbacks[Name] = Fn
        end
    end

    function Signal.Run(Name, ...)
        local Callback = Registry.Callbacks[Name]
        if Callback then
            return Callback(...)
        end
    end

    function Signal.Remove(Name)
        Registry.Callbacks[Name] = nil
    end

    function Signal.Wrap(Name)
        return function(...)
            local Sig = Signal.Get(Name)
            if Sig and Sig.Fire then
                Sig:Fire(...)
            end
        end
    end

    function Signal.NewInstance()
        local S = Signal.New()
        return {
            Event = S,
            Fire = function(_, ...) S:Fire(...) end,
            Connect = function(_, Fn) return S:Connect(Fn) end,
            Destroy = function() S:Destroy() end,
        }
    end

    function Signal.NewNamed(Name)
        if not Registry.Signals[Name] then
            Registry.Signals[Name] = Signal.NewInstance()
        end
        return Registry.Signals[Name]
    end

    function Signal.Get(Path)
        local Segments = {}
        for Segment in string.gmatch(Path, "[^%.]+") do
            table.insert(Segments, Segment)
        end

        local Cursor = Registry.Signals
        for I = 1, #Segments do
            local Part = Segments[I]
            if I == #Segments then
                if not Cursor[Part] then
                    Cursor[Part] = Signal.NewInstance()
                end
                return Cursor[Part]
            else
                Cursor[Part] = Cursor[Part] or {}
                Cursor = Cursor[Part]
            end
        end
    end

    Utilities.Signal = Signal
end

do
    function Kiwisense:Connection(Signal, Callback)
		local Connection = Signal:Connect(Callback)
		Insert(Kiwisense.Connections, Connection)
		return Connection
	end
	
	function OrionLib:FlaggableElement(Properties, ElementType, Tab) -- ts is so frikin tuff
		local InternalState = self._InternalState or {}
		self._InternalState = InternalState
	
		local ElementId = Properties.Id or Properties.Name or "UnnamedElement"
	
		local function SetValue(Value)
			InternalState[ElementId] = Value
			if Properties.Callback then
				Properties.Callback(Value)
			end
		end
	
		local Element
		if ElementType == "Textbox" then
			Element = Tab:AddTextbox({Name = Properties.Name or "Textbox", Default = Properties.Default or "", TextDisappear = Properties.TextDisappear or false, Callback = SetValue})
			SetValue(Properties.Default or "")
		elseif ElementType == "Button" then
			Element = Tab:AddButton({Name = Properties.Name or "Button", Callback = function()
				SetValue(true)
			end})
		elseif ElementType == "Label" then
			Element = Tab:AddLabel(Properties.Name or "Label")
			SetValue(Properties.Name or "")
		elseif ElementType == "Paragraph" then
			Element = Tab:AddParagraph(Properties.Name or "Paragraph", Properties.Content or "")
			SetValue(Properties.Content or "")
		end
	
		return {
			Set = SetValue,
			Get = function()
				return InternalState[ElementId]
			end,
			Element = Element
		}
	end
end

local AutoParryInterval

local Window = Library:MakeWindow{Name = "cyrushaxx but it fucking dying 5000 TUBERCULOSIS", ConfigFolder = nil} do
	local Combat = Window:MakeTab{Name = "Combat", Icon = "rbxassetid://4483345998"} do
		Combat:AddSection{Name = "Auto Parry"}
		Combat:AddToggle{Name = "Enabled", Flag = "Auto Parry%%Enabled"}
		
		AutoParryInterval = OrionLib:FlaggableElement({Name = "Interval", Default = "0.25"}, "Textbox", Combat)
		
		Combat:AddSection{Name = "Auto Roll"}
		Combat:AddParagraph("Importance", "This won't actually make you godmode but decreases the chance of taking damage")
		Combat:AddToggle{Name = "Enabled", Flag = "Auto Roll%%Enabled"}
	end
	
	OrionLib:WindowMobileToggle{}
end

Kiwisense:Connection(RunService.RenderStepped, function()
	if Flags["Auto Parry%%Enabled"].Value then
		if math.floor(tick() / tonumber(AutoParryInterval.Get() or "")) ~= math.floor((tick() - 0.016) / tonumber(AutoParryInterval.Get() or "")) then
			ReplicatedStorage.Remotes.Block:FireServer(true)
			ReplicatedStorage.Remotes.Block:FireServer(false)
		end
	end

	if Flags["Auto Roll%%Enabled"].Value then
		ReplicatedStorage.Remotes.Roll:FireServer()
	end
end)
