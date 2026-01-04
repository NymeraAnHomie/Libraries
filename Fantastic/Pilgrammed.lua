local Utilities = {}
local DevMode = true

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local bit = bit32 or bit
local request = http_request or request or (syn and syn.request) or (http and http.request)

-- variables
-- data types
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

-- extra data types
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
local Ceil = math.ceil
local Sqrt = math.sqrt
local Acos = math.acos

local Insert = table.insert
local Find = table.find
local Remove = table.remove
local Concat = table.concat
local Unpack = table.unpack

local Format = string.format
local Char = string.char
local Gmatch = string.gmatch
local Rep = string.rep

local Configuration = {
	{ -- cfg
		["Auto Parry"] = {
			Enabled = false,
			Interval = 0.016,
		},
		["God Mode"] = {
			Enabled = false,
			Method = "Remote",
		},
		["Auto Farm"] = {
			Enabled = false,
			AutoAttack = false,
			AutoHeavy = false,
			FocusOn = "Bosses",
			Mobs = "",
			Bosses = "",
		},
		["Teleport"] = {
			Rifts = "Deep Desert",
			NPC = "Abraska",
		},
		["Player"] = {
			InfiniteJump = false,
		},
		BuildStealer = "",
	},
	{ -- rift data
		["Deep Desert"] = "1",
		["Mountain Basin"] = "2",
		["Patchland Grove"] = "3",
		["The Backdoor"] = "4",
		["Strange Chasm"] = "5",
		["Cloud Wilds"] = "6",
		["Light House"] = "7",
	},
	{}, -- npcs
	{}, -- modules
}

for _, v in ipairs(game:GetService("Workspace").NPCs:GetChildren()) do
    if v:FindFirstChild("HumanoidRootPart") and not string.find(v.Name, "Sign") then
        Insert(Configuration[3], v.Name)
    end
end

for _, v in ipairs(game:GetService("ReplicatedStorage"):GetChildren()) do
    if v.ClassName == "ModuleScript" then
        Configuration[4][v.Name] = require(v)
        print("required "..v.Name)
    end
end
--

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local InsertService = game:GetService("InsertService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")

local Camera = Workspace.CurrentCamera
local GuiInset = GuiService:GetGuiInset()
local Mouse = LocalPlayer:GetMouse()
local MousePosition = UserInputService:GetMouseLocation()
local GuiOffset = GuiService:GetGuiInset().Y
local IsMobile = UserInputService.TouchEnabled

local Network = game:GetService("NetworkClient")
local NetworkSettings = settings().Network
Network:SetOutgoingKBPSLimit(0)

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- signal
local Signal = {} do
    local EnableTraceback = false
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
                fn(Unpack(args))  -- call with table values
            end
        end)
    end

    function Signal:Wait()
        local key = self.Bindable.Event:Wait()
        local args = self.ArgMap[key]
        self.ArgMap[key] = nil
        return Unpack(args)
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
        for segment in gmatch(name, "[^%.]+") do
            Insert(segments, segment)
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
        for segment in Gmatch(name, "[^%.]+") do
            Insert(segments, segment)
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

    function Utilities.GetClipboard()
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
    
    Utilities.Signal = Signal
    Utilities.Connections = {}
    
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
	        Utilities.Mouse.Moved:Fire(
                Utilities.Mouse.Position,
                Utilities.Mouse.OldPosition
            )
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
	        Utilities.Mouse.MouseButton1Down:Fire(Utilities.Mouse.Position)
	    elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
	        Utilities.Mouse.Mouse2Held = true
	        Utilities.Mouse.MouseButton2Down:Fire(Utilities.Mouse.Position)
	    elseif Input.UserInputType == Enum.UserInputType.Keyboard then
	        Utilities.KeyDown:Fire(Input.KeyCode)
	        Utilities.InputState.Keys[Input.KeyCode] = true
	    end
	end)

	UserInputService.InputEnded:Connect(function(Input)
	    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
	        Utilities.Mouse.Mouse1Held = false
	        Utilities.Mouse.MouseButton1Up:Fire(Utilities.Mouse.Position)
	    elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
	        Utilities.Mouse.Mouse2Held = false
	        Utilities.Mouse.MouseButton2Up:Fire(Utilities.Mouse.Position)
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
end

-- functions
local Functions = {}; do
	function Functions:GetAllPlayers()
		local Players = game:GetService("Players")
		local LocalPlayer = Players.LocalPlayer
	    local Table = {}
	    for _, v in pairs(Players:GetPlayers()) do
	        if v ~= LocalPlayer then
	            Insert(Table, v.Name)
	        end
	    end
	    return Table
	end

	function Functions:SendWebhook(URL, Content)
		if not request then
			return
		end
	
		local Data = {
			content = Content
		}
	
		request({
			Url = URL,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json"
			},
			Body = HttpService:JSONEncode(Data)
		})
	end
	
	function Functions:GetBuild(Player)
		local Target = Players[Player]
		local Accessories = {}
		local Skills = {}
		
		for _, Child in ipairs(Target.SkillTree:GetChildren()) do
			local Value = Child.Value
			if Value == 0 then
				Insert(Skills, Child.Name .. ": Base")
			elseif Value == 1 then
				Insert(Skills, Child.Name .. ": Aced")
			end
		end
		
		for i = 1, 5 do
			local Slot = Target.EquippedAccessories:FindFirstChild(tostring(i))
			Insert(Accessories, tostring(Slot.Value))
		end
		
		return Accessories, Skills
	end
