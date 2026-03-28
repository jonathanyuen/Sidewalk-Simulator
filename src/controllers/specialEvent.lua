local Config = require "config.config"
local Helper = require "utils.helper"

local SpecialEvent = {}
SpecialEvent.__index = Spawner

function SpecialEvent:new()
    local o = {}
    setmetatable(o, SpecialEvent)
    o.magicNumber = 1
    o.magicMin = 0 
    o.magicMax = 10 -- picking 1 out of 0-10 is a 10% chance
    o.spawnEvent = false

    return o
end

function SpecialEvent:spawnEvent()
    local roll = math.random(0,10)

    if roll == self.magicNumber then
        return self:pickEvent()
    end

    return nil

end


function SpecialEvent:pickEvent()

    local specialEvents = {
        "speedWalkerRace"
    }

    local randomEvent = math.random(1, #specialEvents)

    return randomEvent
end


function SpecialEvent:SpecialEventRunner(event)
    if event == "speedWalkerRace" then
        self:speedWalkerRace()
    end 
end


function SpecialEvent:speedWalkerRace()
    
end

