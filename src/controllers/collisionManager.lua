local CollisionManager = {}
CollisionManager.__index = CollisionManager

function CollisionManager:new(player, npcs)
    local self = setmetatable({}, CollisionManager)
    self.player = player
    self.npcs = npcs or {}
    self.collisionOver = false
    self.collisionDetected = true
    return self
end

function CollisionManager:update(dt)
    -- Update all NPCs
    for _, npc in ipairs(self.npcs) do
        if npc.update then
            npc:update(dt)
        end
    end
    -- Check collisions
    self:checkCollisions()
end

function CollisionManager:checkCollisions()
    local playerHitbox = self.player:hitbox()
    self.collisionMessage = nil
    local anyCollision = false
    for _, npc in ipairs(self.npcs) do
        local npcHitbox = npc:hitbox()
        if self:hitboxCollision(playerHitbox, npcHitbox) then
            npc.colliding = true
            anyCollision = true
            self.collisionDetected = true
            if self.collisionOver == true then
                self.player.health = self.player.health - 1
                self.collisionOver = false
            end
            self.collisionMessage = "Collision with " .. npc.name .. "! Health: " .. self.player.health
            break
        else
            npc.colliding = false
        end
    end

    if not anyCollision and self.collisionDetected then
        self.collisionOver = true
        self.collisionDetected = false
    end
end

function CollisionManager:hitboxCollision(a, b)
    return a.x < b.x + b.width and
           b.x < a.x + a.width and
           a.y < b.y + b.height and
           b.y < a.y + a.height
end


function CollisionManager:draw()
    if self.collisionDetected then
        love.graphics.setColor(1, 0, 0)

        -- TODO: Remove debug text and replace with some kind of visual indicator of collision
        if self.collisionMessage then
            love.graphics.print(self.collisionMessage, 20, 20)
        end
    end


    if self.player.health <= 0 then
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("Game Over!", ScreenWidth/2 - 50, ScreenHeight/2)
        love.graphics.setColor(1, 1, 1)
    end
end

return CollisionManager
