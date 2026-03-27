---@diagnostic disable: duplicate-set-field
local config = require "config.config"
local helper = require "utils.helper"
local ScrollingEnvironment = require "src.environment.scrollingEnvironment"

local Background = setmetatable({}, {__index = ScrollingEnvironment})
Background.__index = Background

function Background:new()
    local o = ScrollingEnvironment:new()
    setmetatable(o, Background)
    o.assets = {
        love.graphics.newImage("assets/environment/bg-01.png"),
        love.graphics.newImage("assets/environment/bg-02.png"),
    }
    o.assetStack = {}
    for i, asset in ipairs(o.assets) do o.assetStack[i] = asset end
    o.scrollSpeed = 25  * config.SpeedMultiplier-- default scroll speed, can be set externally
    o.scale = 2 -- default scale
    o.scene = o:buildScene() -- rebuild scene with new assets
    return o
end

return Background
