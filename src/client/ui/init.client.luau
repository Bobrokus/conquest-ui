local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Packages = ReplicatedStorage.Packages

local Player = game:GetService('Players').LocalPlayer
local PlayerGui = Player.PlayerGui

local Camera = workspace.CurrentCamera

local Fusion = require(Packages.Fusion)
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

print(script:GetChildren())

local TeamSelectionScreen = require(script["TeamSelectionScreen.story"])
local LoadoutScreen = require(script["LoadoutScreen.story"])
local DeviceUIScaleLib = require(script.DeviceUIScale)

local currentScreen = Value("loadout")

Hydrate(Camera) {
	[OnChange 'ViewportSize'] = DeviceUIScaleLib.ResolutionChanged,
}

New "ScreenGui" {
	Parent = game.Players.LocalPlayer.PlayerGui,

	[Children] = {
		Computed(function()
			local screen = currentScreen:get()

			if screen == "team_selection" then
				return TeamSelectionScreen()
			elseif screen == "loadout" then
				return LoadoutScreen()
			end
		end)
	}
}