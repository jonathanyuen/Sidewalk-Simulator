---@diagnostic disable: duplicate-set-field
local Config = require "config.config"
local Helper = require "utils.helper"
local ScrollingEnvironment = require "src.environment.scrollingEnvironment"

local Foreground = setmetatable({}, {__index = ScrollingEnvironment})
Foreground.__index = Foreground

function Foreground:new()
    local o = ScrollingEnvironment:new()
    setmetatable(o, Foreground)
    o.assets = {
        love.graphics.newImage("assets/environment/fg-01.png"),
        love.graphics.newImage("assets/environment/fg-02.png"),
        love.graphics.newImage("assets/environment/fg-03.png"),
        love.graphics.newImage("assets/environment/fg-04.png"),
        love.graphics.newImage("assets/environment/fg-05.png"),
    }
    o.assetStack = {}
    o.y = Config.ScreenHeight - o.assets[1]:getHeight() * o.scale
    for i, asset in ipairs(o.assets) do o.assetStack[i] = asset end
    o.scrollSpeed = 150 * Config.SpeedMultiplier -- default scroll speed, can be set externally
    o.scale = 2 -- default scale
    o.scene = o:buildScene() -- rebuild scene with new assets
    return o
end

return Foreground