end

-- callback lists
local CallbackLists = {}; do
	CallbackLists["Auto Parry%%Enabled"] = function(Value)
		Configuration[1]["Auto Parry"].Enabled = Value
	end
	
	CallbackLists["Auto Parry%%Interval"] = function(Value)
		Configuration[1]["Auto Parry"].Interval = Value
	end
	
	CallbackLists["God Mode%%Enabled"] = function(Value)
		Configuration[1]["God Mode"].Enabled = Value
	end
	
	CallbackLists["God Mode%%Method"] = function(Value)
		Configuration[1]["God Mode"].Method = Value
	end
	
	CallbackLists["Player%%Infinite Jump"] = function(Value)
		Configuration[1]["Player"].InfiniteJump = Value
	end
	
	CallbackLists["Stealer%%Player Name"] = function(Value)
		Configuration[1].BuildStealer = Value
	end
	
	CallbackLists["Auto Farm%%Auto Heavy"] = function(Value)
		Configuration[1]["Auto Farm"].AutoHeavy = Value
	end
	
	CallbackLists["Auto Farm%%Auto Attack"] = function(Value)
		Configuration[1]["Auto Farm"].AutoAttack = Value
	end
	
	CallbackLists["Player%%Get All Mirror"] = function() -- take down all the mirror in my house i hate my nose and my mouth
		for i,v in pairs(Workspace.Mirrors:GetDescendants()) do
		    if v.ClassName == "ProximityPrompt" then
		        LocalPlayer.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
		        task.wait(0.093)
		        fireproximityprompt(v, 1)
		        task.wait(0.09)
		    end
		end
	end
	
	CallbackLists["Player%%NPCs Action"] = function()
		local Location = Configuration[1]["Teleport"].NPC
	    local NPCPart = Workspace.NPCs:FindFirstChild(Location)
		if NPCPart then
	        LocalPlayer.Character.HumanoidRootPart.CFrame = NPCPart.HumanoidRootPart.CFrame
	    else
	        WindUI:Notify{Title = "Error", Content = "Designated NPC wasn't found.", Duration = 2}
	    end
	end
	
	CallbackLists["Player%%NPCs"] = function(Value)
		Configuration[1]["Teleport"].NPC = Value
	end
	
	CallbackLists["Player%%Rift Action"] = function()
	    local Location = Configuration[1]["Teleport"].Rifts
	    local RiftNumber = Configuration[2][Location]
	    local RiftPart = Workspace:FindFirstChild("RiftSpawn" .. RiftNumber)
	    if RiftPart then
	        LocalPlayer.Character.HumanoidRootPart.CFrame = RiftPart.CFrame
	    else
	        WindUI:Notify{Title = "Error", Content = "Designated Rift wasn't found.", Duration = 2}
	    end
	end
	
	CallbackLists["Player%%Rift"] = function(Value)
		Configuration[1]["Teleport"].Rifts = Value
	end
	
	CallbackLists["Player%%Pitfall Action"] = function(Value)
		local Pitfall = Workspace.Map:FindFirstChild("Pitfall")
		if not Pitfall then WindUI:Notify{Title = "Error", Content = "Pitfall wasn't found.", Duration = 2} return end
		LocalPlayer.Character.HumanoidRootPart.CFrame = Pitfall.CFrame
	end
	
	CallbackLists["Player%%Deposit"] = function()
		ReplicatedStorage.Remotes.Bank:InvokeServer(true, 1)
	end
	
	CallbackLists["Player%%Withdrawal"] = function()
		ReplicatedStorage.Remotes.Bank:InvokeServer(false, 1)
	end
	
	CallbackLists["Setting%%Anonymous"] = function(Value)
		Window.Icon:SetAnonymous(Value)
	end
	
	CallbackLists["Setting%%Transparency"] = function(Value)
		Window:ToggleTransparency(Value)
	end
	
	CallbackLists["Developer%%Get Window Size"] = function()
		local size = WindUI:GetWindowSize()
        setclipboard(Format("UDim2.new(%s, %s, %s, %s)", size.X.Scale, size.X.Offset, size.Y.Scale, size.Y.Offset))
	end
