local ReadInputs = true
local ReadCursor = true
local Controls = {
    Frozen = "E",
    Wipe = "Delete",
    PauseReading = "K",
    Spectate = "One",
    Create = "Two",
    Test = "Three",
	AdvanceFrame = "G",
    Backward = "N",
    Forward = "B",
    LoopBackward = "C",
    LoopForward = "V"
}

local InputBlacklist = {
	["E"] = true,
	["K"] = true,
	["G"] = true,
	["N"] = true,
	["C"] = true,
    ["V"] = true
}

local Cursors = {
	["ArrowFarCursor"] = { -- Default
		Icon = "rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png";
		Size = UDim2.fromOffset(64,64);
		Offset = Vector2.new(-32,4);
	};
	["MouseLockedCursor"] = { -- Shiftlock
		Icon = "rbxasset://textures/MouseLockedCursor.png";
		Size = UDim2.fromOffset(32,32);
		Offset = Vector2.new(-16,20);
	};
}
















-- End of config

local shared = getgenv()


-- kms
-- who tf use cloneref frfr

local ReadInputs = true
local ReadCursor = true
local Controls = {
    Frozen = "E",
    Wipe = "Delete",
    PauseReading = "K",
    Spectate = "One",
    Create = "Two",
    Test = "Three",
	AdvanceFrame = "G",
    Backward = "N",
    Forward = "B",
    LoopBackward = "C",
    LoopForward = "V"
}

local InputBlacklist = {
	["E"] = true,
	["K"] = true,
	["G"] = true,
	["N"] = true,
	["C"] = true,
    ["V"] = true
}

local Cursors = {
	["ArrowFarCursor"] = { -- Default
		Icon = "rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png",
		Size = UDim2.fromOffset(64,64),
		Offset = Vector2.new(-32,4),
	},
	["MouseLockedCursor"] = { -- Shiftlock
		Icon = "rbxasset://textures/MouseLockedCursor.png",
		Size = UDim2.fromOffset(32,32),
		Offset = Vector2.new(-16,20),
	},
}
















-- End of config

local shared = getgenv()

-- Constants
local Version = "V1.4"
local Title = "Tasability - Orion Edition - " .. tostring(Version)
local TasFilePath = "Tasability/PC/Files/"
local ConnectionsRequestInputPath = "Tasability/PC/Connections/request.txt"
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart
local Humanoid = Character.Humanoid
local Camera = Workspace.CurrentCamera
local GuiInset = GuiService:GetGuiInset()

local InputCodes = {
	A = true, B = true, C = true, D = true, E = true, F = true,
	G = true, H = true, I = true, J = true, K = true, L = true,
	M = true, N = true, O = true, P = true, Q = true, R = true,
	S = true, T = true, U = true, V = true, W = true, X = true,
	Y = true, Z = true,

	["0"] = true, ["1"] = true, ["2"] = true, ["3"] = true, ["4"] = true,
	["5"] = true, ["6"] = true, ["7"] = true, ["8"] = true, ["9"] = true,

	F1 = true, F2 = true, F3 = true, F4 = true, F5 = true, F6 = true,
	F7 = true, F8 = true, F9 = true, F10 = true, F11 = true, F12 = true,

	Up = true,
	Down = true,
	Left = true,
	Right = true,

	Space = true,
	Tab = true,
	Enter = true,
	Backspace = true,
	Delete = true,
	Insert = true,
	Home = true,
	End = true,
	PageUp = true,
	PageDown = true,

	LeftShift = true,
	RightShift = true,
	LeftCtrl = true,
	RightCtrl = true,
	LeftAlt = true,
	RightAlt = true,

	MB1 = true,
	MB2 = true,
	MB3 = true,

	ScrollUp = true,
	ScrollDown = true,

	Minus = true,
	Plus = true,
	Comma = true,
	Period = true,
	Slash = true,
	Semicolon = true,
	Quote = true,
	LBracket = true,
	RBracket = true,
	Backslash = true,
	Grave = true,

	Num0 = true, Num1 = true, Num2 = true, Num3 = true,
	Num4 = true, Num5 = true, Num6 = true, Num7 = true,
	Num8 = true, Num9 = true,
	NumAdd = true,
	NumSub = true,
	NumMul = true,
	NumDiv = true,
	NumEnter = true,
	NumPeriod = true
}

local HeldKeys = {}

-- Others
local FrameIndexLabel
local PoseLabel
local CurrentAnimLabel
local HumanoidStateLabel
local ZoomLevelLabel
local FrameInputsLabel

-- Local Table
shared.Tasability = shared.Tasability or {}
shared.States = shared.States or {}
shared.Animation = shared.Animation or {}
shared.Frames = shared.Frames or {}
shared.ConnectionFrameInputs = shared.ConnectionFrameInputs or {}
shared.Index = 1
shared.Pose = ""
shared.HumanoidState = ""

-- Flags Variables
local FrameSkipperAmount = 1

-- Variables
local Tasability = shared.Tasability
local States = shared.States
local Animation = shared.Animation
local Frames = shared.Frames

local Index = shared.Index
local Pose = shared.Pose
local HumanoidState = shared.HumanoidState

local CursorHolder = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Cursor = Instance.new("ImageLabel", CursorHolder)
local CursorIcon = nil
local CursorSize = nil
local CursorOffset = nil -- UserInputService:GetMouseLocation()

local PlaybackStart = 0
local Resolution = nil
local EmotePlaying = nil
local LastEmote = nil
local LastFrameEmote = nil
local LastPlayedEmote = nil
local LastFramePose = nil

local IsMobile = UserInputService.TouchEnabled
local MouseLocation = UserInputService:GetMouseLocation()
local ShiftLockEnabled = false

States.Writing = false
States.Reading = false
States.Frozen = false
States.Dead = false
States.IsPaused = false
States.LoopingForward = false
States.LoopingBackward = false
States.Finished = false
States.Tas = nil
States.Name = ""
Animation.Disabled = false

if not isfolder("Tasability") then makefolder("Tasability") end
if not isfolder("Tasability/PC") then makefolder("Tasability/PC") end
if not isfolder("Tasability/PC/Files") then makefolder("Tasability/PC/Files") end
if not isfolder("Tasability/PC/Connections") then makefolder("Tasability/PC/Connections") end
if not isfile("Tasability/PC/Connections/request.txt") then writefile("Tasability/PC/Connections/request.txt", "") end

local function GetFiles()
    local files = listfiles("Tasability/PC/Files")
    local fileNames = {}
    for _, file in ipairs(files) do
        local cleanName = file:match("([^/\\]+)%.json$")
        if cleanName then
            table.insert(fileNames, cleanName)
        end
    end
    return fileNames
end

local function GetKeyCode(control)
    return Enum.KeyCode[control] or nil
end

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/NymeraAnHomie/Library/refs/heads/main/OrionLib/Source.lua')))()
local Window = OrionLib:MakeWindow({Name = Title, IntroText = Title, IntroIcon = "rbxassetid://10734982297", SaveConfig = false, ConfigFolder = "Tasability"})

function Notify(Name, Content, Time)
	if not OrionLib.Flags["Disable Tasability Notifications"].Value then
		OrionLib:MakeNotification({
			Name = Name,
			Content = Content,
			Time = Time
		})
	end
end

