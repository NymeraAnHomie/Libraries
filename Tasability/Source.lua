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
local Version = "V1.2"
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
		
		function LoadTas(fileName)
		    local filePath = "Tasability/PC/Files/" .. fileName .. ".json"
		    if isfile(filePath) then
		        local fileData = readfile(filePath)
		        local loadedFrames = HttpService:JSONDecode(fileData)
		
		        Frames = {}
		        for _, frameData in ipairs(loadedFrames) do
		            table.insert(Frames, {
		                CFrame = DeserializeCFrame(frameData.CFrame),
		                Camera = DeserializeCFrame(frameData.Camera),
		                Velocity = DeserializeVector3(frameData.Velocity),
		                AssemblyLinearVelocity = DeserializeVector3(frameData.AssemblyLinearVelocity),
		                AssemblyAngularVelocity = DeserializeVector3(frameData.AssemblyAngularVelocity),
						MousePosition = DeserializeVector2(frameData.MousePosition),
						Shiftlock = frameData.Shiftlock,
						Zoom = frameData.Zoom,
						Pose = frameData.Pose,
						State = frameData.State
		            })
		        end
		        
		        Index = 1
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
					Zoom = frame.Zoom,
					Pose = frame.Pose,
					State = frame.State
				})
		    end
		
		    writefile(path, HttpService:JSONEncode(serializedFrames))
		    Notify("Action", "TAS saved/overwrite.", 3)
		end
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
		        local args = string.split(message, " ")
		        if args[1] == "/e" and AnimNames[args[2]] then
		            PlayAnimation(args[2], 0.1, Humanoid)
		        end
		    end)
		
			PlayAnimation("Idle", 0.1, Humanoid)
			Pose = "Standing"
		end
	end
	
	-- Camera/Input Functions
	local ZoomControllers = {}
	do
		for _, Table in pairs(getgc(true)) do
	        if type(Table) == "table" then
	            pcall(function()
	                if type(Table.SetCameraToSubjectDistance) == "function" 
					and type(Table.GetCameraToSubjectDistance) == "function" then
	                    table.insert(ZoomControllers, Table)
	                end
	            end)
	        end
	    end
	end
	
	local function GetZoom()
	    for _, ZoomController in pairs(ZoomControllers) do
	        local Zoom = ZoomController:GetCameraToSubjectDistance()
	        if Zoom and Zoom ~= 12.5 then
	            return Zoom
	        end
	    end
	    return 12.5
	end
	
	local function SetZoom(Zoom)
	    for _, ZoomController in pairs(ZoomControllers) do
	        pcall(function()
	            ZoomController:SetCameraToSubjectDistance(Zoom)
	        end)
	    end
	end
	
	function GetShiftlock()
	    if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
	        return true
	    else
	        return false
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
		SetZoom(Frame.Zoom)

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
		
		local Keybinds = Window:MakeTab({Name = "Keybinds", Icon = "rbxassetid://10723395457"})
		
		local Settings = Window:MakeTab({Name = "Settings", Icon = "rbxassetid://10734950309"})
		Settings:AddToggle({Name = "Disable Tasability Notification", Save = true, Flag = "Disable Tasability Notifications"})
		Settings:AddToggle({Name = "Disable Finish Notification", Save = true, Flag = "Disable Finish Notifications"})
		Settings:AddButton({Name = "Unload", Callback = function()
		    OrionLib:Destroy()
		end})
	end
	
	-- Connections
	UserInputService.InputBegan:Connect(function(Input)
	    if Input.KeyCode == GetKeyCode(Controls.Wipe) then
	        Frames = {}
	        Index = 1
	        States.Frozen = false
	        States.Writing = false
	        States.Reading = false
	        Notify("Action", "Wiped and state are set to none.", 3)
	
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
	        States.Reading = true
	        States.Writing = false
	        States.Frozen = false
	        LoadTas(tostring(States.Tas))

		elseif Input.KeyCode == GetKeyCode(Controls.AdvanceFrame) then
			if States.Writing and not States.Reading then
				States.Frozen = false
			end
			task.wait(0.1)
			States.Frozen = true

	    elseif Input.KeyCode == GetKeyCode(Controls.Forward) then -- Move 1 Frame Forward
		    States.Writing = true
		    States.Frozen = true
			SetFrame(Index + 1)
			
		elseif Input.KeyCode == GetKeyCode(Controls.Backward) then -- Move 1 Frame Backward
		    States.Writing = true
		    States.Frozen = true
			SetFrame(Index - 1)
			
	    elseif Input.KeyCode == GetKeyCode(Controls.LoopForward) then -- Seek Forward
		    States.LoopingForward = true
		    States.Frozen = true
			States.Writing = true
			
		elseif Input.KeyCode == GetKeyCode(Controls.LoopBackward) then -- Seek Backward
		    States.LoopingBackward = true
		    States.Frozen = true
			States.Writing = true
	    end
	end)
	
	UserInputService.InputEnded:Connect(function(Input)
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
					Index = Index + 1
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
	                Zoom = GetZoom(),
					Pose = Pose,
					State = Humanoid:GetState().Name
	            })
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
							Camera.CFrame = Frame.Camera
							Humanoid:ChangeState(Enum.HumanoidStateType[Frame.State])
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
