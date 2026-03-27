---@diagnostic disable: duplicate-set-field
local scrollingEnvironment = require("src.environment.scrollingEnvironment")
local config = require "config.config"

-- for temporary visualization of lanes
local Lanes = setmetatable({}, {__index = scrollingEnvironment})
Lanes.__index = Lanes

function Lanes:new()
    local o = scrollingEnvironment:new()
    setmetatable(o, Lanes)
    o.laneHeight = Player.height
    o.lane1 = {
        x = 0,
        y = ScreenHeight/2 - Player.height/2 -  config.ChunkSize,
        width = ScreenWidth,
        height = o.laneHeight
    }
    o.lane2 = {
        x = 0,
        y = ScreenHeight/2 + Player.height/2 -  config.ChunkSize,
        width = ScreenWidth,
        height = o.laneHeight
    }
    
    o.scale = 2
    o.y = o.lane1.y
    o.maxSceneSize = 3
    o.assets = {
        love.graphics.newImage("assets/environment/sidewalk.png")
    }
    o.assetStack = {}
    for i, asset in ipairs(o.assets) do o.assetStack[i] = asset end
    o.scrollSpeed = 150 * config.SpeedMultiplier
    o.scrollOffset = 50
    o.xOffset = 0
    o.scene = o:buildScene() -- rebuild scene with new assets
    return o
end

function Lanes:debug()
    love.graphics.setColor(config.LaneColor)

    love.graphics.rectangle("fill", self.lane1.x, self.lane1.y, self.lane1.width, self.lane1.height)
    love.graphics.rectangle("fill", self.lane2.x, self.lane2.y, self.lane2.width, self.lane2.height)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("line", self.lane1.x, self.lane1.y, self.lane1.width, self.lane1.height)
    love.graphics.rectangle("line", self.lane2.x, self.lane2.y, self.lane2.width, self.lane2.height)
end



return Lanes
