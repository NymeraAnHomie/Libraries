local function LPH_NO_VIRTUALIZE(code)
    return code
end
LPH_JIT_MAX = LPH_NO_VIRTUALIZE

local devMode = true
local folderName = "Looma"
local callbackList = {}
local connectionList = {}
local movementCache = {Time = {}, Position = {}}
local hydroxide = {}

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/NymeraAnHomie/Library/refs/heads/main/Bitchbot/Source.lua"))()
local esp = loadstring(game:HttpGet("https://raw.githubusercontent.com/NymeraAnHomie/Looma/refs/heads/main/ESP.lua"))()
local flags = library.Flags

LPH_JIT_MAX(function() -- hydroxide
	local getGc = getgc
	local getInfo = debug.getinfo or getinfo
	local getUpvalue = debug.getupvalue or getupvalue or getupval
	local getConstants = debug.getconstants or getconstants or getconsts
	local isXClosure = is_synapse_function or issentinelclosure or is_protosmasher_closure or is_sirhurt_closure or istempleclosure or checkclosure
	local isLClosure = islclosure or is_l_closure or (iscclosure and function(f) return not iscclosure(f) end)
	
	local placeholderUserdataConstant = newproxy(false)
	
	local function matchConstants(closure, list)
	    if not list then
	        return true
	    end
	    
	    local constants = getConstants(closure)
	    
	    for index, value in pairs(list) do
	        if constants[index] ~= value and value ~= placeholderUserdataConstant then
	            return false
	        end
	    end
	    
	    return true
	end
	
	local function searchClosure(script, name, upvalueIndex, constants)
	    for _i, v in pairs(getGc()) do
	        local parentScript = rawget(getfenv(v), "script")
	
	        if type(v) == "function" and 
	            isLClosure(v) and 
	            not isXClosure(v) and 
	            (
	                (script == nil and parentScript.Parent == nil) or script == parentScript
	            ) 
	            and pcall(getUpvalue, v, upvalueIndex)
	        then
	            if ((name and name ~= "Unnamed function") and getInfo(v).name == name) and matchConstants(v, constants) then
	                return v
	            elseif (not name or name == "Unnamed function") and matchConstants(v, constants) then
	                return v
	            end
	        end
	    end
	end
	
	hydroxide.placeholderUserdataConstant = placeholderUserdataConstant
	hydroxide.searchClosure = searchClosure
end)()