-- Signal manager
do
	local Signal = {}
	Signal._callbacks = {}
	Signal._signals = {}

	function Signal:Add(name, callback)
		if type(name) == "string" and type(callback) == "function" then
			self._callbacks[name] = callback
		end
	end

	function Signal:Run(name, ...)
		local cb = self._callbacks[name]
		if cb then
			return cb(...)
		end
	end

	function Signal:Remove(name)
		self._callbacks[name] = nil
	end

	function Signal:Wrap(name)
		return function(...)
			return Signal:Run(name, ...)
		end
	end

	function Signal:New(name)
		local sig = self._signals[name]
		if not sig then
			local bindable = Instance.new("BindableEvent")
			sig = {
				Event = bindable.Event,
				Fire = function(_, ...)
					bindable:Fire(...)
				end,
				Connect = function(_, fn)
					return bindable.Event:Connect(fn)
				end,
				Destroy = function()
					bindable:Destroy()
				end
			}
			self._signals[name] = sig
		end
		return sig
	end

	shared.Signal = Signal
end

-- Functions
do
	local ZoomControllers = {}
	local MouseLockController = {}
	local MouseLockRaw = nil
	local ZoomAPI = nil
	local ZoomSpring = nil
	local LastZoom = nil
	
    -- GetGC Functions
	do
		for _, Object in ipairs(getgc(true)) do
			if type(Object) == "table" then
				if type(rawget(Object, "SetCameraToSubjectDistance")) == "function"
					and type(rawget(Object, "GetCameraToSubjectDistance")) == "function"
					and rawget(Object, "FIRST_PERSON_DISTANCE_THRESHOLD")
					and rawget(Object, "lastCameraTransform") then
					table.insert(ZoomControllers, Object)
				end
		
				if not ZoomAPI
					and rawget(Object, "SetZoomParameters")
					and rawget(Object, "GetZoomRadius") then
					ZoomAPI = Object
				end
		
				if not ZoomSpring
					and typeof(rawget(Object, "goal")) == "number"
					and typeof(rawget(Object, "x")) == "number"
					and typeof(rawget(Object, "v")) == "number" then
					ZoomSpring = Object
				end
			end
		end
		
		for _, Object in ipairs(getgc(true)) do
			if typeof(Object) == "table"
				and rawget(Object, "DoMouseLockSwitch")
				and rawget(Object, "mouseLockToggledEvent")
				and type(rawget(Object, "EnableMouseLock")) == "function"
			then
				MouseLockRaw = Object
				break
			end
		end
	
		print(("# ZoomControllers found: %d"):format(#ZoomControllers))
		print(("# ZoomAPI found: %d"):format(ZoomAPI and 1 or 0))
		print(("# ZoomSpring found: %d"):format(ZoomSpring and 1 or 0))
	
		local function IsFiniteNumber(Value)
			return typeof(Value) == "number" and Value == Value and Value < math.huge
		end
		
		-- Staying Still, Eye Closed
		-- Let the world just pass me byy
		-- Pain pill, nice clothes
		-- if i fall ill think ill flyyy
		-- Touch me, midas
		-- make me part of you're designnn
		-- None to guide us
		-- i feel fear for the very last time

		if not MouseLockRaw then
			warn("MouseLockController not found in memory")
		else
			print("MouseLockController found")
		end

		function MouseLockController.Init()
			if not MouseLockRaw then return end
			MouseLockRaw:EnableMouseLock(true)
			shared.IsLocked = MouseLockRaw:GetIsMouseLocked()
		end
		
		function MouseLockController.SetLocked(State)
			if not MouseLockRaw then return false end
		
			local IsCurrentlyLocked = MouseLockRaw:GetIsMouseLocked()
			if IsCurrentlyLocked ~= State then
				MouseLockRaw:DoMouseLockSwitch("MouseLockSwitchAction", Enum.UserInputState.Begin, game)
				shared.IsLocked = State
				return true
			end
			return false
		end
		
		function MouseLockController.GetLocked()
			return MouseLockRaw and MouseLockRaw:GetIsMouseLocked() or false
		end
	
		function GetZoom()
			if ZoomAPI and typeof(ZoomAPI.GetZoomRadius) == "function" then
				local Success, Value = pcall(ZoomAPI.GetZoomRadius, ZoomAPI)
				if Success and typeof(Value) == "number" then
					return Value
				end
			end
	
			for _, Controller in ipairs(ZoomControllers) do
				local Success, Value = pcall(Controller.GetCameraToSubjectDistance, Controller)
				if Success and typeof(Value) == "number" then
					return Value
				end
			end
	
			local Head = Character and Character:FindFirstChild("Head")
			if Head then
				return (Camera.CFrame.Position - Head.Position).Magnitude
			end
	
			return nil
		end
	
		function SetZoom(ZoomValue)
			if not IsFiniteNumber(ZoomValue) then
				warn("Invalid ZoomValue:", ZoomValue)
				return
			end
		
			if LastZoom and ZoomValue == LastZoom then return end
			LastZoom = ZoomValue
		
			local Success = false
		
			-- ZoomAPI support (default in alot of games)
			if ZoomAPI and typeof(ZoomAPI.SetZoomParameters) == "function" then
				local ok = pcall(function()
					ZoomAPI:SetZoomParameters(ZoomAPI, ZoomValue, 0)
				end)
				if ok then Success = true end
			end
		
			-- ZoomSpring support (legacy spring direct access)
			if not Success and ZoomSpring then
				local ok = pcall(function()
					if typeof(ZoomSpring.goal) == "number"
						and typeof(ZoomSpring.x) == "number"
						and typeof(ZoomSpring.v) == "number" then
						local RealV = rawget(ZoomSpring, "v")
						rawset(ZoomSpring, "goal", ZoomValue)
						rawset(ZoomSpring, "x", ZoomValue)
						rawset(ZoomSpring, "v", RealV)
						Success = true
					end
				end)
			end
		
			-- ZoomControllers (direct distance override)
			for _, Controller in ipairs(ZoomControllers) do
				local ok = pcall(function()
					Controller:SetCameraToSubjectDistance(ZoomValue)
				end)
				if ok then Success = true end
			end
		end
	end

	-- Tasability Functions
	do
		local function SerializeCFrame(cf)
		    return {cf:GetComponents()}
		end
		
		local function DeserializeCFrame(data)
		    return CFrame.new(unpack(data))
		end
		
		local function SerializeVector2(vec)
		    return {vec.X, vec.Y}
		end
		
		local function DeserializeVector2(data)
		    return Vector2.new(unpack(data))
		end
		
		local function SerializeVector3(vec)
		    return {vec.X, vec.Y, vec.Z}
		end
		
		local function DeserializeVector3(data)
		    return Vector3.new(unpack(data))
		end
		
		function WipeTasData()
			Frames = {}
	        Index = 1
	        States.Frozen = false
	        States.Writing = false
	        States.Reading = false
	        Notify("Action", "Wiped and state are set to none.", 3)
		end
		
		function LoadTas(fileName, ShouldRead)
		    local filePath = TasFilePath .. fileName .. ".json"
		    if isfile(filePath) then
		        local fileData = readfile(filePath)
		        local loadedFrames = HttpService:JSONDecode(fileData)
		
		        Frames = {}
				Index = 1
				
		        for _, frameData in ipairs(loadedFrames) do
		            table.insert(Frames, {
		                CFrame = DeserializeCFrame(frameData.CFrame),
		                Camera = DeserializeCFrame(frameData.Camera),
		                Velocity = DeserializeVector3(frameData.Velocity),
		                AssemblyLinearVelocity = DeserializeVector3(frameData.AssemblyLinearVelocity),
		                AssemblyAngularVelocity = DeserializeVector3(frameData.AssemblyAngularVelocity),
						MousePosition = DeserializeVector2(frameData.MousePosition),
                        Zoom = frameData.Zoom,
						Shiftlock = frameData.Shiftlock,
						Pose = frameData.Pose,
						State = frameData.State,
						Emote = frameData.Emote,
						Inputs = frameData.Inputs or {}
		            })
		        end
		        
		        States.Reading = ShouldRead
				States.Finished = false
				PlaybackStart = tick()
		        States.Writing = false
		        States.Frozen = false
				States.IsPaused = false

				Notify("TAS Loaded", "Successfully loaded '" .. fileName .. "' with " .. tostring(#Frames) .. " frames.", 4)
		    else
		        Notify("Error", "TAS file not found", 3)
		    end
		end
		
		function SaveTas(fileName)
		    local path = TasFilePath .. fileName .. ".json"
		    local FileIndex = 1
		    local backupPath
		
		    if isfile(path) then
		        repeat
		            backupPath = path .. FileIndex .. ".bak"
		            FileIndex += 1
		        until not isfile(backupPath)
		
		        FileIndex -= 1
		        backupPath = path .. FileIndex .. ".bak"
		
		        writefile(backupPath, readfile(path))
		        delfile(path)
		    end
		
		    task.wait(0.05)
		
		    local serializedFrames = {}
		    for _, frame in ipairs(Frames) do
		        table.insert(serializedFrames, {
		            CFrame = SerializeCFrame(frame.CFrame),
		            Camera = SerializeCFrame(frame.Camera),
		            Velocity = SerializeVector3(frame.Velocity),
		            AssemblyLinearVelocity = SerializeVector3(frame.AssemblyLinearVelocity),
		            AssemblyAngularVelocity = SerializeVector3(frame.AssemblyAngularVelocity),
		            MousePosition = SerializeVector2(frame.MousePosition),
		            Shiftlock = frame.Shiftlock,
					Zoom = frame.Zoom,
		            Pose = frame.Pose,
		            State = frame.State,
		            Emote = frame.Emote,
					Inputs = frame.Inputs
		        })
		    end
		
		    writefile(path, HttpService:JSONEncode(serializedFrames))
		
		    if FileIndex > 0 then
		        Notify("Action: " .. fileName, "TAS saved with backup v" .. FileIndex, 3)
		    else
		        Notify("Action: " .. fileName, "TAS saved (new file)", 3)
		    end
		end
		
		function CreateTas(Name, Content)
		    local path = TasFilePath .. Name .. ".json"
		
		    if not isfile(path) then
		        writefile(path, Content)
		        Notify("TAS Created", "Saved as: " .. Name .. ".json", 5)
		    else
		        Notify("TAS Already Exists", Name .. ".json was not overwritten", 5)
		    end
		end
	end
	
	-- Utility Functions
	local Utility = {}
	do
		function Utility.CreateInstance(ClassName, Parent, Properties)
			local instance = Instance.new(ClassName)
			if Parent then
				instance.Parent = Parent
			end
			if Properties then
				for property, value in pairs(Properties) do
					instance[property] = value
				end
			end
			return instance
		end
	end
	
	-- Animations
	local CurrentAnim = ""
	local CurrentAnimTrack = nil
	local CurrentAnimInstance = nil
	local CurrentAnimSpeed = 1.0
	
	local ToolAnim = "None"
	local ToolAnimTime = 0
	local ToolAnimTrack = nil
	local ToolAnimInstance = nil
	local CurrentToolAnimKeyframeHandler = nil
	
	local JumpAnimTime = 0
	local JumpAnimDuration = 0.3
	local FallTransitionTime = 0.3
	
	local AnimTable = {}
	local AnimNameLookup = {}
	
	-- Joints
	local Torso = Character:WaitForChild("Torso")
	local RightShoulder = Torso:WaitForChild("Right Shoulder")
	local LeftShoulder = Torso:WaitForChild("Left Shoulder")
	local RightHip = Torso:WaitForChild("Right Hip")
	local LeftHip = Torso:WaitForChild("Left Hip")
	
	local LastTick = tick()
	
	-- Animation Functions. Was originally made by roblox it self but was modified by me
	do
		local AnimNames = { 
			Idle = 	{ { Id = "http://www.roblox.com/asset/?id=180435571", Weight = 8 }, { Id = "http://www.roblox.com/asset/?id=180435792", Weight = 1 } },
			Walk = 	{ { Id = "http://www.roblox.com/asset/?id=180426354", Weight = 10 } }, 
			Running = 	{ { Id = "run.xml", Weight = 10 } }, 
			Jump = 	{ { Id = "http://www.roblox.com/asset/?id=125750702", Weight = 12 } }, 
			Fall = 	{ { Id = "http://www.roblox.com/asset/?id=180436148", Weight = 9 } }, 
			Climb = { { Id = "http://www.roblox.com/asset/?id=180436334", Weight = 10 } }, 
			Sit = 	{ { Id = "http://www.roblox.com/asset/?id=178130996", Weight = 10 } },	
			ToolNone = { { Id = "http://www.roblox.com/asset/?id=182393478", Weight = 10 } },
			ToolSlash = { { Id = "http://www.roblox.com/asset/?id=129967390", Weight = 10 } },
			ToolLunge = { { Id = "http://www.roblox.com/asset/?id=129967478", Weight = 10 } },
			Wave = { { Id = "http://www.roblox.com/asset/?id=128777973", Weight = 10 } },
			Point = { { Id = "http://www.roblox.com/asset/?id=128853357", Weight = 10 } },
			Dance1 = {
				{ Id = "http://www.roblox.com/asset/?id=182435998", Weight = 10 }, 
				{ Id = "http://www.roblox.com/asset/?id=182491037", Weight = 10 }, 
				{ Id = "http://www.roblox.com/asset/?id=182491065", Weight = 10 }
			},
			Dance2 = {
				{ Id = "http://www.roblox.com/asset/?id=182436842", Weight = 10 }, 
				{ Id = "http://www.roblox.com/asset/?id=182491248", Weight = 10 }, 
				{ Id = "http://www.roblox.com/asset/?id=182491277", Weight = 10 }
			},
			Dance3 = {
				{ Id = "http://www.roblox.com/asset/?id=182436935", Weight = 10 }, 
				{ Id = "http://www.roblox.com/asset/?id=182491368", Weight = 10 }, 
				{ Id = "http://www.roblox.com/asset/?id=182491423", Weight = 10 }
			},
			Laugh = { { Id = "http://www.roblox.com/asset/?id=129423131", Weight = 10 } },
			Cheer = { { Id = "http://www.roblox.com/asset/?id=129423030", Weight = 10 } }
		}
		
		for name in pairs(AnimNames) do
			AnimNameLookup[string.lower(name)] = name
		end
		
		local EmoteNames = { wave = true, point = true, dance1 = true, dance2 = true, dance3 = true, laugh = true, cheer = true}
		
		do
			for Name, AnimList in pairs(AnimNames) do
				AnimTable[Name] = { TotalWeight = 0 }
				for _, Data in ipairs(AnimList) do
					local Anim = Instance.new("Animation")
					Anim.AnimationId = Data.Id
					table.insert(AnimTable[Name], {
						Anim = Anim,
						Weight = Data.Weight
					})
					AnimTable[Name].TotalWeight += Data.Weight
				end
			end
			
			function StopAllAnimations(Humanoid)
				for _, Track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
					Track:Stop()
				end
				CurrentAnimTrack = nil
				CurrentAnimInstance = nil
			end
			
			function SetAnimationSpeed(Number)
				if CurrentAnimTrack and Number ~= CurrentAnimSpeed then
					CurrentAnimSpeed = Number
					CurrentAnimTrack:AdjustSpeed(CurrentAnimSpeed)
				end
			end
			
			function PlayAnimation(AnimName, TransitionTime, Humanoid)
				local List = AnimTable[AnimName]
				if not List then return end
			
				local Roll = math.random(1, List.TotalWeight)
				local Index = 1
				while Roll > List[Index].Weight do
					Roll -= List[Index].Weight
					Index += 1
				end
			
				local Anim = List[Index].Anim
			
				if Anim ~= CurrentAnimInstance then
					if CurrentAnimTrack then
						CurrentAnimTrack:Stop(TransitionTime)
						CurrentAnimTrack:Destroy()
					end
			
					CurrentAnimTrack = Humanoid:LoadAnimation(Anim)
					CurrentAnimTrack.Priority = Enum.AnimationPriority.Action
					CurrentAnimTrack:Play(TransitionTime)
					CurrentAnimInstance = Anim
					CurrentAnim = AnimName
			
					if EmoteNames[AnimName:lower()] ~= nil then
						EmotePlaying = AnimName
					else
						EmotePlaying = nil
					end
				end
			end
			
			function PlayToolAnimation(AnimName, TransitionTime, Humanoid, Priority)
				local List = AnimTable[AnimName]
				if not List then return end
				if ToolAnim == "None" and not AnimTable["ToolNone"] then
					return
				end
			
				local Roll = math.random(1, List.TotalWeight)
				local Index = 1
				while Roll > List[Index].Weight do
					Roll -= List[Index].Weight
					Index += 1
				end
			
				local Anim = List[Index].Anim
			
				if Anim ~= ToolAnimInstance then
					if ToolAnimTrack then
						ToolAnimTrack:Stop()
						ToolAnimTrack:Destroy()
					end
			
					ToolAnimTrack = Humanoid:LoadAnimation(Anim)
					ToolAnimTrack.Priority = Priority or Enum.AnimationPriority.Action
					ToolAnimTrack:Play(TransitionTime)
			
					ToolAnimInstance = Anim
					ToolAnim = AnimName
			
					if CurrentToolAnimKeyframeHandler then
						CurrentToolAnimKeyframeHandler:Disconnect()
					end
					CurrentToolAnimKeyframeHandler = ToolAnimTrack.KeyframeReached:Connect(function(name)
						if name == "End" then
							PlayToolAnimation(AnimName, 0.1, Humanoid, Priority)
						end
					end)
				end
			end
			
			function StopToolAnimations()
				if CurrentToolAnimKeyframeHandler then
					CurrentToolAnimKeyframeHandler:Disconnect()
				end
				CurrentToolAnimKeyframeHandler = nil
			
				if ToolAnimTrack then
					ToolAnimTrack:Stop()
					ToolAnimTrack:Destroy()
				end
				ToolAnimTrack = nil
				ToolAnimInstance = nil
				ToolAnim = "None"
			end
			
			function AnimateTool()
				if ToolAnim == "None" then
					PlayToolAnimation("ToolNone", 0.1, Humanoid, Enum.AnimationPriority.Idle)
				elseif ToolAnim == "Slash" then
					PlayToolAnimation("ToolSlash", 0.1, Humanoid, Enum.AnimationPriority.Action)
				elseif ToolAnim == "Lunge" then
					PlayToolAnimation("ToolLunge", 0.1, Humanoid, Enum.AnimationPriority.Action)
				end
			end
			
			function StopEmote()
				if not EmotePlaying then return end
			
				local anims = AnimTable[EmotePlaying]
				if not anims then return end
			
				-- Check if it's an actual emote
				local isEmote = EmoteNames[EmotePlaying:lower()]
				if isEmote == nil then return end
			
				for _, track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
					if track.Animation and track.Animation.AnimationId then
						for _, entry in ipairs(anims) do
							if entry.Anim.AnimationId == track.Animation.AnimationId then
								track:Stop(0.1)
							end
						end
					end
				end
			
				EmotePlaying = nil
			end
			
			function DetectPoseFromState(state)
				if state == Enum.HumanoidStateType.Freefall then
					return "FreeFall"
				elseif state == Enum.HumanoidStateType.Jumping then
					return "Jumping"
				elseif state == Enum.HumanoidStateType.Running then
					return "Running"
				elseif state == Enum.HumanoidStateType.Swimming then
					return "Swimming"
				elseif state == Enum.HumanoidStateType.Climbing then
					return "Climbing"
				elseif state == Enum.HumanoidStateType.Seated then
					return "Seated"
				elseif state == Enum.HumanoidStateType.PlatformStanding then
					return "PlatformStanding"
				elseif state == Enum.HumanoidStateType.Dead then
					return "Dead"
				else
					return "Standing"  
				end
			end

			function Move(Time) -- i dont fw ts
				if Animation.Disabled then return end
			
				local delta = Time - LastTick
				LastTick = Time
			
				if JumpAnimTime > 0 then
					JumpAnimTime -= delta
				end
			
				if Pose == "Running" or Pose == "Standing" then
					AnimateTool()
				end
			
				local amplitude, frequency, set_angles = 1, 1, false
				local climb_fudge = 0
			
				if Pose == "FreeFall" and JumpAnimTime <= 0 then
					if CurrentAnim ~= "Fall" then
						PlayAnimation("Fall", FallTransitionTime, Humanoid)
					end
			
				elseif Pose == "Seated" then
					if CurrentAnim ~= "Sit" then
						PlayAnimation("Sit", 0.5, Humanoid)
					end
					return
			
				elseif Pose == "Running" and JumpAnimTime <= 0 then
					if CurrentAnim ~= "Walk" then
						PlayAnimation("Walk", 0.1, Humanoid)
					end
				
				elseif Pose == "Standing" and JumpAnimTime <= 0 then
					if CurrentAnim ~= "Idle" then
						PlayAnimation("Idle", 0.1, Humanoid)
					end
			
				elseif Pose == "Climbing" then
					if CurrentAnim ~= "Climb" then
						PlayAnimation("Climb", 0.1, Humanoid)
					end
			
				elseif Pose == "Swimming" then
					if CurrentAnim ~= "Swim" then
						PlayAnimation("Swim", 0.1, Humanoid)
					end
			
				elseif Pose == "Jumping" then
					if CurrentAnim ~= "Jump" then
						PlayAnimation("Jump", 0.1, Humanoid)
					end
			
				elseif Pose == "Dead" or Pose == "PlatformStanding" then
					amplitude = 0.1
					frequency = 1
					set_angles = true
				end
			
				if set_angles then
					local desired = amplitude * math.sin(Time * frequency)
					RightShoulder:SetDesiredAngle(desired + climb_fudge)
					LeftShoulder:SetDesiredAngle(desired - climb_fudge)
					RightHip:SetDesiredAngle(-desired)
					LeftHip:SetDesiredAngle(-desired)
				end
			
				local tool = Character:FindFirstChildOfClass("Tool")
				if tool and tool:FindFirstChild("Handle") then
					local anim = tool:FindFirstChild("toolanim")
					if anim and anim:IsA("StringValue") then
						ToolAnim = anim.Value
						anim:Destroy()
						ToolAnimTime = Time + 0.3
					end
			
					if ToolAnimTime > 0 and Time > ToolAnimTime then
						ToolAnimTime = 0
						ToolAnim = "None"
					end
			
					AnimateTool()
				else
					StopToolAnimations()
					ToolAnim = "None"
					ToolAnimTime = 0
				end
			end
			
			-- Connect Events
			Humanoid.StateChanged:Connect(function(_, new)
				if Animation.Disabled then return end
			
				local interrupt = {
					[Enum.HumanoidStateType.Running] = true,
					[Enum.HumanoidStateType.Jumping] = true,
					[Enum.HumanoidStateType.Freefall] = true,
					[Enum.HumanoidStateType.Climbing] = true,
					[Enum.HumanoidStateType.Swimming] = true
				}
			
				if interrupt[new] then
					StopEmote()
				end
			
				Pose = DetectPoseFromState(new)
			end)
			
			Humanoid.Running:Connect(function(speed)
				if Animation.Disabled then return end
			
				local state = Humanoid:GetState()
				if state == Enum.HumanoidStateType.Running or state == Enum.HumanoidStateType.RunningNoPhysics then
					if speed > 0.01 then
						Pose = "Running"
					else
						Pose = "Standing"
					end
				end
			end)
			
			Humanoid.Swimming:Connect(function(speed)
				if Animation.Disabled then return end
				if speed > 0 then
					Pose = "Swimming"
				else
					Pose = "Standing"
				end
			end)
			
			Humanoid.Climbing:Connect(function(speed)
				if Animation.Disabled then return end
				SetAnimationSpeed(speed / 12)
				Pose = "Climbing"
			end)
			
			Humanoid.Jumping:Connect(function()
				if Animation.Disabled then return end
				JumpAnimTime = JumpAnimDuration
				Pose = "Jumping"
			end)
			
			Humanoid.Seated:Connect(function()
				if Animation.Disabled then return end
				Pose = "Seated"
			end)
			
			Humanoid.PlatformStanding:Connect(function()
				if Animation.Disabled then return end
				Pose = "PlatformStanding"
			end)
			
			Humanoid.FallingDown:Connect(function()
				if Animation.Disabled then return end
				Pose = "FallingDown"
			end)
			
			Humanoid.GettingUp:Connect(function()
				if Animation.Disabled then return end
				Pose = "GettingUp"
			end)
			
			Humanoid.Died:Connect(function()
				if Animation.Disabled then return end
				Pose = "Dead"
			end)
			
			LocalPlayer.Chatted:Connect(function(message)
				local args = string.split(message:lower(), " ")
				local command = args[1]
				local input = args[2] or ""
				local inputNum = tonumber(input)
			
				if command == "/e" then
					local emoteName = nil
			
					if input == "dance" then
						emoteName = "Dance1"
					elseif input == "wave" or input == "point" or input == "laugh" or input == "cheer" then
						emoteName = AnimNameLookup[input]
					elseif input == "dance1" or input == "dance2" or input == "dance3" then
						emoteName = AnimNameLookup[input]
					elseif input == "dance" and inputNum then
						emoteName = AnimNameLookup["dance" .. inputNum]
					end
			
					if emoteName then
						PlayAnimation(emoteName, 0.1, Humanoid)
						LastEmote = emoteName
					end
				end
			end)
		
			PlayAnimation("Idle", 0.1, Humanoid)
			Pose = "Standing"
			
			RunService:BindToRenderStep("AnimUpdate", Enum.RenderPriority.Character.Value + 1, function()
				if Character and Character.Parent and not Animation.Disabled then
					local now = tick()
					LastTick = now
					Move(now)
				end
			end)
		end
	end
	
	-- Camera/Input Functions
	local function SendKey(KeyCode, Release)
	    VirtualInputManager:SendKeyEvent(not Release, KeyCode, false, game)
	end
	
	local function isThirdPerson(Threshold)
	    return (Character:WaitForChild("Head").Position - Camera.CFrame.Position).Magnitude > Threshold
	end

	function GetShiftlock()
		if MouseLockController and MouseLockController.GetIsMouseLocked then
			return MouseLockController:GetIsMouseLocked()
		end
		return false
	end
	
	function SetCursor(CursorName, StayinMiddle, Visible)
		local CursorData = Cursors[CursorName]
		CursorIcon = CursorData.Icon
		CursorSize = CursorData.Size
		CursorOffset = CursorData.Offset
	
		CursorHolder.IgnoreGuiInset = true
		CursorHolder.DisplayOrder = 99999
		CursorHolder.ZIndexBehavior = Enum.ZIndexBehavior.Global
		Cursor.Image = CursorIcon
		Cursor.Size = CursorSize
		Cursor.BackgroundTransparency = 1
		Cursor.BorderSizePixel = 0
		Cursor.ZIndex = 9999
		Cursor.Visible = true
		Cursor.Position = UDim2.fromOffset(0, 0)
		Resolution = Camera.ViewportSize
	
		if StayinMiddle then
			Cursor.AnchorPoint = Vector2.new(0.5, 0.5)
		else
			Cursor.AnchorPoint = Vector2.new(0, 0)
		end
	end
	
	function SetFrame(index, preserveFuture)
		if not Frames[index] then return end

		Index = index
		local Frame = Frames[index]

		HumanoidRootPart.CFrame = Frame.CFrame
		HumanoidRootPart.Velocity = Frame.Velocity
		HumanoidRootPart.AssemblyLinearVelocity = Frame.AssemblyLinearVelocity
		HumanoidRootPart.AssemblyAngularVelocity = Frame.AssemblyAngularVelocity
		Camera.CFrame = Frame.Camera
		Humanoid:ChangeState(Enum.HumanoidStateType[Frame.State])
		SetZoom(Frame.Zoom)
		
		if States.Writing and not preserveFuture then
			for i = #Frames, index + 1, -1 do
				table.remove(Frames, i)
			end
		end
	end
	
	function SetShiftLock(Bool)
		if ShiftLockEnabled ~= Bool then
			ShiftLockEnabled = Bool

			if Bool then
				SetCursor("MouseLockedCursor", true)
			else
				SetCursor("ArrowFarCursor", false)
			end
		end
	end
	
	function ConnectionRequestInput(x)
		if ReadInputs then
			writefile(ConnectionsRequestInputPath, table.concat(x, ","))
		end
	end
	
	-- Interface
	do
		local README = Window:MakeTab({Name = "README", Icon = "rbxassetid://10734907168"})
		README:AddParagraph("FPS Importance", "Use a specific FPS cap and do not change it until you're done making a TAS or are currently not working on a TAS. Changing it will lead to incorrect replay speeds (too fast or too slow).")
		README:AddParagraph("Backup System", "Every time a TAS file is saved, a backup is automatically created if the file already exists. These backups are numbered (e.g., .bak1, .bak2, etc.) to ensure previous versions are preserved. This prevents accidental loss of data and lets you recover earlier versions of your TAS.")
		README:AddParagraph("ME!!!!!!!", "do not leave immediately if you're saving an tas bcuz saving delete the file and make it again cuz if u do ur cooked")
		
		local Main = Window:MakeTab({Name = "Main", Icon = "rbxassetid://10723374641"})
		Main:AddSection({Name = "General"})
		local FileDropdown = Main:AddDropdown({Name = "Files",  Options = GetFiles(),  Callback = function(Value)
		    States.Tas = Value
		end})
		Main:AddTextbox({Name = "Name", TextDisappear = false, Callback = function(Value)
		    States.Name = Value
		end})
		Main:AddButton({Name = "Create", Callback = function()
		    CreateTas(States.Name, "[]")
		    FileDropdown:Refresh(GetFiles(), true)
		end})
		Main:AddButton({Name = "Save Selected File", Callback = function()
		    SaveTas(States.Tas)
		    FileDropdown:Refresh(GetFiles(), true)
			task.wait(0.14)
			FileDropdown:Set(tostring(States.Tas))
		end})
		Main:AddButton({Name = "Refresh Lists", Callback = function()
		    FileDropdown:Refresh(GetFiles(), true)
			task.wait(0.14)
			FileDropdown:Set(tostring(States.Tas))
		end})
		Main:AddButton({Name = "Start Writing at the end of selected tas", Callback = function()
			if not States.Tas then
				Notify("Error", "No TAS file selected", 3)
				return
			end

			LoadTas(States.Tas, false)

			if #Frames > 0 then
				SetFrame(#Frames)
			end

			States.Writing = true
			States.Frozen = true
			Notify("Writing Mode", "Now writing at the end of TAS: " .. States.Tas, 3)
		end})

		Main:AddSection({Name = "Frame Skipper"})
		Main:AddTextbox({Name = "Frame Amount", Default = tostring(FrameSkipperAmount), TextDisappear = false, Callback = function(Value)
			local Amount = tonumber(Value)
			if Amount then
				FrameSkipperAmount = Amount
			else
				Notify("Error", "enter a valid number you silly", 3)
			end
		end})
		Main:AddButton({Name = "Skip Forward", Callback = function()
			if States.Reading and States.Tas then
				States.IsPaused = true
				Index = math.min(Index + FrameSkipperAmount, #Frames)
				SetFrame(Index)
				Notify("TAS", "Skipped forward " .. FrameSkipperAmount .. " frames", 3)
			end
		end})

		local Exploits = Window:MakeTab({Name = "Exploits", Icon = "rbxassetid://10734951173"})
		Exploits:AddSection({Name = "General"})
		Exploits:AddToggle({Name = "God Mode", Save = true, Flag = "God Mode"})

		local Settings = Window:MakeTab({Name = "Settings", Icon = "rbxassetid://10734950309"})
		Settings:AddSection({Name = "General"})
		Settings:AddToggle({Name = "Disable Tasability Notification", Save = true, Flag = "Disable Tasability Notifications"})
		Settings:AddToggle({Name = "Disable Finish Notification", Save = true, Flag = "Disable Finish Notifications"})
		Settings:AddToggle({Name = "Disable Frozen Mode Lock Camera", Save = true, Flag = "Disable Frozen Mode Lock Camera"})
		if IsMobile then
			Settings:AddButton({Name = "Wipe All Frame (Mobile)", Callback = WipeTasData})
		end
		Settings:AddButton({Name = "Unload", Callback = function()
		    OrionLib:Destroy()
		end})
		
		local Debugging = Window:MakeTab({Name = "Debugging", Icon = "rbxassetid://10723416057"})
		FrameIndexLabel = Debugging:AddLabel("Frame Index: ")
		PoseLabel = Debugging:AddLabel("Pose: ")
		CurrentAnimLabel = Debugging:AddLabel("Current Animation: ")
		HumanoidStateLabel = Debugging:AddLabel("Humanoid State: ")
		ZoomLevelLabel = Debugging:AddLabel("Zoom Level: ")
		FrameInputsLabel = Debugging:AddLabel("Frame Inputs: ")
	end
	
	-- Anticheat bypasses
	do
		pcall(function() -- Nymera antikick hook
			local oldNamecall
			oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
			    local method = getnamecallmethod()
			    if not checkcaller() and self == LocalPlayer and method == "Kick" then
			        return warn("u almost got kicked lol")
			    end
			    return oldNamecall(self, ...)
			end)
		end)
		pcall(function() -- Practice anticheat bypass
			ReplicatedStorage.Remotes.Send:Destroy()
		end)
		pcall(function() -- Slad anticheat bypass
			local sendremote = ReplicatedStorage.DefaultChatSystemChatEvents.ChannelNameColorUpdated
			local oldspawn
			oldspawn = hookfunction(getrenv().spawn, function(...)
				if not checkcaller() and (tostring(getcallingscript()) == "Animate" or tostring(getcallingscript()) == "RbxAnimateScript") then
					return oldspawn(function()
						
					end)
				end
				return oldspawn(...)
			end)
			sendremote:Destroy()
		end)
	end
	
	-- Exploits Hooks
	do
		pcall(function()
			local oldNamecall
			oldNamecall = hookmetamethod(game, "__namecall", function(self, ...) -- [Title Card]
				local method = getnamecallmethod()
				local args = {...}
				if OrionLib.Flags["God Mode"].Value and self.Name:lower():find("damage") then
					return
				end
				return oldNamecall(self, unpack(args))
			end)
		end)
	end
	
	-- States Hell Incoming!!!
	do
	if IsMobile then
		function Tasability:CreateWindow()
		    local Tas = Utility.CreateInstance("ScreenGui", game:GetService("CoreGui"), {
		        ResetOnSpawn = false,
		        IgnoreGuiInset = true,
		        DisplayOrder = 9999
		    })
		
		    local Frame = Utility.CreateInstance("Frame", Tas, {
		        AutomaticSize = Enum.AutomaticSize.Y,
		        Size = UDim2.new(0, 130, 0, 85),
		        Position = UDim2.new(0.73, 0, 0.44, 0),
		        BorderSizePixel = 0,
		        BorderColor3 = Color3.new(0, 0, 0),
		        BackgroundTransparency = 0.99,
		        BackgroundColor3 = Color3.new(1, 1, 1)
		    })
		
		    Utility.CreateInstance("UIGridLayout", Frame, {
		        SortOrder = Enum.SortOrder.LayoutOrder,
		        CellSize = UDim2.new(0, 40, 0, 40)
		    })
		
		    local Window = {
		        Gui = Tas,
		        Frame = Frame
		    }
		
		    function Window:AddButton(Name, Callback, CallbackDown, CallbackUp)
			    local Button = Utility.CreateInstance("TextButton", self.Frame, {
			        Text = Name,
			        Size = UDim2.new(0, 40, 0, 40),
			        BackgroundColor3 = Color3.new(0.15, 0.15, 0.15),
			        TextColor3 = Color3.new(1, 1, 1),
			        TextStrokeTransparency = 0,
			        Font = Enum.Font.SourceSans,
			        TextScaled = true,
			        BackgroundTransparency = 0.2,
			        BorderSizePixel = 0
			    })
			
			    Utility.CreateInstance("UICorner", Button, {
			        CornerRadius = UDim.new(0, 6)
			    })
			
			    Utility.CreateInstance("UIStroke", Button, {
			        Color = Color3.new(0.86, 0.86, 0.86),
			        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			    })
			
			    if Callback then
			        Button.MouseButton1Click:Connect(Callback)
			    end
			
			    if CallbackDown then
			        Button.MouseButton1Down:Connect(CallbackDown)
			    end
			
			    if CallbackUp then
			        Button.MouseButton1Up:Connect(CallbackUp)
			    end
			
			    return Button
			end
		
		    return Window
		end
		
		local Menu = Tasability:CreateWindow()
		Menu:AddButton("Frozen", function()
		    States.Frozen = not States.Frozen
		    States.Writing = not States.Frozen
		end)
		Menu:AddButton("Pause Reading", function()
		    States.IsPaused = not States.IsPaused
		end)
		Menu:AddButton("Spectate", function()
		    States.Frozen = false
		    States.Writing = false
		    States.Reading = false
		    States.Navigating = false
		    Notify("Action", "State set to None.", 3)
		end)
		Menu:AddButton("Create", function()
		    States.Writing = true
		    States.Frozen = true
		    Notify("Writing Mode", "Now in writing mode.", 3)
		end)
		Menu:AddButton("Test", function()
		    LoadTas(tostring(States.Tas), true)
		end)
		Menu:AddButton("Step Forward", function()
		    States.Writing = true
		    States.Frozen = true
		    SetFrame(Index + 1, true)
		end)
		Menu:AddButton("Step Backward", function()
		    States.Writing = true
		    States.Frozen = true
		    SetFrame(Index - 1, false)
		end)
		Menu:AddButton("Forward", nil, function()
	        States.LoopingForward = true
	        States.LoopingBackward = false
	        States.Frozen = true
	        States.Writing = true
	    end, function()
	        States.LoopingForward = false
	    end)
		Menu:AddButton("Backward", nil, function()
	        States.LoopingBackward = true
	        States.LoopingForward = false
	        States.Frozen = true
	        States.Writing = true
	    end, function()
			States.LoopingBackward = false
	    end)
	end
	end
	
	-- Setup
	do
		MouseLockController.Init()
		if ReadCursor then
			SetCursor("ArrowFarCursor", false)
			UserInputService.MouseIconEnabled = false
		end
	end
	
	-- Connections
	UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	    if GameProcessed or UserInputService:GetFocusedTextBox() then
	        return
	    end
	
	    if Input.KeyCode == GetKeyCode(Controls.Wipe) then
	        WipeTasData()
	    elseif Input.KeyCode == GetKeyCode(Controls.Frozen) then
	        States.Frozen = not States.Frozen
	        States.Writing = not States.Frozen
	    elseif Input.KeyCode == GetKeyCode(Controls.Spectate) then
	        States.Frozen = false
	        States.Writing = false
	        States.Reading = false
			States.IsPaused = false
	        Notify("Action", "State set to None.", 3)
	    elseif Input.KeyCode == GetKeyCode(Controls.Create) then
	        States.Writing = true
	        States.Frozen = true
			States.IsPaused = false
	        Notify("Writing Mode", "Now in writing mode.", 3)
	    elseif Input.KeyCode == GetKeyCode(Controls.Test) then
	        LoadTas(tostring(States.Tas), true)
	    elseif Input.KeyCode == GetKeyCode(Controls.AdvanceFrame) then
	        if States.Writing and not States.Reading then
	            States.Frozen = false
	        end
	        RunService.RenderStepped:Wait()
	        States.Frozen = true
		elseif Input.KeyCode == GetKeyCode(Controls.PauseReading) then
			States.IsPaused = not States.IsPaused
	    elseif Input.KeyCode == GetKeyCode(Controls.Forward) then
	        States.Writing = true
	        States.Frozen = true
			States.IsPaused = false
	        SetFrame(Index + 1, true)
	    elseif Input.KeyCode == GetKeyCode(Controls.Backward) then
	        States.Writing = true
	        States.Frozen = true
			States.IsPaused = false
	        SetFrame(Index - 1, false)
	    elseif Input.KeyCode == GetKeyCode(Controls.LoopForward) then
	        States.LoopingForward = true
			States.LoopingBackward = false
			States.IsPaused = false
	        States.Frozen = true
	        States.Writing = true
	    elseif Input.KeyCode == GetKeyCode(Controls.LoopBackward) then
	        States.LoopingBackward = true
			States.LoopingForward = false
			States.IsPaused = false
	        States.Frozen = true
	        States.Writing = true
	    end
	end)
	
	UserInputService.InputEnded:Connect(function(Input, GameProcessed)
	    if GameProcessed or UserInputService:GetFocusedTextBox() then
	        return
	    end
	
	    if Input.KeyCode == GetKeyCode(Controls.LoopForward) then
	        States.LoopingForward = false
	    elseif Input.KeyCode == GetKeyCode(Controls.LoopBackward) then
	        States.LoopingBackward = false
	    end
	end)

	-- Connection Frames (Input Tracker)
	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
	
		if input.UserInputType == Enum.UserInputType.Keyboard then
			local key = string.upper(input.KeyCode.Name)
			if InputCodes[key] and not InputBlacklist[key] then
				HeldKeys[key] = true
			end
	
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			if InputCodes["MB1"] then
				HeldKeys["MB1"] = true
			end
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			if InputCodes["MB2"] then
				HeldKeys["MB2"] = true
			end
		elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
			if InputCodes["MB3"] then
				HeldKeys["MB3"] = true
			end
		elseif input.UserInputType == Enum.UserInputType.MouseWheel then
			if input.Position.Z > 0 and InputCodes["ScrollUp"] then
				HeldKeys["ScrollUp"] = true
			elseif input.Position.Z < 0 and InputCodes["ScrollDown"] then
				HeldKeys["ScrollDown"] = true
			end
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input, gp)
		if gp then return end
	
		if input.UserInputType == Enum.UserInputType.Keyboard then
			local key = string.upper(input.KeyCode.Name)
			if InputCodes[key] then
				HeldKeys[key] = nil
			end
	
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			HeldKeys["MB1"] = nil
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			HeldKeys["MB2"] = nil
		elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
			HeldKeys["MB3"] = nil
		end
	end)
	
	-- General
	task.spawn(function() -- Extras
		while true do
			if not States.Reading then
				SetShiftLock(GetShiftlock()) -- stupid bug fix that doesn't even make sense???????? 
			end
			RunService.RenderStepped:Wait()
		end
	end)
	
	task.spawn(function() -- Frame Handling
		while true do
			if States.Writing and States.Frozen then
				if States.LoopingForward and Index < #Frames then
					SetFrame(Index + 1, true)
				elseif States.LoopingBackward and Index > 1 then
					SetFrame(Index - 1, false)
				end
			end
			RunService.RenderStepped:Wait()
		end
	end)

	task.spawn(function()
		while true do
			if ReadCursor then
				local MouseLocked = UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter
				local CursorData = MouseLocked and Cursors["MouseLockedCursor"] or Cursors["ArrowFarCursor"]
				local CursorIcon = CursorData.Icon
				local CursorSize = CursorData.Size
				local CursorOffset = CursorData.Offset or Vector2.zero
		
				local Resolution = Workspace.CurrentCamera.ViewportSize
				local GuiInset = GuiService:GetGuiInset()
				local PosX, PosY
		
				Cursor.Image = CursorIcon
				Cursor.Size = CursorSize
		
				if MouseLocked then
					PosX = (Resolution.X / 2) + CursorOffset.X - GuiInset.X
					PosY = (Resolution.Y / 2) + CursorOffset.Y - GuiInset.Y
				else
					local MousePos = UserInputService:GetMouseLocation()
					PosX = MousePos.X + CursorOffset.X
					PosY = MousePos.Y + CursorOffset.Y
				end
		
				if PosX and PosY then
					Cursor.Position = UDim2.fromOffset(PosX, PosY)
				end
			end
			
			RunService.RenderStepped:Wait()
		end
	end)
	
	task.spawn(function() -- Reading
	    while true do
	        if States.Reading and Index <= #Frames and not States.IsPaused then
	            local Frame = Frames[Index]
	            if Frame then
					HumanoidRootPart.CFrame = Frame.CFrame
					HumanoidRootPart.Velocity = Frame.Velocity
					HumanoidRootPart.AssemblyLinearVelocity = Frame.AssemblyLinearVelocity
					HumanoidRootPart.AssemblyAngularVelocity = Frame.AssemblyAngularVelocity
					Camera.CFrame = Frame.Camera
					Pose = Frame.Pose
                    SetZoom(Frame.Zoom)
					Humanoid:ChangeState(Enum.HumanoidStateType[Frame.State])
					HumanoidState = tostring(Frame.State)
					-- you maybe asking why 2 shiftlock forcer setshiftlock change the fake cursor icon while mouselock doe the real shiftlock
					MouseLockController.SetLocked(Frame.Shiftlock)
					SetShiftLock(Frame.Shiftlock)
					if Frame.Emote ~= LastPlayedEmote then
					    if LastPlayedEmote then
					        for _, Track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
								local PlayingId = Track.Animation and Track.Animation.AnimationId
								if PlayingId and AnimTable[LastPlayedEmote]
									and PlayingId == AnimTable[LastPlayedEmote][1].Anim.AnimationId then
									Track:Stop(0)
								end
							end
					    end
					
						if Frame.Emote and not AnimTable[Frame.Emote] then
						    warn("Bad Data: Unknown emote during playback:", Frame.Emote)
						end
					
					    if Frame.Emote then
					        PlayAnimation(Frame.Emote, 0.1, Humanoid)
					    end
					
					    LastPlayedEmote = Frame.Emote
					end
					if Frame.Pose ~= Pose then
					    PlayAnimation(Frame.Pose, 0.1, Humanoid)
					    Pose = Frame.Pose
					end
					if not States.IsMobile then
						local keys = Frame.Inputs or {}
						ConnectionRequestInput(keys)
					end
				end
				Index = Index + 1
				if Index > #Frames and not States.Finished then
				    States.Finished = true
				    States.Reading = false
				    LastPlayedEmote = nil
				
				    if not OrionLib.Flags["Disable Finish Notifications"].Value then
				        local Elapsed = tick() - PlaybackStart
						local EstimatedTime = string.format("Playback duration: %.2f seconds", Elapsed)
				        Notify("TAS Complete", EstimatedTime, 5)
						print("TAS Complete, ", EstimatedTime) -- For people who can't read fast lol
				    end
				end
	        end
	        RunService.RenderStepped:Wait()
	    end
	end)

	task.spawn(function() -- Writing
	    while true do
	        if States.Writing and not States.Reading and not States.Frozen then
	            local Inputs = {}
				for key in pairs(HeldKeys) do
					table.insert(Inputs, key)
				end

				if not IsMobile then
					ConnectionRequestInput(Inputs)
				end

				table.insert(Frames, {
					Frame = Index,
					CFrame = HumanoidRootPart.CFrame,
					Camera = Camera.CFrame,
					Velocity = HumanoidRootPart.Velocity,
					AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity,
					AssemblyAngularVelocity = HumanoidRootPart.AssemblyAngularVelocity,
					MousePosition = UserInputService:GetMouseLocation(),
					Zoom = GetZoom(),
					Shiftlock = GetShiftlock(),
					Pose = Pose,
					State = Humanoid:GetState().Name,
					Emote = LastEmote or nil,
					Inputs = Inputs
				})
				LastEmote = nil
	            Index = Index + 1
				HeldKeys["ScrollUp"] = nil
				HeldKeys["ScrollDown"] = nil
	        end
	        RunService.PreSimulation:Wait()
	    end
	end)

	task.spawn(function() -- Freezing
		while true do
			pcall(function()
				if not States.Reading and not States.Dead then
					if States.Frozen then
						local Frame = Frames[Index]
						if Frame and Index <= #Frames and Index ~= 0 then
							HumanoidRootPart.CFrame = Frame.CFrame
							HumanoidRootPart.Velocity = Frame.Velocity
							HumanoidRootPart.AssemblyLinearVelocity = Frame.AssemblyLinearVelocity
							HumanoidRootPart.AssemblyAngularVelocity = Frame.AssemblyAngularVelocity
							Humanoid:ChangeState(Enum.HumanoidStateType[Frame.State])
                            SetZoom(Frame.Zoom)
							if not OrionLib.Flags["Disable Frozen Mode Lock Camera"].Value then
								Camera.CFrame = Frame.Camera
							end
						end
					end
				end
			end)
			HumanoidRootPart.Anchored = States.Frozen
			RunService.RenderStepped:Wait()
		end
	end)
	
	task.spawn(function()
		while true do
			FrameIndexLabel:Set("Frame Index: " .. tostring(Index))
			PoseLabel:Set("Pose: " .. tostring(Pose))
			CurrentAnimLabel:Set("Current Animation: " .. tostring(CurrentAnim))
			HumanoidState = Humanoid:GetState().Name
			HumanoidStateLabel:Set("Humanoid State: " .. tostring(HumanoidState))
			ZoomLevelLabel:Set("Zoom Level: " .. string.format("%.2f", GetZoom()))
			local outputkeys = {}
			for key in pairs(HeldKeys) do
				table.insert(outputkeys, key)
			end
			FrameInputsLabel:Set("Frame Inputs: " .. table.concat(outputkeys, ", "))

			RunService.Heartbeat:Wait()
		end
	end)

	LocalPlayer.CharacterAdded:Connect(function(char)
	    Character = char
	    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
	    Humanoid = char:WaitForChild("Humanoid")
	end)
end

-- That was painful I'll be damn ain't it?

--[[
	Tasability v1.3 - Orion Edition
	Created by: nymera_src

	Based on concepts from ReplayAbility (some code snippets reused).

	Get the Input Presser Tool:
	https://github.com/NymeraAnHomie/Libraries/blob/main/Tasability/TasabilityInputPasser.exe

	Note: If you don’t trust the executable, feel free to decompile it yourself.

	Fein
]]
