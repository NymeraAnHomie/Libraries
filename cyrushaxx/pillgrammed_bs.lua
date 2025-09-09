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

local NPCsList = {}
local CFrames = {}

local ActiveTween = nil

for _, Npc in ipairs(Workspace.NPCs:GetChildren()) do
    if Npc:FindFirstChild("HumanoidRootPart") then
        table.insert(NPCsList, Npc.Name)
    end
end

table.sort(NPCsList, function(a, b)
    return string.lower(a) < string.lower(b)
end)

local Utilities = Kiwisense.Utilities
local Connections = Kiwisense.Connections
local Drawings = Kiwisense.Drawings
local Signal = Kiwisense.Signal

local Library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/NymeraAnHomie/Library/refs/heads/main/OrionLib/Source.lua')))()
local Flags = OrionLib.Flags

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

function TeleportCFrame(CFrameTarget, OrInstant, Speed)
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end

    if OrInstant or Flags["Teleporting%%Tweening Method"].Value == "Instant" then
        if ActiveTween then
            ActiveTween:Cancel()
            ActiveTween = nil
        end
        HumanoidRootPart.CFrame = CFrameTarget
    else
        if ActiveTween then
            ActiveTween:Cancel()
            ActiveTween = nil
        end

        local TweenInfoObject = TweenInfo.new(
            (HumanoidRootPart.Position - CFrameTarget.Position).Magnitude / (Flags["Teleporting%%Tweening Speed"].Value or 5),
            Enum.EasingStyle.Linear
        )
        ActiveTween = game:GetService("TweenService"):Create(HumanoidRootPart, TweenInfoObject, {CFrame = CFrameTarget})
        ActiveTween:Play()

        ActiveTween.Completed:Connect(function()
            ActiveTween = nil
        end)
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
	
	local Teleporting = Window:MakeTab{Name = "Teleporting", Icon = "rbxassetid://4483345998"} do
		Teleporting:AddSection{Name = "Method"}
		Teleporting:AddDropdown{Name = "Mode", Default = "Instant", Options = {"Instant", "Tween"}, Flag = "Teleporting%%Tweening Method"}
		Teleporting:AddSlider{Name = "Tweening Speed", Max = 600, Default = 5, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "x", Flag = "Teleporting%%Tweening Speed"}

		Teleporting:AddSection{Name = "NPCs"} -- Workspace.NPCs.Abraska.HumanoidRootPart
		local NPCTarget = Teleporting:AddDropdown{Name = "Target", Default = "kys", Options = NPCsList, Flag = "Teleporting%%NPCs Target Dropdown"}
		Teleporting:AddToggle{Name = "Start", Flag = "Teleporting%%Start Teleporting"}
	end
	
	OrionLib:WindowMobileToggle{}
end

Kiwisense:Connection(RunService.RenderStepped, function()
    if Flags["Teleporting%%Start Teleporting"].Value then
        local TargetName = Flags["Teleporting%%NPCs Target Dropdown"].Value
        local Target = Workspace.NPCs:FindFirstChild(TargetName)
        if Target and Target:FindFirstChild("HumanoidRootPart") then
            TeleportCFrame(Target.HumanoidRootPart.CFrame, false, Flags["Teleporting%%Tweening Speed"].Value)
        end
    else
        if ActiveTween then
            ActiveTween:Cancel()
            ActiveTween = nil
        end
    end

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