end
--

Insert(Utilities.Connections, RunService.RenderStepped:Connect(function(dt)
    if Configuration[1]["God Mode"].Enabled then
        if Configuration[1]["God Mode"].Method == "Remote" then
	        ReplicatedStorage.Remotes.Roll:FireServer()
		elseif Configuration[1]["God Mode"].Method == "System" then
        end
    end
    
    if Configuration[1]["Auto Parry"].Enabled then
		if Floor(tick() / tonumber(Configuration[1]["Auto Parry"].Interval)) ~= Floor((tick() - 0.016) / tonumber(Configuration[1]["Auto Parry"].Interval)) then
			ReplicatedStorage.Remotes.Block:FireServer(true)
			ReplicatedStorage.Remotes.Block:FireServer(false)
		end
	end
end))

Insert(Utilities.Connections, RunService.RenderStepped:Connect(function(dt)
	local Weapon = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
	if Weapon and Weapon:FindFirstChild("Slash") then
		if Configuration[1]["Auto Farm"].AutoAttack then
			Weapon.Slash:FireServer(1)
		end
		
		if Configuration[1]["Auto Farm"].AutoHeavy then
			Weapon.Slash:FireServer(2)
		end
	end
end))

Insert(Utilities.Connections, UserInputService.JumpRequest:Connect(function()
	if Configuration[1]["Player"].InfiniteJump and LocalPlayer.Character then
		LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
		task.wait()
	end
end))

