---@diagnostic disable: duplicate-set-field
local Template = require "src.npcs.template"
local Config = require "config.config"

local TheDistracted = setmetatable({}, {__index = Template})
TheDistracted.__index = TheDistracted
TheDistracted.image = love.graphics.newImage("assets/npc/distracted.png")

function TheDistracted:new(lanes)
    -- inherit Template
    local o = Template:new()
    setmetatable(o, TheDistracted)

    -- Overrride
    o.name = "The Distracted"
    o.image = TheDistracted.image
    o.lane = o.lane or 1
    o.laneSwitchTimer = 0
    o.laneSwitchInterval = math.random(1, 3) -- switch lanes every 2-5 seconds
    o.hasChangedLane = false

    -- initialize y to the starting lane so moveToLane has a valid starting position
    if o.lane == 0 then
        o.y = ScreenHeight/2 - o.height/2 - Config.ChunkSize
    else
        o.y = ScreenHeight/2 + o.height/2 - Config.ChunkSize
    end

    return o
end

function TheDistracted:draw()
    love.graphics.setColor(1, 1, 1)
    -- draw at self.y directly — do NOT snap y to lane here, let moveToLane handle it smoothly
    love.graphics.draw(
        self.image,
        self.x,
        self.y - self.offset,
        0,
        self.flipImage and 1 or -1,
        1
    )
    self:hitbox()
end

function TheDistracted:walk(dt)
    self.x = self.x - self.walkSpeed * dt
    
    -- only lane change if the NPC is 2 chunks from the player
    -- we don't want the NPC to lane change into the player
    local playerWidth = Config.ChunkSize * 2
    local playerSafeZone = playerWidth + (Config.ChunkSize * 2)
    
    if self.x > playerSafeZone and not self:inBufferZone() then
        self:switchLaneTimer(dt)
    end

    self:moveToLane(self.lane, dt)
    
    if self.x + self.width < 0 then
        self.remove = true
    end
end

-- create a timer, if dt exceeds timer, switch lanes and reset timer
function TheDistracted:switchLaneTimer(dt)
    self.laneSwitchTimer = self.laneSwitchTimer + dt
    if self.laneSwitchTimer >= self.laneSwitchInterval then
        self.laneSwitchTimer = 0
        
        if self.lane == 0 then
            self.lane = 1
        else
            self.lane = 0
        end

        self.laneSwitchInterval = math.random(1, 3)
    end
end

return TheDistracted
