---@diagnostic disable: duplicate-set-field
local Config = require "config.config"
local Template = require "src.npcs.template"

local Granny = setmetatable({}, {__index = Template})
Granny.__index = Granny
Granny.image = love.graphics.newImage("assets/npc/granny.png")

function Granny:new(lanes)
    local o = Template:new()
    setmetatable(o, Granny)
    -- defaults
    o.name = o.name or "Granny"
    o.image = Granny.image
    o.lanes = lanes
    o.walkSpeed = 175  * Config.SpeedMultiplier
    return o
end


return Granny