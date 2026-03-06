local Config = require "config.config"
local Helper = require "utils.helper"

--NPCs
local AvgJoe = require "src.npcs.avgJoe"
local TheDistracted = require "src.npcs.theDistracted"
local SpeedWalker = require "src.npcs.speedWalker"

local Spawner = {}
Spawner.__index = Spawner

function Spawner:new(player, lanes)
    local o = {}
    setmetatable(o, Spawner)
    o.player = player
    o.lanes = lanes
    o.spawnTimer = 0
    o.nextSpawn = o:nextSpawnTime(0)
    
    -- buffer zone
    o.bufferZone = {
        x = player.x - (Config.ChunkSize / 2),  -- x
        y = lanes.lane1.y, -- y
        width = Config.ChunkSize * 4, -- width
        height = Config.ChunkSize * 4 -- height 
    }

    return o
end

function Spawner:draw()
    self:drawBufferZone()
end

-- Call this in love.update(dt)
function Spawner:update(dt, score)
    self.spawnTimer = self.spawnTimer + dt

    -- If no NPCs exist, spawn one immediately
    if #NPCs == 0 then
        local laneNum = math.random(1, 2)
        
        local npcType = self:getRandomSpawn(score)
        local npc

        if npcType == "AvgJoe" then
            npc = AvgJoe:new()
        elseif npcType == "TheDistracted" then
            npc = TheDistracted:new()
        elseif npcType == "SpeedWalker" then
            npc = SpeedWalker:new()
        else
            npc = AvgJoe:new()
        end
        if npc then
            npc.lane = laneNum
            table.insert(NPCs, npc)
        end
        self.spawnTimer = 0
        self.nextSpawn = self:nextSpawnTime(score)
        return
    end

    -- Spawn NPCs at random intervals
    if self.spawnTimer >= self.nextSpawn then
        self.spawnTimer = 0
        self.nextSpawn = self:nextSpawnTime(score)
        local laneNum = math.random(1, 2)
        local npcType = self:getRandomSpawn(score)
        local npc
        if npcType == "AvgJoe" then
            npc = AvgJoe:new()
        elseif npcType == "TheDistracted" then
            npc = TheDistracted:new()
        elseif npcType == "SpeedWalker" then
            npc = SpeedWalker:new()
        else
            npc = AvgJoe:new()
        end

        if npc and not self:willOverlapBufferZone(npc) then
            npc.lane = laneNum
            table.insert(NPCs, npc)
        end
    end

    -- Despawn NPCs that go off screen
    for i, npc in ipairs(NPCs) do
        print("Checking NPC at x: " .. npc.x)
        if npc.x + npc.width < 0 then
            print("Despawning NPC at x: " .. npc.x)
            table.remove(NPCs, i)
        end
    end

    print("Number of NPCs: " .. #NPCs)
end


function Spawner:getRandomSpawn(score)
    
    local tutorialNPCs = {
        "AvgJoe"
    }

    local easyNpcTypes = {
        "TheDistracted"
    }

    local medNPCTypes = {
        "SpeedWalker"
    }
    local hardNPCTypes = {}

    local npcPool = {}

    if score >=0 then
        Helper.arraySpread(npcPool, tutorialNPCs)
    end

    if score >= 50 then
        Helper.arraySpread(npcPool, easyNpcTypes)
    end

    if score >= 100 then
        Helper.arraySpread(npcPool, medNPCTypes)
    end

    if score >= 200 then
        Helper.arraySpread(npcPool, hardNPCTypes)
    end
    
    local randomIndex = math.random(1, #npcPool)
    local randomNpc = npcPool[randomIndex]
    
     -- Debug print the NPC type being spawned
     if Config.DebugToggle then
        print("Spawning NPC type: " .. randomNpc)
    end
    return randomNpc
end

function Spawner:nextSpawnTime(score)
    local spawnMin, spawnMax = 10, 50

    if score >= 50 then
        spawnMin, spawnMax = 10, 40
    end

    if score >= 100 then
        spawnMin, spawnMax = 10, 35
    end

    if score >= 200 then
        spawnMin, spawnMax = 10, 30
    end

    local randomInterval = math.random(spawnMin, spawnMax) / 10
    return randomInterval
end

function Spawner:willOverlapBufferZone(newNpc)
    local bufferStart = self.bufferZone.x
    local bufferEnd = bufferStart + self.bufferZone.width
    local npcWidth = newNpc.width
    local npcSpeed = newNpc.walkSpeed
    local npcSpawnX = newNpc.spawnX

    -- When will the new NPC enter and exit the buffer zone?
    local newEnter = (npcSpawnX - bufferEnd) / npcSpeed
    local newExit  = (npcSpawnX - bufferStart - npcWidth) / npcSpeed

    for _, npc in ipairs(NPCs) do
        local existingEnter = (npc.x - bufferEnd) / npc.walkSpeed
        local existingExit  = (npc.x - bufferStart - npc.width) / npc.walkSpeed

        -- Check for overlap in time intervals
        if not (newExit < existingEnter or newEnter > existingExit) then
            return true -- Overlap detected
        end
    end
    return false -- No overlap
end


function Spawner:drawBufferZone()
    if(Config.DebugToggle) then
        love.graphics.setColor(1, 0, 0, 0.5)
        love.graphics.rectangle(
        "fill", 
        self.bufferZone.x, -- x
        self.bufferZone.y, -- y
        self.bufferZone.width, -- width
        self.bufferZone.height -- height
    )
    end
end

return Spawner