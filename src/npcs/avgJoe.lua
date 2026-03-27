---@diagnostic disable: duplicate-set-field
local Config = require "config.config"
local Template = require "src.npcs.template"

local AvgJoe = setmetatable({}, {__index = Template})
AvgJoe.__index = AvgJoe

function AvgJoe:new(lanes)
    local o = Template:new()
    setmetatable(o, AvgJoe)
    -- defaults
    o.name = o.name or "Average Joe"
    o.image = love.graphics.newImage("assets/npc/avgJoe-2x.png")
    o.lanes = lanes
    o.walkSpeed = math.random(225, 275)  * Config.SpeedMultiplier
    return o
end


return AvgJoe