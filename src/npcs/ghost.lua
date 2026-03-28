---@diagnostic disable: duplicate-set-field
local Config = require "config.config"
local Template = require "src.npcs.template"

local Ghost = setmetatable({}, {__index = Template})
Ghost.__index = Ghost
Ghost.image = love.graphics.newImage("assets/npc/ghost.png")

-- Ghost moves slow and sneaks up on the player.
-- Comes in and out of visibility
-- Once it pass 2 chunks from the player, it will disappear.
function Ghost:new()
    local o = Template:new()
    setmetatable(o, Ghost)
    -- defaults
    o.name = o.name or "Ghost"
    o.image = Ghost.image
    o.walkSpeed = 175  * Config.SpeedMultiplier
    o.fadeTimer = 0
    o.fadeDuration = 2 -- seconds for full fade in/out
    o.fadeDirection = 1 -- 1 = fade in, -1 = fade out
    o.invisibleHold = 3 -- seconds to stay fully invisible
    o.invisibleHoldTimer = o.invisibleHold -- start in the invisible hold phase
    o.laneSwitchTimer = 0
    o.laneSwitchInterval = math.random(2, 4)

    if o.lane == 0 then
        o.y = ScreenHeight/2 - o.height/2 - Config.ChunkSize
    else
        o.y = ScreenHeight/2 + o.height/2 - Config.ChunkSize
    end

    return o
end


function Ghost:update(dt)
    
    -- if about to collide into the player, stop fading and stay fully visible
    if self.x < self.bufferZone.x + self.bufferZone.width then
        self.fadeTimer = self.fadeDuration
        self.fadeDirection = -1
    end

    if self.invisibleHoldTimer > 0 then
        self.invisibleHoldTimer = self.invisibleHoldTimer - dt
        return
    end

    self.fadeTimer = self.fadeTimer + dt * self.fadeDirection

    if self.fadeTimer >= self.fadeDuration then
        self.fadeDirection = -1
        self.fadeTimer = self.fadeDuration
    elseif self.fadeTimer <= 0 then
        -- fully invisible again — reset the hold
        self.fadeTimer = 0
        self.fadeDirection = 1
        self.invisibleHoldTimer = self.invisibleHold
    end
end

function Ghost:draw()
    local alpha = self.colliding and 1 or (self.fadeTimer / self.fadeDuration)
    love.graphics.setColor(1, 1, 1, alpha)
    love.graphics.draw(self.image, self.x, self.y - self.offset)
    love.graphics.setColor(1, 1, 1, 1) -- reset color
end

return Ghost