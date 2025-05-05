local Controls = {
    Frozen = "E",
    Wipe = "Delete",
    Spectate = "One",
    Create = "Two",
    Test = "Three",
	AdvanceFrame = "G",
    Backward = "Z",
    Forward = "X",
    LoopBackward = "C",
    LoopForward = "V"
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



-- Constants
local Version = "V1.3"
local Title = "Tasability " .. tostring(Version)
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

-- Variables Table
local States = {} -- Values for Tasability Writing
local Animation = {}
local Frames = {}
local Pressed = {}

-- Variables
local Index = 1
local SendPacketQueue = Instance.new("RemoteEvent", cloneref(game:GetService("ReplicatedStorage"))) -- Use for sending fake movement packets
local CursorHolder = Instance.new("ScreenGui", cloneref(game:GetService("CoreGui")))
local Cursor = Instance.new("ImageLabel", CursorHolder)
local CursorIcon = nil
local CursorSize = nil
local CursorOffset = nil -- UserInputService:GetMouseLocation()
local LastEmote = nil
local EmotePlaying = nil
local LastPlayedEmote = nil
local IsMobile = UserInputService.TouchEnabled
local ShiftLockEnabled = false
local Pose = ""
local HumanoidState = ""

States.Writing = false
States.Reading = false
States.Frozen = false
States.Dead = false
States.LoopingForward = false
States.LoopingBackward = false
States.Tas = nil
States.Name = ""
Animation.Disabled = false

if not isfolder("Tasability") then makefolder("Tasability") end
if not isfolder("Tasability/PC") then makefolder("Tasability/PC") end
if not isfolder("Tasability/PC/Files") then makefolder("Tasability/PC/Files") end

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

-- Functions
do
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
		
		function LoadTas(fileName)
		    local filePath = "Tasability/PC/Files/" .. fileName .. ".json"
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
						Shiftlock = frameData.Shiftlock,
						Pose = frameData.Pose,
						State = frameData.State,
						Emote = frameData.Emote
		            })
		        end
		        
		        States.Reading = true
		        States.Writing = false
		        States.Frozen = false
		    else
		        Notify("Error", "TAS file not found", 3)
		    end
		end
		
		function SaveTas(fileName)
		    local path = "Tasability/PC/Files/" .. fileName .. ".json"
		    if isfile(path) then delfile(path) end
		
			task.wait(0.08)
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
					Pose = frame.Pose,
					State = frame.State,
					Emote = frame.Emote
				})
		    end
		
		    writefile(path, HttpService:JSONEncode(serializedFrames))
		    Notify("Action", "TAS saved/overwrite.", 3)
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
	
	-- Animations Functions
	do
		local CurrentAnim = ""
		local CurrentAnimTrack = nil
		local CurrentAnimInstance = nil
		local CurrentAnimSpeed = 1.0
		local AnimTable = {}
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
		
		local AnimNameLookup = {}
		for name in pairs(AnimNames) do
			AnimNameLookup[string.lower(name)] = name
		end
		
		local EmoteNames = { wave = false, point = false, dance1 = true, dance2 = true, dance3 = true, laugh = false, cheer = false}
		local ToolAnim = "None"
		local ToolAnimTime = 0
		local JumpAnimTime = 0
		local JumpAnimDuration = 0.3
		local FallTransitionTime = 0.3
		
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
			
			local function StopAllAnimations(Humanoid)
				for _, Track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
					Track:Stop()
				end
				CurrentAnimTrack = nil
				CurrentAnimInstance = nil
			end
			
			local function SetAnimationSpeed(Number)
				if Number ~= CurrentAnimSpeed then
					CurrentAnimSpeed = Number
					CurrentAnimTrack:AdjustSpeed(CurrentAnimSpeed)
				end
			end
			
			local function PlayAnimation(AnimName, TransitionTime, Humanoid)
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
					EmotePlaying = AnimName
				end
			end
			
			-- Connect Events
			Humanoid.Died:connect(function(...)
				if Animation.Disabled then 
					return 
				end
				
				Pose = "Dead"
			end)

			Humanoid.Running:connect(function(Speed)
				if Animation.Disabled then 
					return 
				end
				
				if Speed > 0.01 then
					Pose = "Running"
					PlayAnimation("Walk", 0.1, Humanoid)
					if CurrentAnimInstance and CurrentAnimInstance.AnimationId == "https://www.roblox.com/asset/?id=180426351" then
						SetAnimationSpeed(Speed / 14.5)
					end
				else
					PlayAnimation("Idle", 0.1, Humanoid)
					Pose = "Standing"
				end
			end)

			Humanoid.Jumping:connect(function(...)
				if Animation.Disabled then 
					return 
				end
				
				PlayAnimation("Jump", 0.1, Humanoid)
				JumpAnimTime = JumpAnimDuration
				Pose = "Jumping"
			end)

			Humanoid.Climbing:connect(function(Speed)
				if Animation.Disabled then 
					return 
				end
				
				PlayAnimation("Climb", 0.1, Humanoid)
				SetAnimationSpeed(Speed / 12.0)
				Pose = "Climbing"
			end)

			Humanoid.GettingUp:connect(function(...)
				if Animation.Disabled then 
					return 
				end
				
				Pose = "GettingUp"
			end)

			Humanoid.FreeFalling:connect(function(...)
				if Animation.Disabled then 
					return 
				end
				
				if JumpAnimTime <= 0 then
					PlayAnimation("Fall", FallTransitionTime, Humanoid)
				end
				Pose = "FreeFall"
			end)

			Humanoid.FallingDown:connect(function(...)
				if Animation.Disabled then 
					return 
				end
				
				Pose = "FallingDown"
			end)

			Humanoid.Seated:connect(function(...)
				if Animation.Disabled then 
					return 
				end
				
				Pose = "Seated"
			end)

			Humanoid.PlatformStanding:connect(function(...)
				if Animation.Disabled then 
					return 
				end
			
				Pose = "PlatformStanding"
			end)

			Humanoid.Swimming:connect(function(Speed)
				if Animation.Disabled then 
					return 
				end
				
				if Speed > 0 then
					Pose = "Swimming"
					PlayAnimation("Swim", 0.1, Humanoid)
				else
					Pose = "Standing"
					PlayAnimation("Idle", 0.1, Humanoid)
				end
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
		end
	end
	
	-- Camera/Input Functions
	function GetShiftlock()
	    if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
	        return true
	    else
	        return false
	    end
	end
	
	function SetShiftLock(Bool)
		if ShiftLockEnabled ~= Bool then
			ShiftLockEnabled = Bool
			if Bool then
				SetCursor("MouseLockedCursor")
			else
				SetCursor("ArrowFarCursor")
			end
			ContextActionService:CallFunction("MouseLockSwitchAction", Enum.UserInputState.Begin, game)
		end
	end
	
	local function SetCursor(CursorName, StayinMiddle)
		local CursorData = Cursors[CursorName]
		CursorIcon = CursorData.Icon
		CursorSize = CursorData.Size
		CursorOffset = CursorData.Offset

		Cursor.Image = CursorIcon
		Cursor.Size = CursorSize
		Cursor.BackgroundTransparency = 1
		Cursor.BorderSizePixel = 0
		Cursor.ZIndex = math.huge
		Cursor.Visible = true

		if StayinMiddle then
			Cursor.AnchorPoint = Vector2.new(0.5, 0.5)
		else
			Cursor.AnchorPoint = Vector2.new(0, 0)
		end
	end
	
	local function SetFrame(index: number)
		if not Frames[index] then return end

		Index = index
		local Frame = Frames[index]

		HumanoidRootPart.CFrame = Frame.CFrame
		HumanoidRootPart.Velocity = Frame.Velocity
		HumanoidRootPart.AssemblyLinearVelocity = Frame.AssemblyLinearVelocity
		HumanoidRootPart.AssemblyAngularVelocity = Frame.AssemblyAngularVelocity
		Camera.CFrame = Frame.Camera
		Humanoid:ChangeState(Enum.HumanoidStateType[Frame.State])

		for i = #Frames, index + 1, -1 do
			if States.Writing and not States.LoopingForward then
				table.remove(Frames, i)
			end
		end
	end
	
	-- Interface
	do
		local Main = Window:MakeTab({Name = "Main", Icon = "rbxassetid://10723374641"})
		Main:AddParagraph("Importance", "Use a specific FPS cap and do not change it until you're done making a TAS or are currently not working on a TAS. Changing it will lead to incorrect replay speeds (too fast or too slow).")
		local FileDropdown = Main:AddDropdown({Name = "Files",  Options = GetFiles(),  Callback = function(Value)
		    States.Tas = Value
		end})
		Main:AddTextbox({Name = "Name", TextDisappear = false, Callback = function(Value)
		    States.Name = Value
		end})
		Main:AddButton({Name = "Save", Callback = function()
		    SaveTas(States.Name)
		    FileDropdown:Refresh(GetFiles(), true)
		end})
		Main:AddButton({Name = "Refresh", Callback = function()
		    FileDropdown:Refresh(GetFiles(), true)
		end})
		Main:AddButton({Name = "Start Writing at the end of selected tas", Callback = function()
			if not States.Tas then
				Notify("Error", "No TAS file selected!", 3)
				return
			end

			LoadTas(States.Tas)

			if #Frames > 0 then
				SetFrame(#Frames)
			end

			States.Writing = true
			States.Frozen = true
			States.Reading = false
			Notify("Writing Mode", "Now writing at the end of TAS: " .. States.Tas, 3)
		end})
		
		local Settings = Window:MakeTab({Name = "Settings", Icon = "rbxassetid://10734950309"})
		Settings:AddToggle({Name = "Disable Tasability Notification", Save = true, Flag = "Disable Tasability Notifications"})
		Settings:AddToggle({Name = "Disable Finish Notification", Save = true, Flag = "Disable Finish Notifications"})
		Settings:AddToggle({Name = "Disable Frozen Mode Lock Camera", Save = true, Flag = "Disable Frozen Mode Lock Camera"})
		Settings:AddToggle({Name = "God Mode", Save = true, Flag = "God Mode"})
		if IsMobile then
			Settings:AddButton({Name = "Wipe All Frame (Mobile)", Callback = function()
			    WipeTasData()
			end})
		end
		Settings:AddButton({Name = "Unload", Callback = function()
		    OrionLib:Destroy()
		end})
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
	
	-- Settings Hooks
	do
		pcall(function()
			local oldNamecall
			oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
				local method = getnamecallmethod()
				local args = {...}
				if OrionLib.Flags["God Mode"].Value and self.Name:lower():find("damage") then
					return
				end
				return oldNamecall(self, unpack(args))
			end)
		end)
	end
	
	do
	if IsMobile then
		local tas = Utility.CreateInstance("ScreenGui", game:GetService("CoreGui"), {
		    Name = "tas",
		    IgnoreGuiInset = true
		})
		
		local SForward = Utility.CreateInstance("TextButton", tas, {
		    Name = "SForward",
		    Text = ">",
		    TextWrapped = true,
		    TextStrokeTransparency = 0,
		    BorderSizePixel = 0,
		    TextScaled = true,
		    BackgroundColor3 = Color3.new(0.05, 0.05, 0.05),
		    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		    TextSize = 40,
		    Size = UDim2.new(0.04, 0, 0.08, 0),
		    TextColor3 = Color3.new(1, 1, 1),
		    BorderColor3 = Color3.new(0, 0, 0),
		    Position = UDim2.new(0.09, 0, 0.46, 0)
		})
		
		local SBackward = Utility.CreateInstance("TextButton", tas, {
		    Name = "SBackward",
		    Text = "<",
		    TextWrapped = true,
		    TextStrokeTransparency = 0,
		    BorderSizePixel = 0,
		    TextScaled = true,
		    BackgroundColor3 = Color3.new(0.05, 0.05, 0.05),
		    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		    TextSize = 40,
		    Size = UDim2.new(0.04, 0, 0.08, 0),
		    TextColor3 = Color3.new(1, 1, 1),
		    BorderColor3 = Color3.new(0, 0, 0),
		    Position = UDim2.new(0.04, 0, 0.46, 0)
		})
		
		local Forward = Utility.CreateInstance("TextButton", tas, {
		    Name = "Forward",
		    Text = ">>",
		    TextWrapped = true,
		    TextStrokeTransparency = 0,
		    BorderSizePixel = 0,
		    TextScaled = true,
		    BackgroundColor3 = Color3.new(0.05, 0.05, 0.05),
		    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		    TextSize = 40,
		    Size = UDim2.new(0.04, 0, 0.08, 0),
		    TextColor3 = Color3.new(1, 1, 1),
		    BorderColor3 = Color3.new(0, 0, 0),
		    Position = UDim2.new(0.09, 0, 0.55, 0)
		})
		
		local Backward = Utility.CreateInstance("TextButton", tas, {
		    Name = "Backward",
		    Text = "<<",
		    TextWrapped = true,
		    TextStrokeTransparency = 0,
		    BorderSizePixel = 0,
		    TextScaled = true,
		    BackgroundColor3 = Color3.new(0.05, 0.05, 0.05),
		    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		    TextSize = 40,
		    Size = UDim2.new(0.04, 0, 0.08, 0),
		    TextColor3 = Color3.new(1, 1, 1),
		    BorderColor3 = Color3.new(0, 0, 0),
		    Position = UDim2.new(0.04, 0, 0.55, 0)
		})
		
		local Pause = Utility.CreateInstance("TextButton", tas, {
		    Name = "Pause",
		    Text = "Pause/Froze",
		    TextWrapped = true,
		    TextStrokeTransparency = 0,
		    BorderSizePixel = 0,
		    TextScaled = true,
		    BackgroundColor3 = Color3.new(0.05, 0.05, 0.05),
		    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		    TextSize = 40,
		    Size = UDim2.new(0.04, 0, 0.08, 0),
		    TextColor3 = Color3.new(1, 1, 1),
		    BorderColor3 = Color3.new(0, 0, 0),
		    Position = UDim2.new(0.14, 0, 0.45, 0)
		})
		
		local One = Utility.CreateInstance("TextButton", tas, {
		    Name = "One",
		    Text = "1",
		    TextWrapped = true,
		    TextStrokeTransparency = 0,
		    BorderSizePixel = 0,
		    TextScaled = true,
		    BackgroundColor3 = Color3.new(0.05, 0.05, 0.05),
		    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		    TextSize = 40,
		    Size = UDim2.new(0.04, 0, 0.08, 0),
		    TextColor3 = Color3.new(1, 1, 1),
		    BorderColor3 = Color3.new(0, 0, 0),
		    Position = UDim2.new(0.04, 0, 0.36, 0)
		})
		
		local Two = Utility.CreateInstance("TextButton", tas, {
		    Name = "Two",
		    Text = "2",
		    TextWrapped = true,
		    TextStrokeTransparency = 0,
		    BorderSizePixel = 0,
		    TextScaled = true,
		    BackgroundColor3 = Color3.new(0.05, 0.05, 0.05),
		    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		    TextSize = 40,
		    Size = UDim2.new(0.04, 0, 0.08, 0),
		    TextColor3 = Color3.new(1, 1, 1),
		    BorderColor3 = Color3.new(0, 0, 0),
		    Position = UDim2.new(0.09, 0, 0.36, 0)
		})
		
		local Three = Utility.CreateInstance("TextButton", tas, {
		    Name = "Three",
		    Text = "3",
		    TextWrapped = true,
		    TextStrokeTransparency = 0,
		    BorderSizePixel = 0,
		    TextScaled = true,
		    BackgroundColor3 = Color3.new(0.05, 0.05, 0.05),
		    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		    TextSize = 40,
		    Size = UDim2.new(0.04, 0, 0.08, 0),
		    TextColor3 = Color3.new(1, 1, 1),
		    BorderColor3 = Color3.new(0, 0, 0),
		    Position = UDim2.new(0.14, 0, 0.36, 0)
		})
		
		SForward.MouseButton1Click:Connect(function()
			States.Writing = true
	        States.Frozen = true
	        SetFrame(Index + 1)
		end)
		
		SBackward.MouseButton1Click:Connect(function()
			States.Writing = true
	        States.Frozen = true
			SetFrame(Index - 1)
		end)
		
		Pause.MouseButton1Click:Connect(function()
	        States.Frozen = not States.Frozen
	        States.Writing = not States.Frozen
		end)
		
		One.MouseButton1Click:Connect(function()
	        States.Frozen = false
	        States.Writing = false
	        States.Reading = false
	        States.Navigating = false
	        Notify("Action", "State set to None.", 3)
		end)
		
		Two.MouseButton1Click:Connect(function()
	        States.Writing = true
	        States.Frozen = true
	        Notify("Writing Mode", "Now in writing mode.", 3)
		end)
		
		Three.MouseButton1Click:Connect(function()
	        LoadTas(tostring(States.Tas))
		end)
		
		Forward.MouseButton1Down:Connect(function()
			States.LoopingForward = true
			States.LoopingBackward = false
			States.Frozen = true
			States.Writing = true
		end)
		
		Forward.MouseButton1Up:Connect(function()
			States.LoopingForward = false
		end)
		
		Backward.MouseButton1Down:Connect(function()
			States.LoopingBackward = true
			States.LoopingForward = false
			States.Frozen = true
			States.Writing = true
		end)
		
		Backward.MouseButton1Up:Connect(function()
			States.LoopingBackward = false
		end)
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
	        States.Navigating = false
	        Notify("Action", "State set to None.", 3)
	    elseif Input.KeyCode == GetKeyCode(Controls.Create) then
	        States.Writing = true
	        States.Frozen = true
	        Notify("Writing Mode", "Now in writing mode.", 3)
	    elseif Input.KeyCode == GetKeyCode(Controls.Test) then
	        LoadTas(tostring(States.Tas))
	    elseif Input.KeyCode == GetKeyCode(Controls.AdvanceFrame) then
	        if States.Writing and not States.Reading then
	            States.Frozen = false
	        end
	        task.wait(0.1)
	        States.Frozen = true
	    elseif Input.KeyCode == GetKeyCode(Controls.Forward) then
	        States.Writing = true
	        States.Frozen = true
	        SetFrame(Index + 1)
	    elseif Input.KeyCode == GetKeyCode(Controls.Backward) then
	        States.Writing = true
	        States.Frozen = true
	        SetFrame(Index - 1)
	    elseif Input.KeyCode == GetKeyCode(Controls.LoopForward) then
	        States.LoopingForward = true
			States.LoopingBackward = false
	        States.Frozen = true
	        States.Writing = true
	    elseif Input.KeyCode == GetKeyCode(Controls.LoopBackward) then
	        States.LoopingBackward = true
			States.LoopingForward = false
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
	
	task.spawn(function() -- Frame Handling
		while true do
			if States.Writing and States.Frozen then
				if States.LoopingForward and Index < #Frames then
					SetFrame(Index + 1)
				elseif States.LoopingBackward and Index > 1 then
					SetFrame(Index - 1)
				end
			end
			RunService.RenderStepped:Wait()
		end
	end)
	
	task.spawn(function() -- Reading
	    while true do
			pcall(function() -- Sometime old tas file doe not met the option to read causing the script to break
		        if States.Reading and Index <= #Frames then
		            local Frame = Frames[Index]
		            if Frame then
						HumanoidRootPart.CFrame = Frame.CFrame
						HumanoidRootPart.Velocity = Frame.Velocity
						HumanoidRootPart.AssemblyLinearVelocity = Frame.AssemblyLinearVelocity
						HumanoidRootPart.AssemblyAngularVelocity = Frame.AssemblyAngularVelocity
						Camera.CFrame = Frame.Camera
						Pose = Frame.Pose
						SetShiftLock(Frame.Shiftlock)
						Humanoid:ChangeState(Enum.HumanoidStateType[Frame.State])
						HumanoidState = tostring(Frame.State)
					
						if Frame.Emote and Frame.Emote ~= LastPlayedEmote then
							PlayAnimation(Frame.Emote, 0.1, Humanoid)
							LastPlayedEmote = Frame.Emote
						end
					end
					Index = Index + 1
					if Index > #Frames then
						States.Reading = false
						LastPlayedEmote = nil
					end
		        end
			end)
	        RunService.RenderStepped:Wait()
	    end
	end)

	task.spawn(function() -- Writing
	    while true do
	        if States.Writing and not States.Reading and not States.Frozen then
	            table.insert(Frames, {
					Frame = Index,
					CFrame = HumanoidRootPart.CFrame,
					Camera = Camera.CFrame,
					Velocity = HumanoidRootPart.Velocity,
					AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity,
					AssemblyAngularVelocity = HumanoidRootPart.AssemblyAngularVelocity,
					MousePosition = UserInputService:GetMouseLocation(),
					Shiftlock = GetShiftlock(),
					Pose = Pose,
					State = Humanoid:GetState().Name,
					Emote = LastEmote or nil
				})
				LastEmote = nil
	            Index = Index + 1
	        end
	        RunService.RenderStepped:Wait()
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

	LocalPlayer.CharacterAdded:Connect(function(char)
	    Character = char
	    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
	    Humanoid = char:WaitForChild("Humanoid")
	end)
end

--[[
	Source or Owner by nymera_src
	Some Script are taken by original Replayability so credit to the owner who i taken
	
	Tasability V1.3
	[+] Bypassed Some Anticheats
	[+] Added Animation Functions
	[+] Added QOL Features (Settings, Keybinds)
	[+] Added Mobile Support
	[+] Fein
]]
