
-- Configuration and constants
local config = require "config.config"

-- Utility functions
local helper = require "utils.helper"

-- Game objects
local player = require "src.player.player"

-- Environment
local background = require "src.environment.background"
local foreground = require "src.environment.foreground"
local lanes = require "src.environment.lanes"
local score = require "src.interface.score"

-- Game state management
local collisionManager = require "src.controllers.collisionManager"
local spawner = require "src.controllers.spawner"

function love.load()
    ScreenWidth, ScreenHeight = config.ScreenWidth, config.ScreenHeight
    love.window.setTitle("Sidewalk Simulator")
    love.window.setMode(ScreenWidth, ScreenHeight)

    Player = player:new()
    Lanes = lanes:new()
    Background = background:new()
    Foreground = foreground:new(Lanes)
    Spawner = spawner:new(Player, Lanes) --- IGNORE ---
    GameScore = score:new()
    NPCs = {}
    CollisionManager = collisionManager:new(Player, NPCs)
    FrameCount = 0
end

function love.draw()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", 0, 0, ScreenWidth, ScreenHeight)
    Background:draw()
    Lanes:draw()
    Foreground:draw()
    Player:draw()
    for _, npc in ipairs(NPCs) do
        npc:draw()
    end
    CollisionManager:draw()
    GameScore:draw()
    Spawner:draw()
end

function love.update(dt)
    Player:update(dt)
    for _, npc in ipairs(NPCs) do
        if npc.walk then npc:walk(dt) end
    end
    CollisionManager:update(dt)
    Spawner:update(dt, GameScore.score)
    GameScore:update()
    Background:update(dt)
    Lanes:update(dt)
end


function love.keypressed(key)
    local controls = config.Controls

    -- TODO: fix this pause implementation. [BUG]
    if helper.arrayContains(controls.pause, key) then
        love.update = love.update and nil
    end

    if helper.arrayContains(controls.reset, key) then
        love.load()
        return
    end
    Player:debug(key)
    Player:controller(key)

    -- pass the key press to the NPCs for debugging purposes
    for _, npc in ipairs(NPCs) do
        npc:debug(key)
    end
end