local Window = WindUI:CreateWindow{Title = "Fantastichook", Folder = "Fantastichook", Size = DimOffset(600, 400), MinSize = Vec2(560, 350), MaxSize = Vec2(850, 560), HideSearchBar = false, User = {Enabled = true, Anonymous = false}} do
	local ConfigManager = Window.ConfigManager
	local Config = ConfigManager:CreateConfig("MainCfg")

	function GetCallback(Name)
	    return function(...)
	        local Callback = CallbackLists[Name]
	        if Callback then
	            Callback(...)
	        end
	    end
	end

	local Section = Window:Tab{Title = "Combat", Icon = "rbxassetid://110987169760162"} do
		Section:Section{Title = "Auto Parry"}
		Section:Toggle{Title = "Enabled", Flag = "AutoParry_Enabled", Desc = "Enables Auto Parry.", Type = "Toggle", Callback = GetCallback("Auto Parry%%Enabled")}
		Section:Input{Title = "Interval", Flag = "AutoParry_Interval", Desc = "Controls how often auto parry should parry (in seconds).", Placeholder = "Enter number...", Callback = GetCallback("Auto Parry%%Interval")}
		
		Section:Section{Title = "God Mode."}
		Section:Toggle{Title = "Enabled", Flag = "GodMode_Enabled", Desc = "Enables God Mode and greatly reduces the chances of getting hit.", Type = "Toggle", Callback = GetCallback("God Mode%%Enabled")}
		Section:Dropdown{Title = "Method", Flag = "GodMode_Method", Desc = "Select the method used for God Mode.", Values = {"Remote"}, Value = "Remote", Callback = GetCallback("Auto Parry%%Method")}
	end
	
	local Section = Window:Tab{Title = "Visuals", Icon = "rbxassetid://100033680381365"} do
		--
	end
	
	local Section = Window:Tab{Title = "Auto Farm", Icon = "rbxassetid://126990543175462"} do
		Section:Section{Title = "Config"}
		Section:Toggle{Title = "Auto Attack", Flag = "Auto_Weapon_Attack", Desc = "", Callback = GetCallback("Auto Farm%%Auto Attack")}
		Section:Toggle{Title = "Auto Heavy", Flag = "Auto_Weapon_Heavy", Desc = "", Callback = GetCallback("Auto Farm%%Auto Heavy")}
		
		Section:Section{Title = "Enemy (all under me isn't finished)"}
		Section:Toggle{Title = "Enabled", Flag = "AutoFarm_Enabled", Desc = ""}
		Section:Dropdown{Title = "Focus On", Flag = "AutoFarm_FocusOn", Desc = "", Values = {"Bosses", "Mobs"}, Value = "Bosses"}
		Section:Dropdown{Title = "Mobs", Flag = "AutoFarm_Mobs", Desc = "", Values = {""}, Value = ""}
		Section:Dropdown{Title = "Bosses", Flag = "AutoFarm_Bosses", Desc = "", Values = {""}, Value = ""}
		
		Section:Section{Title = "Ores."}
		Section:Toggle{Title = "Enabled", Flag = "AutoFarm_Ores_Enabled", Desc = ""}
	end
	
	local Section = Window:Tab{Title = "Web Hook", Icon = "rbxassetid://112812457747322"} do
		--
	end
	
	local Section = Window:Tab{Title = "Stealer", Icon = "rbxassetid://70905313146088"} do
		local Paragraph = Section:Paragraph{Title = "Build", Desc = "Accessories:\nSkills: "}
		local Dropdown
		Section:Section{Title = "Main."}
		Section:Button{Title = "Action", Desc = "Set the paragraph on top of the designated player exposing there build.", Callback = function()
			local Accessories, Skills = Functions:GetBuild(Configuration[1].BuildStealer)
			local Description = "Accessories:\n" .. Concat(Accessories, ", ")
			Description = Description .. "\n\nSkills:\n" .. Concat(Skills, ", ")
			Paragraph:SetDesc(Description)
		end}
		Section:Button{Title = "Refresh List", Callback = function()
			Dropdown:Refresh(Functions:GetAllPlayers())
		end}
		Dropdown = Section:Dropdown{Title = "Lists", Desc = "Select the player used on top.", Values = Functions:GetAllPlayers(), Callback = GetCallback("Stealer%%Player Name")}
	end
	
	local Section = Window:Tab{Title = "Player", Icon = "rbxassetid://125020872044147"} do
		Section:Section{Title = "Main"}
		Section:Toggle{Title = "Infinite Jump", Desc = "Allows you to jump continuously while airborne.", Type = "Toggle", Callback = GetCallback("Player%%Infinite Jump")}
		Section:Button{Title = "Get All Mirror", Desc = "Grab every possible existing mirrors.", Callback = GetCallback("Player%%Get All Mirror")}
		
		Section:Section{Title = "NPCs"}
		Section:Button{Title = "Action", Desc = "Set you're location to the designated npc.", Callback = GetCallback("Player%%NPCs Action")}
		Section:Dropdown{Title = "NPCs", Flag = "Teleport_NPCs", Desc = "Select the NPCs used on top.", Values = Configuration[3], Value = "Abraska", Callback = GetCallback("Player%%NPCs")}
		
		Section:Section{Title = "Rifts"}
		Section:Button{Title = "Action", Desc = "Set you're location to the designated rift.", Callback = GetCallback("Player%%Rift Action")}
		Section:Dropdown{Title = "Rifts", Flag = "Teleport_Rifts", Desc = "Select the Rifts used on top.", Values = {"Deep Desert", "Mountain Basin", "Patchland Grove", "The Backdoor", "Strange Chasm", "Cloud Wilds", "Light House"}, Value = "Deep Desert", Callback = GetCallback("Player%%Rift")}
		
		Section:Section{Title = "Pitfall."}
		Section:Button{Title = "Action", Desc = "Set you're location to pitfall.", Callback = GetCallback("Player%%Pitfall Action")}
	end
	
	Window:Divider()
	local Section = Window:Tab{Title = "Settings.", Icon = "rbxassetid://80758916183665", Locked = false} do
		Section:Section{Title = "Main"}
		Section:Toggle{Title = "Anonymous", Flag = "Anonymous", Desc = "Set your profile to anonymous.", Type = "Toggle", Callback = GetCallback("Setting%%Anonymous")}
		Section:Toggle{Title = "Transparency", Flag = "Transparency", Value = true, Desc = "Set the gui transparent.", Type = "Toggle", Callback = GetCallback("Setting%%Transparency")}
		
		Section:Section{Title = "Configuration"}
		Section:Button{Title = "Save", Desc = "Save every elements inside the ui.", Callback = function() Config:Save() end}
		Section:Button{Title = "Delete", Desc = "Set every elements value default inside the ui.", Callback = function() Config:Delete() task.wait() Config:Load() end}
		
		Section:Section{Title = "Developer."}
		Section:Button{Title = "Get Window Size", Desc = "IF YOU'RE READING THIS, DON'T TOUCH ANYTHING IN DEV SECTION", Callback = GetCallback("Developer%%Get Window Size")}
	end
	
	Window:ToggleTransparency(true)
	Window:Tag{Title = "v1.1", Color = Hex("#30ff6a"), Radius = 13}
	Window:Tag{Title = ".gg/", Color = Hex("#7289da"), Radius = 13}
	
	task.wait()
	Config:Load()
end