LPH_JIT_MAX(function() -- Main Cheat
    local modules = {}
	modules.weaponObject = {
        movement = {"IsTurret", "SeatPart", "Parent", "gun", "base", "Handle"},
        weapon = {"SlidePull", "SlideRelease", "SlideLock", "Stop", "MagIn", "Ammo"},
        aiming = {"IsAimingDownSights", "IsTurret", "setInProgress", "ADS", "canAim", 0.2},
        ammo = {"Value", "ACS_Settings", "FindFirstChild", "require", "MaxStoredAmmo", "StoredAmmo"}
    }
	modules.playerObject = {
        movement = {"IsTurret", "SeatPart", "Parent", "gun", "base", "Handle"},
        weapon = {"SlidePull", "SlideRelease", "SlideLock", "Stop", "MagIn", "Ammo"},
        aiming = {"IsAimingDownSights", "IsTurret", "setInProgress", "ADS", "canAim", 0.2},
        ammo = {"Value", "ACS_Settings", "FindFirstChild", "require", "MaxStoredAmmo", "StoredAmmo"}
    }
    
    local network = modules.networkClient
	local weaponObject = modules.weaponObject
	local firearmObject = modules.firearmObject
	local playerObject = modules.playerObject
	
	for i, value in pairs(modules) do
		if i ~= "weaponObject" and type(value) ~= "table" then
			modules[i] = {}
		end
	end
	
    local players = game:GetService("Players")
	local workspace = game:GetService("Workspace")
	local replicatedstorage = game:GetService("ReplicatedStorage")
	local lighting = game:GetService("Lighting")
	local coregui = game:GetService("CoreGui")
    local runService = game:GetService("RunService")
    local userInputService = game:GetService("UserInputService")
    local tweenService = game:GetService("TweenService")
    local httpService = game:GetService("HttpService")
    local teleportService = game:GetService("TeleportService")
    local localplayer = players.LocalPlayer
    local camera = workspace.CurrentCamera
    
    local backtrackObjects = Instance.new("Folder", workspace)
    local slientaimfov = Drawing.new("Circle")
    slientaimfov.Visible = false
    slientaimfov.Filled = false
    
	local function raycast(origin, direction, blacklist, whitelist)
	    local params = RaycastParams.new()
	    params.IgnoreWater = true
	
	    if whitelist then
	        params.FilterType = Enum.RaycastFilterType.Whitelist
	        params.FilterDescendantsInstances = whitelist
	    elseif blacklist then
	        params.FilterType = Enum.RaycastFilterType.Blacklist
	        params.FilterDescendantsInstances = blacklist
	    else
	        params.FilterType = Enum.RaycastFilterType.Blacklist
	        params.FilterDescendantsInstances = {}
	    end
	
	    return workspace:Raycast(origin, direction, params)
	end
	
	local function getClosestPlayer(fov, visibleCheck, bodyPartName)
	    if typeof(fov) == "table" and fov.Radius then
	        fov = fov.Radius
	    elseif typeof(fov) ~= "number" then
	        fov = math.huge
	    end
	
	    local closestPlayer = nil
	    local shortestDistance = fov
	    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
	
	    for _, player in pairs(players:GetPlayers()) do
	        if player ~= localplayer and player.Character and player.Character:FindFirstChild(bodyPartName) then
	            local targetPart = player.Character[bodyPartName]
	            local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
	
	            if onScreen then
	                local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
	
	                if dist <= shortestDistance then
	                    if visibleCheck then
	                        local direction = (targetPart.Position - camera.CFrame.Position).Unit * (targetPart.Position - camera.CFrame.Position).Magnitude
	                        local result = raycast(camera.CFrame.Position, direction, {localplayer.Character}, {player.Character})
	
	                        if result and result.Instance:IsDescendantOf(player.Character) then
	                            closestPlayer = player
	                            shortestDistance = dist
	                        end
	                    else
	                        closestPlayer = player
	                        shortestDistance = dist
	                    end
	                end
	            end
	        end
	    end
	
	    return closestPlayer
	end
	
	function hydroxide.rawset(path, closure, constants, index, element, value)
	    local closure = hydroxide.searchClosure(path, closure, index, constants)
	    if closure then
	        local upvalue = debug.getupvalue(closure, index)
	        if upvalue and upvalue[element] ~= value then
	            upvalue[element] = value
	        end
	    end
	end
	
	local network = {}
	function network:send(name, ...)
	    local arguments = {...}
	    if name == "equip" then
			if arguments[1] then
				localplayer.Character.Humanoid:EquipTool(localplayer.Backpack[tostring(arguments[1])])
			else
				local melee = localplayer.Backpack:FindFirstChild("Type", true)
				if melee.Value == "Melee" then
					localplayer.Character.Humanoid:EquipTool(melee)
				end
			end
    	elseif name == "stance" then
	        local stance = arguments[1]
	
	        replicatedstorage.ACS_Engine.Events.Stance:FireServer(stance, 0)
	        movementCache.Stance = stance
	    elseif name == "damage" then
	        replicatedstorage.ACS_Engine.Events.Damage:InvokeServer({
	            [1] = {
	                ["shellSpeed"] = arguments[2],
	                ["shellName"] = arguments[6],
	                ["origin"] = Vector3.new(0, 0, 0),
	                ["weaponName"] = arguments[4],
	                ["shellType"] = arguments[5],
	                ["shellMaxDist"] = arguments[3],
	                ["filterDescendants"] = {
	                    [1] = localplayer.Character,
	                    [2] = workspace.Camera.Viewmodel
	                }
	            },
	            [2] = players[arguments[1]].Character.Humanoid,
	            [3] = 2,
	            [4] = 1,
	            [5] = players[arguments[1]].Character[arguments[7]]
	        })
	    end
	end
	
	function weaponObject.applyModifications(playerWeapon)
	    if not playerWeapon then return end
	
		if flags["rage_bot_firerate"] and flags["rage_bot_enabled"] then
        	hydroxide.rawset(playerWeapon, "Unnamed function", weaponObject.weapon, 1, "ShootRate", flags["rage_bot_firerate_amount"])
	    end
	
	    if flags["gun_mods_no_recoil"] then
	        hydroxide.rawset(playerWeapon, "ADS", weaponObject.aiming, 5, "HorizontalRecoil", 0)
	        hydroxide.rawset(playerWeapon, "ADS", weaponObject.aiming, 5, "VerticalRecoil", 0)
	    end
	
	    if flags["gun_mods_no_drop"] then
	        hydroxide.rawset(playerWeapon, "ADS", weaponObject.aiming, 3, "BulletDrop", 0)
	    end
	
	    if flags["gun_mods_inf_ammo"] then
	        hydroxide.rawset(playerWeapon, "ADS", weaponObject.aiming, 3, "Ammo", 99999)
	    end
	
	    if flags["gun_mods_no_spread"] then
	        hydroxide.rawset(playerWeapon, "ADS", weaponObject.aiming, 3, "MaxSpread", 0)
	        hydroxide.rawset(playerWeapon, "ADS", weaponObject.aiming, 3, "MinSpread", 0)
	    end
	
		if flags["gun_mods_instant_aim"] then
			hydroxide.rawset(playerWeapon, "GunFx", weaponObject.movement, 8, "adsTime", 0)
		end
		
		if flags["gun_mods_instant_reload"] then
			hydroxide.rawset(playerWeapon, "ADS", weaponObject.aiming, 5, "ReloadSpeed", 5)
		end
		
		if flags["gun_mods_unlock_firemode"] then
			hydroxide.rawset(playerWeapon, "ADS", weaponObject.aiming, 3, "ShootType", 3)
		end
		
		if flags["gun_mods_instant_bullet"] then
			hydroxide.rawset(playerWeapon, "ADS", weaponObject.aiming, 3, "MuzzleVelocity", 25000)
		end
	end

	function playerObject.applyModifications(player)
		if not player then return end

		if flags["movement_walk_speed"] then
			local speeds = {"SlowPace", "Crouch", "Normal", "Aim", "Run", "AdsMoveSpeed"}
			for _, speedType in pairs(speeds) do
				hydroxide.rawset(player, "GunFx", playerObject.movement, 4, speedType .. "WalkSpeed", flags["movement_walk_speed_amount"])
			end
		end

		if flags["movement_jump_power"] then
			hydroxide.rawset(player, "GunFx", playerObject.movement, 4, "JumpPower", flags["movement_jump_power_amount"] or 16)
		end

		if flags["movement_remove_jumpcd"] then
			hydroxide.rawset(player, "GunFx", playerObject.movement, 4, "JumpCoolDown", flags["movement_remove_jumpcd"] and 0 or 0.2)
		end
	end
	
	local function fireproximityprompt(ProximityPrompt, Skip)
	    assert(ProximityPrompt, "Argument #1 Missing or nil")
	    assert(typeof(ProximityPrompt) == "Instance" and ProximityPrompt:IsA("ProximityPrompt"), "Attempted to fire a Value that is not a ProximityPrompt")
	
	    local HoldDuration = ProximityPrompt.HoldDuration
	
	    if Skip then
	        ProximityPrompt.HoldDuration = 0
	    end
	
	    ProximityPrompt:InputHoldBegin()
	    ProximityPrompt:InputHoldEnd()
	    ProximityPrompt.HoldDuration = HoldDuration
	end
	
	local preparePickUpFirearm = weaponObject.preparePickUpFirearm
	function weaponObject:preparePickUpFirearm(newId, wasClient, ...)
		for _, droppedWeapon in pairs(workspace.Drops:GetChildren()) do
            local ProximityPrompt = droppedWeapon:FindFirstChildOfClass("ProximityPrompt", true)
            if ProximityPrompt then
                fireproximityprompt(ProximityPrompt, true)
                break
            end
	    end
        
        return preparePickUpFirearm(newId, wasClient, ...)
	end
	
	local changeRealWeapon = weaponObject.changeRealWeapon
	function weaponObject:changeRealWeapon(realname, fakename, ...)
	    local arguments = { ... }
	    local weapon = localplayer.Backpack[tostring(realname)]:Clone()
	    weapon.Name = fakename
		localplayer.Backpack[realname]:Destroy()
	
	    local function deepMerge(target, source)
	        for key, value in pairs(source) do
	            if type(value) == "table" and type(target[key]) == "table" then
	                deepMerge(target[key], value) 
	            else
	                target[key] = value
	            end
	        end
	    end
	
	    for _, v in next, getgc(true) do
	        if type(v) == "table" and (rawget(v, "gunName") == fakename or rawget(v, "gunName") == realname) then
	            if type(arguments[1]) == "function" then
	                arguments[1](v)
	            else
	                for _, arg in pairs(arguments) do
	                    if type(arg) == "table" then
	                        deepMerge(v, arg)
	                    end
	                end
	            end
	        end
	    end
	
	    return changeRealWeapon(realname, unpack(arguments))
	end
	
	local function findAttachmentByName(parent, name)
		for _, child in ipairs(parent:GetChildren()) do
			if child:IsA("Attachment") and child.Name == name then
				return child
			end
		end
		return nil
	end
	
	local createBeam = function(bullet, bulletSize, duration, bulletColor1, bulletColor2)
	    for _, child in ipairs(bullet:GetChildren()) do
	        if child:IsA("Attachment") then
	            child:Destroy()
	        end
	    end
	
	    local attachment0 = Instance.new("Attachment", bullet)
	    local attachment1 = Instance.new("Attachment", bullet)
	    attachment0.Position = Vector3.new(0, 0.15, 0)
	    attachment1.Position = Vector3.new(0, -0.15, 0)
	
	    local trail = bullet:FindFirstChildWhichIsA("Trail")
	    trail.Attachment0 = attachment0
	    trail.Attachment1 = attachment1
	    trail.Texture = "rbxassetid://446111271"
	    trail.TextureLength = 10
	    trail.TextureMode = Enum.TextureMode.Wrap
	    trail.Lifetime = duration
	    trail.LightInfluence = 1
	    trail.LightEmission = 1
	    trail.Transparency = NumberSequence.new({
	        NumberSequenceKeypoint.new(0, 0),
	        NumberSequenceKeypoint.new(1, 1),
	    })
	    trail.Color = ColorSequence.new({
	        ColorSequenceKeypoint.new(0, bulletColor1),
	        ColorSequenceKeypoint.new(1, bulletColor2),
	    })
	    trail.WidthScale = NumberSequence.new({
	        NumberSequenceKeypoint.new(0, bulletSize * 1.5),
	        NumberSequenceKeypoint.new(1, bulletSize)
	    })
	    trail.FaceCamera = true
	    trail.Enabled = true
	end
	
	local createImpactPoint = function(position, size, color, transparency, duration)
	    local impactBox = Instance.new("Part")
	    impactBox.Size = Vector3.new(size, size, size)
	    impactBox.Color = color
	    impactBox.Transparency = transparency
	    impactBox.Material = Enum.Material.Neon
	    impactBox.Anchored = true
	    impactBox.CanCollide = false
	    impactBox.Position = position
	    impactBox.Parent = workspace
	
	    game:GetService("Debris"):AddItem(impactBox, duration)
	end
	
	callbackList["Slient Aim%%Visualize FOV"] = function(state)
	    slientaimfov.Visible = state
	end
	
	callbackList["Slient Aim%%FOV Radius"] = function(state)
	    slientaimfov.Radius = state
	end
	
	callbackList["Slient Aim%%FOV Color"] = function(state)
	    slientaimfov.Color = state
	end
	
	callbackList["Extras%%Capture All Hardpoints"] = function()
        for _, hardpoints in ipairs(workspace.Hardpoints:GetChildren()) do
            hardpoints:SetAttribute("CapturingProgress", 1)
            hardpoints:SetAttribute("OwningTeam", tostring(localplayer.Team))
        end
	end
	
	callbackList["Enemy ESP%%Enabled"] = function(state)
	    esp.Enabled = state
	end
	
	callbackList["Enemy ESP%%Boxes"] = function(state)
	    esp.Drawing.Boxes.Full.Enabled = state
	end
	
	callbackList["Enemy ESP%%Boxes Color"] = function(state)
	    esp.Drawing.Boxes.Full.RGB = state
	end
	
	callbackList["Enemy ESP%%Health Bar"] = function(state)
	    esp.Drawing.Healthbar.Enabled = state
	end
	
	callbackList["Enemy ESP%%Health Text"] = function(state)
	    esp.Drawing.Healthbar.HealthText = state
	end
	
	callbackList["Enemy ESP%%Health Text Color"] = function(state)
	    esp.Drawing.Healthbar.HealthTextRGB = state
	end
	
	callbackList["Enemy ESP%%Name"] = function(state)
	    esp.Drawing.Names.Enabled = state
	end
	
	callbackList["Enemy ESP%%Name Color"] = function(state)
	    esp.Drawing.Names.RGB = state
	end
	
	callbackList["Enemy ESP%%Flags"] = function(state)
	    esp.Drawing.Flags.Enabled = state
	end
	
	callbackList["Enemy ESP%%Weapon"] = function(state)
	    esp.Drawing.Weapons.Enabled = state
	end
	
	callbackList["Enemy ESP%%Weapon Color"] = function(state)
	    esp.Drawing.Weapons.WeaponTextRGB = state
	end
	
	callbackList["Enemy ESP%%Distance"] = function(state)
	    esp.Drawing.Distances.Enabled = state
	end
	
	callbackList["Enemy ESP%%Distance Position"] = function(state)
	    esp.Drawing.Distances.Position = state
	end
	
	callbackList["Enemy ESP%%Distance Color"] = function(state)
	    esp.Drawing.Distances.RGB = state
	end
	
	callbackList["Enemy ESP%%Chams"] = function(state)
	    esp.Drawing.Chams.Enabled = state
	end
	
	callbackList["Enemy ESP%%Chams Thermal"] = function(state)
	    esp.Drawing.Chams.Thermal = state
	end
	
	callbackList["Enemy ESP%%Chams Visible Check"] = function(state)
	    esp.Drawing.Chams.VisibleCheck = state
	end
	
	callbackList["Enemy ESP%%Chams Fill Transparency"] = function(state)
	    esp.Drawing.Chams.Fill_Transparency = state
	end
	
	callbackList["Enemy ESP%%Chams Outline Transparency"] = function(state)
	    esp.Drawing.Chams.Outline_Transparency = state
	end
	
	callbackList["Enemy ESP%%Boxes Gradient"] = function(state)
	    esp.Drawing.Boxes.Gradient = state
	end
	
	callbackList["Enemy ESP%%Boxes Gradient Color 1"] = function(state)
	    esp.Drawing.Boxes.GradientRGB1 = state
	end
	
	callbackList["Enemy ESP%%Boxes Gradient Color 2"] = function(state)
	    esp.Drawing.Boxes.GradientRGB2 = state
	end
	
	callbackList["Enemy ESP%%Boxes Gradient Fill"] = function(state)
	    esp.Drawing.Boxes.GradientFill = state
	end
	
	callbackList["Enemy ESP%%Boxes Gradient Fill Color 1"] = function(state)
	    esp.Drawing.Boxes.GradientFillRGB1 = state
	end
	
	callbackList["Enemy ESP%%Boxes Gradient Fill Color 2"] = function(state)
	    esp.Drawing.Boxes.GradientFillRGB2 = state
	end
	
	callbackList["Enemy ESP%%Healthbar Gradient"] = function(state)
	    esp.Drawing.Healthbar.Gradient = state
	end
	
	callbackList["Enemy ESP%%Healthbar Gradient Color 1"] = function(state)
	    esp.Drawing.Healthbar.GradientRGB1 = state
	end
	
	callbackList["Enemy ESP%%Healthbar Gradient Color 2"] = function(state)
	    esp.Drawing.Healthbar.GradientRGB2 = state
	end
	
	callbackList["Enemy ESP%%Healthbar Gradient Color 3"] = function(state)
	    esp.Drawing.Healthbar.GradientRGB3 = state
	end
	
	callbackList["Enemy ESP%%Weapons Gradient"] = function(state)
	    esp.Drawing.Weapons.Gradient = state
	end
	
	callbackList["Enemy ESP%%Weapons Gradient Color 1"] = function(state)
	    esp.Drawing.Weapons.GradientRGB1 = state
	end
	
	callbackList["Enemy ESP%%Weapons Gradient Color 2"] = function(state)
	    esp.Drawing.Weapons.GradientRGB2 = state
	end
	
	callbackList["Enemy ESP%%Chams Gradient Color 1"] = function(state)
	    esp.Drawing.Chams.FillRGB = state
	end
	
	callbackList["Enemy ESP%%Chams Gradient Color 2"] = function(state)
	    esp.Drawing.Chams.OutlineRGB = state
	end
	
	callbackList["World Visuals%%Ambient"] = function(state)
	    ambientEnabled = state
	end
	
	callbackList["World Visuals%%Ambient Color"] = function(state)
		task.spawn(function()
			while ambientEnabled do
				lighting.Ambient = state
				lighting.OutdoorAmbient = state
				lighting.ColorShift_Bottom = state
				lighting.ColorShift_Top = state
				runService.RenderStepped:Wait()
			end
		end)
	end
	
	table.insert(connectionList, runService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
	    if flags["hitboxes_enabled"] then
		    for _, Player in ipairs(players:GetPlayers()) do
		        if Player ~= localplayer then
		            local hitboxesPart = Player.Character and Player.Character:FindFirstChild(flags["hitboxes_body_priority"])
		            if hitboxesPart then
		                hitboxesPart.Size = Vector3.new(flags["hitboxes_size"], flags["hitboxes_size"], flags["hitboxes_size"])
		                hitboxesPart.Transparency = flags["hitboxes_transparency"]
		                hitboxesPart.Color = flags["hitboxes_color"]
		                hitboxesPart.Material = Enum.Material[flags["hitboxes_material"]]
		                hitboxesPart.CanCollide = false
		                hitboxesPart.Massless = true
		            end
		        end
		    end
		end
		
		if flags["rage_bot_auto_shoot"] then
		
		end
	end)))
	
	table.insert(connectionList, runService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
		local viewModel = camera:FindFirstChild("Viewmodel")
		if not viewModel then return end
	
		local tool = localplayer.Character and localplayer.Character:FindFirstChildOfClass("Tool")
		if not tool then return end
	
		local toolModel = viewModel:FindFirstChild(tool.Name)
		local handle = toolModel:FindFirstChild("Handle")
		local muzzle = findAttachmentByName(handle, "Muzzle")
		if not muzzle then return end
	
		local targetPlayer, targetPart = getClosestPlayer(slientaimfov, flags["slient_aim_visible_check"], flags["slient_aim_target_priority"])
	
		if flags["slient_aim_enabled"] and targetPlayer and targetPart then
			local direction = (targetPart.Position - handle.Position).Unit
			muzzle.CFrame = CFrame.lookAt(Vector3.zero, handle.CFrame:VectorToObjectSpace(direction))
		end
	
		slientaimfov.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
	end)))
	
	table.insert(connectionList, runService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
	    local viewModel = camera:FindFirstChild("Viewmodel")
	    if not viewModel then return end
	
	    local tool = localplayer.Character:FindFirstChildOfClass("Tool")
	    if not tool then return end
	
	    local toolModel = viewModel:FindFirstChild(tool.Name)
	    local handle = toolModel:FindFirstChild("Handle")
	    local muzzle = findAttachmentByName(handle, "Muzzle")
	    if not muzzle then return end
	    
	    local targetPlayer, targetPart = getClosestPlayer(slientaimfov, flags["slient_aim_visible_check"], flags["slient_aim_target_priority"])
	
	    if flags["slient_aim_enabled"] and targetPlayer and targetPart then
	        local aimDirection = (targetPart.Position - handle.Position).Unit
	        local localDirection = handle.CFrame:VectorToObjectSpace(aimDirection)
	        muzzle.CFrame = CFrame.lookAt(Vector3.zero, localDirection)
	    end
	
	    slientaimfov.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
	end)))
	
	local stillGoing = true
	local acsClient = nil
	
	local function refreshACSClient()
		if localplayer.Character and localplayer.Character:FindFirstChild("ACS_Client") then
			acsClient = localplayer.Character.ACS_Client:FindFirstChild("ACS_Framework")
		else
			acsClient = nil
		end
	end
	
	task.spawn(function()
		while stillGoing do
			task.wait(1)
			refreshACSClient()

			if acsClient then
				weaponObject.applyModifications(acsClient)
				playerObject.applyModifications(acsClient)
			end
		end
	end)

	table.insert(connectionList, camera.ChildAdded:Connect(LPH_NO_VIRTUALIZE(function(model)
		--viewmodel
	end)))
	
	table.insert(connectionList, workspace:FindFirstChild("CosmeticShellsFolder").ChildAdded:Connect(LPH_NO_VIRTUALIZE(function(bullet)
	    local bulletTracers = flags["world_visuals_bullet_tracers"]
	    local bulletSize = flags["world_visuals_bullet_size"]
	    local bulletColor1 = flags["world_visuals_bullet_color1"] or library.Accent
	    local bulletColor2 = flags["world_visuals_bullet_color2"] or library.Accent
	
	    local impactPoints = flags["world_visuals_impact_points"]
	    local impactColor = flags["world_visuals_impact_points_color"] or library.Accent
	    local impactTransparency = flags["world_visuals_impact_points_transparency"]
	    local impactSize = flags["world_visuals_impact_points_size"]
	    local duration = flags["world_visuals_duration"]
	
		task.wait(0.05)
	
		if string.find(bullet.Name, "Default") then
		    if bulletTracers then
		        createBeam(bullet, bulletSize, duration, bulletColor1, bulletColor2)
		    end
		
		    local rayParams = RaycastParams.new()
		    rayParams.FilterDescendantsInstances = {workspace.CosmeticShellsFolder}
		    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
		
		    local hitResult = workspace:Raycast(bullet.Position, bullet.CFrame.LookVector * 1000, rayParams)
		    if impactPoints and hitResult then
		        createImpactPoint(hitResult.Position, impactSize, impactColor, impactTransparency, duration)
		    end
		end
	end)))
	
	localplayer.CharacterAdded:Connect(LPH_NO_VIRTUALIZE(function(new)
		localplayer.Character = new
	end))

	unloadCheat = function()
		library:Unload()
		backtrackObjects:Destroy()
		hitboxObjects:Destroy()
		for _, connection in ipairs(connectionList) do
	        connection:Disconnect()
		end
	end
