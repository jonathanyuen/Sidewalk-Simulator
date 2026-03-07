---@diagnostic disable: duplicate-set-field
local Config = require "config.config"
local Template = require "src.npcs.template"

local Granny = setmetatable({}, {__index = Template})
Granny.__index = Granny

function Granny:new(o)
    o = o or Template:new()
    setmetatable(o, Granny)
    -- defaults
    o.name = o.name or "Granny"
    o.image = love.graphics.newImage("assets/npc/granny.png")
    o.walkSpeed = 175 -- slower than average joe
    return o
end


return Granny