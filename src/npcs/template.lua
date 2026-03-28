local Config = require "config.config"
local Template = {}

Template.__index = Template
Template.image = love.graphics.newImage("assets/npc/placeholder.png")

function Template:new(o)
    o = o or {}
    setmetatable(o, Template)
    -- defaults
    o.name = o.name or "Template NPC"
    o.width = o.width or Config.ChunkSize
    o.height = o.height or Config.ChunkSize * 2
    o.spawnX = o.spawnX or Config.ScreenWidth
    o.x = o.x or o.spawnX
    o.y = o.y or ScreenHeight/2 - o.height/2 - Config.ChunkSize -- offset the Y by a bit to align with lanes
    o.offset = o.offset or math.random(30, 60) -- offset the y position
    o.color = o.color or {1, 1, 1}
    o.walkSpeed = 250 * Config.SpeedMultiplier
    o.laneChangeSpeed = 100
    o.lane = 1 -- binary lane system, 0 is the top lane, 1 is the bottom lane
    o.drawHitbox = false
    o.image = o.image or Template.image
    o.flipImage = o.flipImage or true
    return o
end

function Template:draw()
    love.graphics.setColor(1, 1, 1)

    if self.lane == 0 then
        self.y = ScreenHeight/2 - self.height/2 - Config.ChunkSize
    end

    if self.lane == 1 then
        self.y = ScreenHeight/2 + self.height/2 - Config.ChunkSize
    end

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

-- walk straight until off screen, then remove from game
function Template:walk(dt)
    self.x = self.x - self.walkSpeed * dt

    if self.x + self.width < 0 then
        -- remove from game 
        self.remove = true
    end 
end

function Template:moveToLane(targetLane, dt)
    local targetY
    if targetLane == 0 then
        targetY = ScreenHeight/2 - self.height/2 - Config.ChunkSize
    else
        targetY = ScreenHeight/2 + self.height/2 - Config.ChunkSize
    end

    if self.y < targetY then
        self.y = math.min(self.y + self.laneChangeSpeed * dt, targetY)
    elseif self.y > targetY then
        self.y = math.max(self.y - self.laneChangeSpeed * dt, targetY)
    end
end

function Template:hitbox()

    if self.drawHitbox then
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("line",
        self.x - 1, 
        self.y + self.height/2 - 1 - self.offset,  
        self.width + 2, 
        self.height/2 + 2)
    end

    return {
        x = self.x,
        y = self.y,
        width = self.width,
        height = self.height/2
    }
end

function Template:inBufferZone()
    if not self.bufferZone then return false end
    local bx = self.bufferZone.x
    local bEnd = bx + self.bufferZone.width
    return self.x < bEnd and self.x + self.width > bx
end

function Template:debug(key)
    if key == "`" then
        self.drawHitbox = not self.drawHitbox
    end
end


return Template