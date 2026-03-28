---@diagnostic disable: duplicate-set-field
local Template = require "src.npcs.template"
local Config = require "config.config"

local SpeedWalker = setmetatable({}, {__index = Template})
SpeedWalker.__index = SpeedWalker
SpeedWalker.image = love.graphics.newImage("assets/npc/speedwalker.png")

function SpeedWalker:new(lanes)
    -- inherit Template
    local o = Template:new()
    setmetatable(o, SpeedWalker)

    -- Overrride
    o.name = "Speed Walker"
    o.image = SpeedWalker.image
    o.scale = 1
    o.walkSpeed = 750 * Config.SpeedMultiplier
    o.lanes = lanes
    return o
end

return SpeedWalker
