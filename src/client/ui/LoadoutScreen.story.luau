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

local shopUnits = require(script.Parent.shop_units)
local DeviceUIScale = require(script.Parent.DeviceUIScale).DeviceUIScale

local stroke_thickness = 3

local function ReactiveStroke(props): UIStroke
	return New 'UIStroke' {
		Color = Computed(function()
			if props.IsHovered:get() then
				return Color3.new(1, 0.8, 0)
			end

			return Color3.new(1, 1, 1)
		end),
		Thickness = stroke_thickness,
		Transparency = Computed(function()
			if props.IsHovered:get() then
				return 0
			end

			return 0.5
		end),
	}
end

return function(target: Frame): Frame
	local ui = New 'Frame' {
		Parent = target,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,

		[Children] = {
			New 'Frame' {
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
				[Children] = {
					New 'UIPadding' {
						PaddingLeft = UDim.new(0, 20),
						PaddingRight = UDim.new(0, 20),
						PaddingTop = UDim.new(0, 20),
						PaddingBottom = UDim.new(0, 20),
					},
					New 'Frame' {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						[Children] = {

							New 'UIListLayout' {
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								HorizontalFlex = Enum.UIFlexAlignment.None,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								VerticalFlex = Enum.UIFlexAlignment.None,
								Padding = UDim.new(0, 10),
							},
							(function()
								local isHovered = Value(false)

								return New 'Frame' {
									Size = UDim2.fromOffset(1000, 200),
									BackgroundTransparency = 1,
									[OnEvent 'MouseEnter'] = function()
										isHovered:set(true)
									end,
									[OnEvent 'MouseLeave'] = function()
										isHovered:set(false)
									end,
									[Children] = {
										DeviceUIScale(),
										ReactiveStroke {
											IsHovered = isHovered,
										},
									},
								}
							end)(),
							(function()
								local isHovered = Value(false)

								return New 'Frame' {
									Size = UDim2.fromOffset(1000, 300),
									BackgroundTransparency = 1,
									[OnEvent 'MouseEnter'] = function()
										isHovered:set(true)
									end,
									[OnEvent 'MouseLeave'] = function()
										isHovered:set(false)
									end,
									[Children] = {
										DeviceUIScale(),
										New 'UIPadding' {
											PaddingTop = UDim.new(0, 30),
											PaddingBottom = UDim.new(0, 30),
											PaddingLeft = UDim.new(0, 30),
											PaddingRight = UDim.new(0, 30),
										},
										New 'UIListLayout' {
											FillDirection = Enum.FillDirection.Horizontal,
											HorizontalAlignment = Enum.HorizontalAlignment.Center,
											HorizontalFlex = Enum.UIFlexAlignment.Fill,
											VerticalAlignment = Enum.VerticalAlignment.Center,
											VerticalFlex = Enum.UIFlexAlignment.Fill,
											Padding = UDim.new(0, 50),
										},
										ReactiveStroke {
											IsHovered = isHovered,
										},
										ForValues(shopUnits, function(section)
											return New 'Frame' {
												BackgroundTransparency = 1,
												[Children] = {
													New 'UIListLayout' {
														FillDirection = Enum.FillDirection.Vertical,
														VerticalFlex = Enum.UIFlexAlignment.Fill,
														HorizontalFlex = Enum.UIFlexAlignment.Fill,
														SortOrder = Enum.SortOrder.Name,
														Padding = UDim.new(0, 50),
													},
													New 'TextLabel' {
														Name = '0',
														Text = section.Name,
														TextScaled = true,
														BackgroundTransparency = 1,
														LayoutOrder = 1,
														TextColor3 = Color3.new(1, 1, 1),
														Size = UDim2.fromOffset(0, 30),
														FontFace = Font.new('rbxassetid://12187368625'),

														[Children] = {
															New 'UIFlexItem' {
																FlexMode = Enum.UIFlexMode.None,
															},
														},
													},
													New 'Frame' {
														LayoutOrder = 0,
														BackgroundTransparency = 1,
														[Children] = {
															New 'UIListLayout' {
																FillDirection = Enum.FillDirection.Horizontal,
																HorizontalFlex = Enum.UIFlexAlignment.Fill,
																VerticalAlignment = Enum.VerticalAlignment.Center,
																Padding = UDim.new(0, 10),
															},
															ForValues(section, function(unit)
																local isHovered = Value(false)

																return New 'Frame' {
																	BackgroundTransparency = 1,
																	Size = UDim2.fromOffset(100, 200),
																	[OnEvent 'MouseEnter'] = function()
																		isHovered:set(true)
																	end,
																	[OnEvent 'MouseLeave'] = function()
																		isHovered:set(false)
																	end,
																	[Children] = {
																		ReactiveStroke { IsHovered = isHovered }
																	},
																}
															end, Fusion.cleanup),
														},
													},
												},
											}
										end, Fusion.cleanup),
									},
								}
							end)(),
						},
					},
				},
			},
		},
	}

	return ui
end
