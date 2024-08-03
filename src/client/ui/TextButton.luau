local Fusion = require(game:GetService('ReplicatedStorage').Packages.Fusion)
local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local OnChange = Fusion.OnChange
type CanBeState<T> = Fusion.CanBeState<T>

local DeviceUIScale = require(script.Parent.DeviceUIScale).DeviceUIScale

type TextButtonProps = {
	Text: CanBeState<string>?,
	FontFace: CanBeState<Font>?,
	Size: CanBeState<UDim2>?,
	Position: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,
	Color: {
		Idle: CanBeState<Color3>?,
		Hover: CanBeState<Color3>?,
		Down: CanBeState<Color3>?,
	},
}

local images = {
	Idle = 'rbxtemp://1',
	Hover = 'rbxtemp://1',
	Down = 'rbxtemp://1',
}

-- local function EnsureStateObject<T>(_type: string, input: CanBeState<T>?, default): CanBeState<T>
-- 	if not input then
-- 		input = Value(default)
-- 	end

-- 	if typeof(input) == _type then
-- 		input = Value(input)
-- 	end

-- 	return input
-- end

local function TextButton(props: TextButtonProps): Frame
	props.AnchorPoint = props.AnchorPoint or Value(Vector2.new(0.5, 0.5))

	if typeof(props.AnchorPoint) == 'Vector2' then
		props.AnchorPoint = Value(Vector2.new(0.5, 0.5))
	end

	props.Color = props.Color or {}

	props.Color.Idle = props.Color.Idle or Value(Color3.new(1, 1, 1))
	props.Color.Hover = props.Color.Hover or Value(Color3.new(1, 1, 0))
	props.Color.Down = props.Color.Down or Value(Color3.new(0.5, 0.5, 0))

	if typeof(props.Color.Idle) == 'Color3' then
		props.Color.Idle = Value(props.Color.Idle)
	end

	if typeof(props.Color.Hover) == 'Color3' then
		props.Color.Hover = Value(props.Color.Hover)
	end

	if typeof(props.Color.Down) == 'Color3' then
		props.Color.Down = Value(props.Color.Down)
	end

	print(props.Color)

	local State = Value('Idle')

	local Image = Computed(function()
		return images[State:get()]
	end)
	local Color = Computed(function()
		return props.Color[State:get()]:get()
	end)

	return New 'ImageLabel' {
		Image = Image,
		ImageColor3 = Color,
		Size = props.Size,
		Position = props.Position,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(128, 128, 128, 128),
		AnchorPoint = props.AnchorPoint,
		BackgroundTransparency = 1,

		[OnEvent 'MouseEnter'] = function(_: number, _: number)
			State:set('Hover')
		end,
		[OnEvent 'MouseLeave'] = function(_: number, _: number)
			State:set('Idle')
		end,
		[OnEvent 'InputBegan'] = function(input: InputObject)
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			if
				input.UserInputType ~= Enum.UserInputType.MouseButton1
				and input.UserInputType ~= Enum.UserInputType.Touch
			then
				return
			end

			State:set('Down')
		end,

		[Children] = {
			DeviceUIScale(),
			--New "UIPadding" {
			--	PaddingLeft
			--},
			New 'TextLabel' {
				Text = props.Text,
				TextColor3 = Color,
				TextSize = 90,
				FontFace = props.FontFace,
				Size = UDim2.fromScale(1, 1),
				RichText = true,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
			},
		},
	}
end

return TextButton
