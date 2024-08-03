local GuiService = game:GetService('GuiService')
local UserInputService = game:GetService('UserInputService')

local Fusion = require(game:GetService('ReplicatedStorage').Packages.Fusion)
local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed

local desktopInputTypes = {
	Enum.UserInputType.MouseButton1,
	Enum.UserInputType.MouseWheel,
	Enum.UserInputType.MouseMovement,
	Enum.UserInputType.None,
	Enum.UserInputType.Keyboard,
	Enum.UserInputType.MouseButton2,
	Enum.UserInputType.MouseButton3,
}

local mobileInputTypes = {
	Enum.UserInputType.Touch,
	Enum.UserInputType.Gyro,
	Enum.UserInputType.Accelerometer,
}

local lastInputType = Value(UserInputService:GetLastInputType())
local resolution = Value(Vector2.zero)

UserInputService.LastInputTypeChanged:Connect(function(newLastInputType: Enum.UserInputType)
	if newLastInputType == Enum.UserInputType.Focus then
		return
	end

	if newLastInputType == Enum.UserInputType.TextInput then
		return
	end

	if newLastInputType == Enum.UserInputType.InputMethod then
		return
	end

	if newLastInputType == Enum.UserInputType.None then
		return
	end

	print('[DeviceUIScale] LastInputType Changed: ' .. newLastInputType.Name)

	lastInputType:set(newLastInputType)
end)

local uiScale = Computed(function()
	local inputType
	local resType

	if GuiService:IsTenFootInterface() then
		warn('[DeviceUIScale] Console support in progress')
		--return 2
	end

	if table.find(mobileInputTypes, lastInputType:get()) then
		inputType = 'mobile'
	end

	if table.find(desktopInputTypes, lastInputType:get()) then
		inputType = 'desktop'
	end

	if resolution:get().X <= 1024 then
		resType = 'mobile'
	end

	if resolution:get().X > 3400 then
		resType = 'desktop_large'
	end

	if resType == 'mobile' then
		print('[DeviceUIScale] Device type detected: Mobile')
		return 0.5
	end

	if resType == 'desktop_large' then
		print('[DeviceUIScale] Device type detected: Large Desktop')
		return 2
	end

	if resType == "desktop" then
		print('[DeviceUIScale] Device type detected: Desktop')
		return 1
	end

	print('[DeviceUIScale] No device detected. Falling back to Desktop')
	return 1
end)

local function DeviceUIScale()
	return New 'UIScale' {
		Scale = uiScale,
	}
end

local function ResolutionChanged(newRes: Vector2)
	print('[DeviceUIScale] Resolution changed: ' .. tostring(newRes))
	resolution:set(newRes)
end

return {
	DeviceUIScale = DeviceUIScale,
	ResolutionChanged = ResolutionChanged,
}
