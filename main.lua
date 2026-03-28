
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
local pauseMenu = require "src.interface.pauseMenu"

-- Game state management
local collisionManager = require "src.controllers.collisionManager"
local spawner = require "src.controllers.spawner"
local Debug = require "src.interface.debug"

function love.load()
    ScreenWidth, ScreenHeight = config.ScreenWidth, config.ScreenHeight
    love.window.setTitle("Sidewalk Simulator")
    love.window.setMode(ScreenWidth, ScreenHeight)

    Player = player:new()
    Lanes = lanes:new()
    Background = background:new()
    Foreground = foreground:new()
    Spawner = spawner:new(Player, Lanes)
    GameScore = score:new()
    PauseMenu = pauseMenu:new()
    DebugHUD = Debug:new()

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
        if npc.drawBoundaries then npc:drawBoundaries() end 
    end
    CollisionManager:draw()
    GameScore:draw()
    Spawner:draw()
    PauseMenu:draw()
    DebugHUD:drawDebugInfo()
end

function love.update(dt)
    -- If the game is paused, skip updating game logic
    if PauseMenu.paused then return end

    Player:update(dt)
    for _, npc in ipairs(NPCs) do
        if npc.walk then npc:walk(dt) end
    end
    CollisionManager:update(dt)
    Spawner:update(dt, GameScore.score)
    GameScore:update(dt)
    Background:update(dt)
    Lanes:update(dt)
    Foreground:update(dt)
end


function love.keypressed(key)
    local controls = config.Controls

    if helper.arrayContains(controls.pause, key) then
        PauseMenu:toggle()
        return
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

