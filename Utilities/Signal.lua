local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Insert = table.insert
local Unpack = table.unpack
local Gmatch = string.gmatch
local Vec2 = Vector2.new

local Signal = {}; do
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

	Utilities.Base = {
		AbsolutePosition = Vec2(0, 0),
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

	Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		Utilities.Base.AbsoluteSize = Camera.ViewportSize
		Utilities.Base.PropertyChanged:Fire("AbsoluteSize", Camera.ViewportSize)
	end)

	setmetatable(Utilities.Base, {
		__newindex = function(t, k, v)
			local Old = rawget(t, k)
			rawset(t, k, v)
			t.PropertyChanged:Fire(k, v, Old)
			t.ChildUpdated:Fire(k, v)
		end
	})
end
