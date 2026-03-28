local Config = require "config.config"
local Helper = require "utils.helper"

-- NPCs
local SpeedWalker = require "src.npcs.speedWalker"
local Ghost = require "src.npcs.ghost"


local SpecialEvent = {}
SpecialEvent.__index = SpecialEvent

function SpecialEvent:new(player, lanes)
    local o = {}
    setmetatable(o, SpecialEvent)
    o.player = player
    o.lanes = lanes
    o.eventActive = false
    o.currentEvent = nil

    -- event timer
    o.eventTime = 0
    o.eventTimerEnd = 0

    -- timer to check if a event should trigger
    o.rollInterval = 30
    o.rollTimer = 0

    -- npc spawn timer for events
    o.npcSpawnTimer = 0
    o.npcSpawnInterval = .5

    return o
end

function SpecialEvent:spawnEvent(dt)
    if self.eventActive then return nil end

    self.rollTimer = self.rollTimer + dt
    if self.rollTimer < self.rollInterval then return nil end

    self.rollTimer = 0

    if math.random(1, 10) == 1 then
        self.eventActive = true
        self.currentEvent = self:pickEvent()
    end
end


function SpecialEvent:pickEvent()

    local specialEvents = {
        "speedWalkerRace",
        "horror"
    }

    local randomEvent = math.random(1, #specialEvents)

    return specialEvents[randomEvent]
end


function SpecialEvent:specialEventRunner(event,dt)
    if event == "speedWalkerRace" then
        self:speedWalkerRace(dt)
    elseif event == "horror" then
        self:horrorShow(dt)
    end
end


-- spawn a bunch of speed walkers like you just walked into
-- a race, in the future the start of the event will
-- spawn a finshline and the end of the event will have
-- a start line.
function SpecialEvent:speedWalkerRace(dt)
    if self.eventTimerEnd == 0 then
        self.eventTimerEnd = 10
    end

    self.eventTime = self.eventTime + dt

    -- event over, reset timers
    if self.eventTime >= self.eventTimerEnd then
        self.eventTime = 0
        self.eventTimerEnd = 0
        self.npcSpawnTimer = 0
        self.eventActive = false
        self.currentEvent = nil
        return
    end

    -- spawn a speed walker every npcSpawnInterval seconds
    self.npcSpawnTimer = self.npcSpawnTimer + dt
    if self.npcSpawnTimer >= self.npcSpawnInterval then
        self.npcSpawnTimer = 0
        local npc = SpeedWalker:new(self.lanes)
        npc.lane = math.random(1, 2)
        npc.player = self.player
        table.insert(NPCs, npc)
    end
end


function SpecialEvent:horrorShow(dt)
    if self.eventTimerEnd == 0 then
        self.eventTimerEnd = 5
    end

    self.eventTime = self.eventTime + dt

    -- event over, reset timers
    if self.eventTime >= self.eventTimerEnd then
        self.eventTime = 0
        self.eventTimerEnd = 0
        self.npcSpawnTimer = 0
        self.eventActive = false
        self.currentEvent = nil
        return
    end

    -- spawn a speed walker every npcSpawnInterval seconds
    self.npcSpawnTimer = self.npcSpawnTimer + dt
    if self.npcSpawnTimer >= self.npcSpawnInterval then
        self.npcSpawnTimer = 0
        local npc = Ghost:new(self.lanes)
        npc.lane = math.random(1, 2)
        npc.player = self.player
        npc.bufferZone = self.bufferZone
        table.insert(NPCs, npc)
    end
end

return SpecialEvent