end)()

LPH_NO_VIRTUALIZE(function() -- UI Creation
    local httpService = game:GetService("HttpService")
    
    if not isfolder(folderName) then
	    makefolder(folderName)
	end
	
	if not isfolder(folderName .. "/warfare tycoon") then
	    makefolder(folderName .. "/warfare tycoon")
	end
	
	if not isfolder(folderName .. "/warfare tycoon/configs") then
	    makefolder(folderName .. "/warfare tycoon/configs")
	end
	
	if not isfolder(folderName .. "/cache") then
	    makefolder(folderName .. "/cache")
	end
	
	if not isfolder(folderName .. "/chat spam lists") then
	    makefolder(folderName .. "/chat spam lists")
	end

    if not isfile(folderName .. "/chat spam lists/default.txt") then
        writefile(folderName .. "/chat spam lists/default.txt", httpService:JSONEncode({
            "we have anticheat - stealth dev",
            "easiest bypass in my life",
            "how ya feeling?",
            "might need an therapy after this one",
            "speak to your therapy about this one"
        }))
    end
    
    local function getCallback(name)
	    return function(value)
	        if callbackList[name] then
	            callbackList[name](value)
	        end
	    end
	end
	
	local Whole = 515
	local Even = 180
	local Half = Whole / 2.035
	local window = library:Window({Name = "Looma"})
	
	local legit = window:Page({Name = "Legit"})
	local rage = window:Page({Name = "Rage"})
	local visuals = window:Page({Name = "Visuals"})
	local misc = window:Page({Name = "Misc"})
	local settings = window:Page({Name = "Settings"})
	
	local aimbot, fovsettings = legit:MultiSection({Sections = {"Aim Assist", "FOV Settings"}, Zindex = 5, Side = "Left", Size = Half})
	local slientaim = legit:Section({Name = "Bullet Redirection", Zindex = 5, Side = "Right", Size = Half})
	local backtrack, hitboxes = legit:MultiSection({Sections = {"Backtracking", "Hitboxes"}, Zindex = 5, Side = "Left", Size = Half})
	local gunmods = legit:Section({Name = "Gun Mods", Zindex = 5, Side = "Right", Size = Half})
	
	local ragebot, knifebot = rage:MultiSection({Sections = {"Rage Bot", "Knife Bot"}, Zindex = 5, Side = "Left", Size = Half})
	local antiaim = rage:Section({Name = "Anti Aim", Zindex = 5, Side = "Right", Size = Whole})
	local thirdperson = rage:Section({Name = "Third Person", Zindex = 5, Side = "Left", Size = Half})
	
	local enemyesp, espoptions = visuals:MultiSection({Sections = {"Enemy ESP", "ESP Options"}, Zindex = 5, Side = "Left", Size = Whole})
	local chams, worldvisuals = visuals:MultiSection({Sections = {"Chams", "World Visuals"}, Zindex = 5, Side = "Right", Size = Whole})
	
	local movement = misc:Section({Name = "Movement", Zindex = 5, Side = "Left", Size = Half})
	local extras = misc:Section({Name = "Extras", Zindex = 5, Side = "Right", Size = Half})
	
	aimbot:Toggle({Name = "Enabled", Flag = "aimbot_enabled"}):Keybind({Flag = "aimbot_keybind"})
	aimbot:Toggle({Name = "Visible Check", Flag = "aimbot_visible_check"})
	aimbot:Slider({Name = "Smoothness", Flag = "aimbot_smoothness", Suffix = "%", Default = 0.7, Min = 0, Max = 1, Decimals = 0.01})
	aimbot:List({Name = "Target Priority", Flag = "aimbot_target_priority", Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Default = "Head"})
	aimbot:Toggle({Name = "Use FOV", Flag = "aimbot_use_fov"}):Colorpicker({Name = "FOV Color", Flag = "aimbot_fov_color", Default = library.Accent})
	aimbot:Toggle({Name = "Visualize FOV", Flag = "aimbot_visualize_fov"})
	aimbot:Slider({Name = "FOV Radius", Flag = "aimbot_fov_radius", Suffix = "px", Default = 100, Min = 0, Max = 250, Decimals = 0.1})
	
	slientaim:Toggle({Name = "Enabled", Flag = "slientaim_enabled"})
	slientaim:Toggle({Name = "Visible Check", Flag = "slientaim_visible_check"})
	slientaim:List({Name = "Hit Priority", Flag = "slientaim_target_priority", Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Default = "Head"})
	slientaim:Slider({Name = "Hit Chance", Flag = "slientaim_hit_chance", Suffix = "%", Default = 100, Min = 1, Max = 100, Decimals = 0.01})
	slientaim:Toggle({Name = "Use FOV", Flag = "slientaim_use_fov"})
	slientaim:Toggle({Name = "Visualize FOV", Callback = getCallback("Slient Aim%%Visualize FOV")}):Colorpicker({Name = "FOV Color", Default = library.Accent, Callback = getCallback("Slient Aim%%FOV Color")})
	slientaim:Slider({Name = "FOV Radius", Flag = "slientaim_fov_radius", Suffix = "px", Default = 100, Min = 0, Max = 250, Decimals = 0.1, Callback = getCallback("Slient Aim%%FOV Radius")})
	
	hitboxes:Toggle({Name = "Enabled", Flag = "hitboxes_enabled"}):Colorpicker({Flag = "hitboxes_color", Default = library.Accent})
	hitboxes:List({Name = "Body Priority", Flag = "hitboxes_body_priority", Options = {"Head", "UpperTorso", "LowerTorso"}, Default = "Head"})
	hitboxes:List({Name = "Material", Flag = "hitboxes_material", Options = {"Neon", "ForceField", "Glass"}, Default = "Neon"})
	hitboxes:Slider({Name = "Size", Flag = "hitboxes_size", Suffix = " Studs", Default = 10, Min = 0, Max = 35, Decimals = 0.1})
	hitboxes:Slider({Name = "Transparency", Flag = "hitboxes_transparency", Suffix = "%", Default = 0.99, Min = 0, Max = 1, Decimals = 0.01})
	
	backtrack:Toggle({Name = "Enabled", Flag = "backtrack_enabled"})
	
	gunmods:Toggle({Name = "No Recoil", Flag = "gunmods_no_recoil"})
	gunmods:Toggle({Name = "No Spread", Flag = "gunmods_no_spread"})
	gunmods:Toggle({Name = "No Drop", Flag = "gunmods_no_drop"})
	gunmods:Toggle({Name = "No Sway", Flag = "gunmods_no_sway"})
	gunmods:Toggle({Name = "Infinite Ammo", Flag = "gunmods_inf_ammo"})
	gunmods:Toggle({Name = "Instant Bullet", Flag = "gunmods_instant_bullet"})
	gunmods:Toggle({Name = "Instant Reload", Flag = "gunmods_instant_reload"})
	gunmods:Toggle({Name = "Instant Aim", Flag = "gunmods_instant_aim"})
	gunmods:Toggle({Name = "Unlock Firemode", Flag = "gunmods_unlock_firemode"})
	
	ragebot:Toggle({Name = "Enabled", Flag = "ragebot_enabled"})
	ragebot:Toggle({Name = "Rapid fire", Flag = "ragebot_firerate"})
	ragebot:Slider({Name = "Firerate", Flag = "ragebot_firerate_amount", Suffix = " RPS", Default = 2500, Min = 1, Max = 5000, Decimals = 0.1})
	ragebot:Toggle({Name = "Auto Shoot", Flag = "ragebot_auto_shoot"}):Keybind({Flag = "auto_shoot_keybind"})
	ragebot:List({Name = "Auto Shoot Mode", Flag = "ragebot_auto_shoot_mode", Options = {"Standard", "Manipulative", "Adaptive"}, Default = "Standard"})
	ragebot:Toggle({Name = "Whitelist Friendly Status", Flag = "ragebot_friendly_check"})
	
	knifebot:Toggle({Name = "Knife Bot", Flag = "knifebot_enabled"})
	knifebot:Toggle({Name = "Force Equip", Flag = "knifebot_force_equip"})
	knifebot:List({Name = "Mode", Flag = "knifebot_mode", Options = {"All", "Aura", "Teleport"}, Default = "All"})
	knifebot:Slider({Name = "Maximum Distance", Flag = "knifebot_distance", Suffix = " Studs", Default = 1000, Min = 1, Max = 5000, Decimals = 0.1})
	knifebot:Slider({Name = "Shanks Time", Flag = "knifebot_shanks_time", Suffix = "", Default = 2, Min = 1, Max = 10, Decimals = 0.1})
	knifebot:Slider({Name = "Teleport Delay", Flag = "knifebot_teleport_delay", Suffix = "s", Default = 2, Min = 1, Max = 10, Decimals = 0.1})
	knifebot:Toggle({Name = "Whitelist Friendly Status", Flag = "knifebot_friendly_check"})
	
	-- antiaim goe here
	
	enemyesp:Toggle({Name = "Enabled", Default = true, Flag = "enemyesp_enabled", Callback = getCallback("Enemy ESP%%Enabled")})
	enemyesp:Toggle({Name = "Boxes", Flag = "enemyesp_boxes", Callback = getCallback("Enemy ESP%%Boxes")}):Colorpicker({Name = "Box Color", Flag = "enemy_esp_box_color", Default = esp.Drawing.Boxes.Full.RGB, Callback = getCallback("Enemy ESP%%Boxes Color")})
	enemyesp:Toggle({Name = "Health Bar", Flag = "enemyesp_health_bar", Callback = getCallback("Enemy ESP%%Health Bar")})
	enemyesp:Toggle({Name = "Health Bar Text", Flag = "enemyesp_health_text", Callback = getCallback("Enemy ESP%%Health Text")}):Colorpicker({Name = "Health Text Color", Flag = "enemy_esp_health_text_color", Default = esp.Drawing.Healthbar.HealthTextRGB, Callback = getCallback("Enemy ESP%%Health Text Color")})
	enemyesp:Toggle({Name = "Name", Flag = "enemyesp_name", Callback = getCallback("Enemy ESP%%Name")}):Colorpicker({Name = "Name Color", Flag = "enemy_esp_name_color", Default = esp.Drawing.Names.RGB, Callback = getCallback("Enemy ESP%%Name Color")})
	enemyesp:Toggle({Name = "Weapon", Flag = "enemyesp_weapon", Callback = getCallback("Enemy ESP%%Weapon")}):Colorpicker({Name = "Weapon Color", Flag = "enemy_esp_weapon_color", Default = esp.Drawing.Weapons.WeaponTextRGB, Callback = getCallback("Enemy ESP%%Weapon Color")})
	enemyesp:Toggle({Name = "Distance", Flag = "enemyesp_distance", Callback = getCallback("Enemy ESP%%Distance")}):Colorpicker({Name = "Distance Color", Flag = "enemy_esp_distance_color", Default = esp.Drawing.Distances.RGB, Callback = getCallback("Enemy ESP%%Distance Color")})
	enemyesp:List({Name = "Distance Position", Flag = "enemyesp_distance_position", Options = {"Bottom", "Text"}, Default = "Bottom", Callback = getCallback("Enemy ESP%%Distance Position")})
	enemyesp:Toggle({Name = "Flags", Flag = "enemyesp_flags", Callback = getCallback("Enemy ESP%%Flags")})
	enemyesp:Toggle({Name = "Chams", Flag = "enemyesp_chams", Callback = getCallback("Enemy ESP%%Chams")})
	enemyesp:Toggle({Name = "Chams Thermal", Flag = "enemyesp_chams_thermal", Default = esp.Drawing.Chams.Thermal, Callback = getCallback("Enemy ESP%%Chams Thermal")})
	enemyesp:Toggle({Name = "Chams Visible Check", Flag = "enemyesp_chams_visible_check", Callback = getCallback("Enemy ESP%%Chams Visible Check")})
	enemyesp:Slider({Name = "Chams Fill Transparency", Flag = "enemyesp_chams_fill_transparency", Suffix = "%", Default = esp.Drawing.Chams.Fill_Transparency, Min = 0, Max = 1, Decimals = 0.01, Callback = getCallback("Enemy ESP%%Chams Fill Transparency")})
	enemyesp:Slider({Name = "Chams Outline Transparency", Flag = "enemyesp_chams_outline_transparency", Suffix = "%", Default = esp.Drawing.Chams.Outline_Transparency, Min = 0, Max = 1, Decimals = 0.01, Callback = getCallback("Enemy ESP%%Chams Outline Transparency")})
	
	espoptions:Colorpicker({Name = "Box Gradient", Flag = "enemyesp_box_gradient", Default = Color3.fromRGB(119, 120, 255), Callback = getCallback("Enemy ESP%%Boxes Gradient")})
	espoptions:Colorpicker({Name = "Box Gradient Color 1", Flag = "enemyesp_box_gradient_color_1", Default = Color3.fromRGB(119, 120, 255), Callback = getCallback("Enemy ESP%%Boxes Gradient Color 1")})
	espoptions:Colorpicker({Name = "Box Gradient Color 2", Flag = "enemyesp_box_gradient_color_2", Default = Color3.fromRGB(0, 0, 0), Callback = getCallback("Enemy ESP%%Boxes Gradient Color 2")})
	espoptions:Colorpicker({Name = "Healthbar Gradient", Flag = "enemyesp_healthbar_gradient", Default = Color3.fromRGB(200, 0, 0), Callback = getCallback("Enemy ESP%%Healthbar Gradient")})
	espoptions:Colorpicker({Name = "Healthbar Gradient Color 1", Flag = "enemyesp_healthbar_gradient_color_1", Default = Color3.fromRGB(200, 0, 0), Callback = getCallback("Enemy ESP%%Healthbar Gradient Color 1")})
	espoptions:Colorpicker({Name = "Healthbar Gradient Color 2", Flag = "enemyesp_healthbar_gradient_color_2", Default = Color3.fromRGB(60, 60, 125), Callback = getCallback("Enemy ESP%%Healthbar Gradient Color 2")})
	espoptions:Colorpicker({Name = "Weapons Gradient", Flag = "enemyesp_weapons_gradient", Default = Color3.fromRGB(255, 255, 255), Callback = getCallback("Enemy ESP%%Weapons Gradient")})
	espoptions:Colorpicker({Name = "Weapons Gradient Color 1", Flag = "enemyesp_weapons_gradient_color_1", Default = Color3.fromRGB(255, 255, 255), Callback = getCallback("Enemy ESP%%Weapons Gradient Color 1")})
	espoptions:Colorpicker({Name = "Weapons Gradient Color 2", Flag = "enemyesp_weapons_gradient_color_2", Default = Color3.fromRGB(119, 120, 255), Callback = getCallback("Enemy ESP%%Weapons Gradient Color 2")})
	espoptions:Colorpicker({Name = "Chams Gradient", Flag = "enemyesp_chams_gradient", Default = Color3.fromRGB(119, 120, 255), Callback = getCallback("Enemy ESP%%Chams Gradient")})
	espoptions:Colorpicker({Name = "Chams Gradient Fill Color", Flag = "enemyesp_chams_gradient_fill_color", Default = Color3.fromRGB(119, 120, 255), Callback = getCallback("Enemy ESP%%Chams Gradient Fill Color")})
	espoptions:Colorpicker({Name = "Chams Gradient Outline Color", Flag = "enemyesp_chams_gradient_outline_color", Default = Color3.fromRGB(0, 0, 0), Callback = getCallback("Enemy ESP%%Chams Gradient Outline Color")})

	chams:Toggle({Name = "Viewmodel Outline", Flag = "viewmodel_outline"}):Colorpicker({Flag = "viewmodel_color", Default = library.Accent})
	chams:Slider({Name = "Outline Transparency", Flag = "viewmodel_outline_transparency", Suffix = "%", Default = 0.5, Min = 0, Max = 1, Decimals = 0.01})
	chams:Toggle({Name = "Arm Chams", Flag = "arm_chams"}):Colorpicker({Name = "Arm Color", Flag = "arm_chams_color", Default = library.Accent})
	chams:Slider({Name = "Arm Transparency", Flag = "arm_chams_transparency", Suffix = "%", Default = 0.5, Min = 0, Max = 1, Decimals = 0.01})
	chams:List({Name = "Arm Material", Flag = "arm_chams_material", Options = {"ForceField", "SmoothPlastic", "Neon", "Glass"}, Default = "ForceField"})
	chams:Toggle({Name = "Gun Chams", Flag = "gun_chams"}):Colorpicker({Name = "Gun Color", Flag = "gun_chams_color", Default = library.Accent})
	chams:Slider({Name = "Gun Transparency", Flag = "gun_chams_transparency", Suffix = "%", Default = 0.5, Min = 0, Max = 1, Decimals = 0.01})
	chams:List({Name = "Gun Material", Flag = "gun_chams_material", Options = {"ForceField", "SmoothPlastic", "Neon", "Glass"}, Default = "ForceField"})
	
	worldvisuals:Toggle({Name = "Ambient", Flag = "worldviusals_ambient", Callback = getCallback("World Visuals%%Ambient")}):Colorpicker({Name = "Ambient Color", Default = library.Accent, Callback = getCallback("World Visuals%%Ambient Color")})
	worldvisuals:Toggle({Name = "Bullet Tracers", Flag = "worldvisuals_bullet_tracers"})
	worldvisuals:Colorpicker({Name = "Color Two", Flag = "worldvisuals_bullet_color2", Default = library.Accent}):Colorpicker({Name = "Color One", Flag = "world_visuals_bullet_color1", Default = library.Accent})
	worldvisuals:Slider({Name = "Tracers Size", Flag = "worldvisuals_bullet_size", Suffix = " Studs", Default = 2, Min = 0, Max = 5, Decimals = 0.01})
	worldvisuals:Toggle({Name = "Impact Points", Flag = "worldvisuals_impact_points"}):Colorpicker({Name = "Impact Point Color", Flag = "world_visuals_impact_points_color", Default = library.Accent})
	worldvisuals:Slider({Name = "Impact Points Transparency", Flag = "worldvisuals_impact_points_transparency", Suffix = "%", Default = 0.5, Min = 0, Max = 1, Decimals = 0.01})
	worldvisuals:Slider({Name = "Impact Points Size", Flag = "worldvisuals_impact_points_size", Suffix = " Studs", Default = 0.5, Min = 0, Max = 2, Decimals = 0.01})
	worldvisuals:Slider({Name = "Duration", Flag = "worldvisuals_duration", Suffix = " Seconds", Default = 3, Min = 0, Max = 5, Decimals = 0.01})
	
	movement:Toggle({Name = "Walk Speed", Flag = "movement_walk_speed"})
	movement:Slider({Name = "Current Speed", Flag = "movement_walk_speed_amount", Suffix = " Studs/Second", Default = 50, Min = 1, Max = 250, Decimals = 0.01})
	movement:Toggle({Name = "Jump Power", Flag = "movement_jump_power"})
	movement:Slider({Name = "Current Power", Flag = "movement_jump_power_amount", Suffix = " Studs/Second", Default = 50, Min = 1, Max = 250, Decimals = 0.01})
	movement:Toggle({Name = "Remove jump cooldown", Flag = "movement_remove_jumpcd"})
	
	extras:Toggle({Name = "Auto Spot", Flag = "extras_autospot"})
	extras:Toggle({Name = "Unlock All Firearms", Callback = getCallback("Extras%%Unlock All Firearms")})
	extras:Toggle({Name = "Unlock All Attachments", Callback = getCallback("Extras%%Unlock All Attachments")})
	extras:Toggle({Name = "Unlock All Knives", Callback = getCallback("Extras%%Unlock All Knives")})
	extras:Toggle({Name = "Unlock All Vehicles/Helicopter", Callback = getCallback("Extras%%Unlock All Vehicles/Helicopter")})
	extras:Button({Name = "Capture All Hardpoints", Callback = getCallback("Extras%%Capture All Hardpoints")})

	local playerlist = settings:PlayerList({flag = "current_playerlist", path = folderName})
	local config = settings:Section({Name = "Configuration", Zindex = 5, Side = "Left", Size = Even})
	local cheatsettings, interactions = settings:MultiSection({Sections = {"Interface", "Interactions"}, Zindex = 5, Side = "Right", Size = Even})
	
	local function getConfigNames()
	    local files = listfiles(folderName .. "/warfare tycoon/configs")
	    local names = {}
	    for _, file in ipairs(files) do
	        table.insert(names, file:match("([^/\\]+)$"))
	    end
	    return names
	end
	
	local config_list = config:List({Name = "Config", Flag = "config_list", Options = getConfigNames()})
	config:Textbox({Flag = "config_name"})
	config:Button({Name = "Save", Callback = function()
	    if flags.config_name and flags.config_name ~= "" then
	        library:Notification((isfile(folderName .. "/warfare tycoon/configs/" .. flags.config_name .. ".cfg") 
	        and "Overwrote Config: " or "Created Config: ") .. flags.config_name, 2, library.Accent)
	        
	        writefile(folderName .. "/warfare tycoon/configs/" .. flags.config_name .. ".cfg", library:GetConfig())
	        config_list:Refresh(getConfigNames())
	    else
	        library:Notification("Config name cannot be empty", 2, library.Accent)
	    end
	end})
	config:Button({Name = "Load", Callback = function()
	    local file_path = folderName .. "/warfare tycoon/configs/" .. flags.config_list
	    if isfile(file_path) then
	        library:LoadConfig(readfile(file_path))
	        library:Notification("Loaded Config" .. flags.config_name, 2, library.Accent)
	    end
	end})
	config:Button({Name = "Refresh", Callback = function()
	    config_list:Refresh(getConfigNames())
	end})
	
    cheatsettings:Colorpicker({Name = "Menu Accent", Flag = "menu_accent", Default = library.Accent, Callback = function(rgb)
		library:ChangeAccent(rgb)
	end})
	cheatsettings:Keybind({Name = "Menu Bind", Flag = "menu_bind", UseKey = true, Default = library.UIKey, Callback = function(key)
		library.UIKey = key
    end})
    cheatsettings:Toggle({Name = "Keybind Lists", Flag = "menu_keybind_lists"})
	cheatsettings:Button({Name = "Unload", Callback = unloadCheat})

	interactions:Button({Name = "Teleport To", Callback = function()

	end})
	
	do if game:GetService("UserInputService").TouchEnabled then
		local ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Parent = game:GetService("CoreGui")
		ScreenGui.ResetOnSpawn = false
		ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		
		local Outline = Instance.new("ImageButton")
		Outline.Name = "Outline"
		Outline.AnchorPoint = Vector2.new(0.5, 0.5)
		Outline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Outline.Position = UDim2.new(1, -32, 0, 10)
		Outline.Size = UDim2.new(0, 50, 0, 50)
		Outline.AutoButtonColor = false
		Outline.Image = "rbxassetid://10709781919"
		Outline.ImageTransparency = 0
		Outline.ZIndex = 2
		Outline.Parent = ScreenGui
		
		local Inline = Instance.new("Frame")
		Inline.Name = "Inline"
		Inline.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Inline.BorderSizePixel = 0
		Inline.Position = UDim2.new(0, 1, 0, 1)
		Inline.Size = UDim2.new(1, -2, 1, -2)
		Inline.ZIndex = 1
		Inline.Parent = Outline
		
		local Accent = Instance.new("Frame")
		Accent.Name = "Accent"
		Accent.BorderColor3 = Color3.fromRGB(20, 20, 20)
		Accent.BorderSizePixel = 0
		Accent.Position = UDim2.new(0, 0, 0, 0)
		Accent.Size = UDim2.new(1, 0, 0, 1.5)
		Accent.ZIndex = 1
		Accent.Parent = Inline
		
		task.spawn(function() 
			while task.wait() do 
			    Outline.ImageColor3 = library.Accent
				Accent.BackgroundColor3 = library.Accent 
			end
		end)
		
		Outline.MouseButton1Click:Connect(function()
		    library:SetOpen(not library.Open)
		end)
	end
	end
end)()
