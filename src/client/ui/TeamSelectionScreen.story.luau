local Fusion = require(game.ReplicatedStorage.Packages.Fusion)
local Value = Fusion.Value
local Observer = Fusion.Observer
local Computed = Fusion.Computed
local Hydrate = Fusion.Hydrate
local New = Fusion.New
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local OnChange = Fusion.OnChange
local Spring = Fusion.Spring
local Tween = Fusion.Tween
local ForKeys = Fusion.ForKeys
local ForValues = Fusion.ForValues
local ForPairs = Fusion.ForPairs
type CanBeState<T> = Fusion.CanBeState<T>
type Value<T> = Fusion.Value<T>

local DeviceUIScale = require(script.Parent.DeviceUIScale).DeviceUIScale

local teamShift = Value(0)
local teamShiftSmooth = Tween(teamShift, TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out))

local blueTeamColor = Color3.new(0, 0.6, 1)
local redTeamColor = Color3.new(1, 0.2, 0.2)

local teamName = Value('')
local teamColor = Value(Color3.new())

type TeamSelectionScreen = {}

return function(target: Frame): Frame
	local ui = New 'Frame' {
		Parent = target,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,

		[Children] = {
			New 'Frame' {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(300, 100),
				BackgroundTransparency = 1,
				ZIndex = 2,
				[Children] = {
					DeviceUIScale(),
					New 'TextLabel' {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						TextScaled = true,
						TextColor3 = teamColor,
						TextStrokeTransparency = 0,
						FontFace = Font.new('rbxassetid://12187368625', Enum.FontWeight.Bold),
						Text = teamName,
					},
				},
			},
			New 'Frame' {
				Size = UDim2.fromScale(1, 1),
				[OnEvent 'MouseLeave'] = function(_: number, _: number)
					teamName:set('')
				end,
				[Children] = {
					New 'UIGradient' {
						Color = ColorSequence.new(redTeamColor, blueTeamColor),
						Transparency = Computed(function()
							local redTrans = 0.5 - math.max(teamShiftSmooth:get(), 0) / 2
							local blueTrans = 0.5 - math.max(-teamShiftSmooth:get(), 0) / 2

							if teamName:get() == 'Red' then
								teamShift:set(1)
							end

							if teamName:get() == 'Blue' then
								teamShift:set(-1)
							end

							if teamName:get() == '' then
								teamShift:set(0)
							end

							return NumberSequence.new({
								NumberSequenceKeypoint.new(0, redTrans),
								NumberSequenceKeypoint.new(0.5, 1 - math.abs(teamShiftSmooth:get()) / 5),
								NumberSequenceKeypoint.new(1, blueTrans),
							})
						end, Fusion.cleanup),
					},
					New 'UIListLayout' {
						FillDirection = 'Horizontal',
						HorizontalFlex = 'Fill',
						VerticalFlex = 'Fill',
					},
					New 'Frame' {
						BackgroundTransparency = 1,
						[OnEvent 'MouseEnter'] = function(_: number, _: number)
							teamName:set('Red')
							teamColor:set(redTeamColor)
						end,
						[Children] = {
							New 'ImageLabel' {
								Image = 'rbxassetid://13700509087',
								BackgroundTransparency = 1,
								AnchorPoint = Vector2.new(0.5, 0.5),
								Position = UDim2.fromScale(0.5, 0.5),
								Size = UDim2.fromOffset(500, 500),
								ImageColor3 = redTeamColor,
								[Children] = {
									DeviceUIScale(),
								},
							},
						},
					},
					New 'Frame' {
						BackgroundTransparency = 1,
						[OnEvent 'MouseEnter'] = function(_: number, _: number)
							teamName:set('Blue')
							teamColor:set(blueTeamColor)
						end,
						[Children] = {
							New 'ImageLabel' {
								Image = 'rbxassetid://13700509087',
								BackgroundTransparency = 1,
								AnchorPoint = Vector2.new(0.5, 0.5),
								Position = UDim2.fromScale(0.5, 0.5),
								Size = UDim2.fromOffset(500, 500),
								ImageColor3 = blueTeamColor,
								[Children] = {
									DeviceUIScale(),
								},
							},
						},
					},
				},
			},
		},
	}

	return ui
end
