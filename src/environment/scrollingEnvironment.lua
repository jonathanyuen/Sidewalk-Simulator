local config = require "config.config"
local helper = require "utils.helper"

local ScrollingEnvironment = {}
ScrollingEnvironment.__index = ScrollingEnvironment

function ScrollingEnvironment:new()
    local o = {}
    setmetatable(o, ScrollingEnvironment)
    o.assets = {
        love.graphics.newImage("assets/environment/bg-01.png"),
        love.graphics.newImage("assets/environment/bg-02.png"),
    }
    o.assetStack = {}
    for i, asset in ipairs(o.assets) do o.assetStack[i] = asset end
    o.maxSceneSize = math.ceil(ScreenWidth / (o.assets[1]:getWidth() * 2)) + 2 -- calculate how many tiles we need to fill the screen, plus one for seamless scrolling
    o.scrollSpeed = 75 * config.SpeedMultiplier-- default scroll speed
    o.scrollOffset = 50 -- default offset for safety, extra padding
    o.xOffset = 0
    o.y = 0
    o.scale = 2 -- default scale
    o.scene = {} -- Initialize as empty table; subclasses should build the scene after overriding assets
    return o
end

function ScrollingEnvironment:update(dt)
    -- Scroll the background
    self.xOffset = self.xOffset - self.scrollSpeed * dt

    -- Check if the first tile is off screen (with offset)
    local firstAsset = self.scene[1]
    if firstAsset then
        local assetWidth = firstAsset:getWidth() * self.scale
        if self.xOffset <= -assetWidth - self.scrollOffset then
            -- Remove the first tile
            table.remove(self.scene, 1)
            -- Add a new tile to the end
            local randomIndex = math.random(1, #self.assets)
            local newAsset = self.assets[randomIndex]
            table.insert(self.scene, newAsset)
            -- Reset xOffset for seamless scroll
            self.xOffset = self.xOffset + assetWidth
        end
    end
end

function ScrollingEnvironment:draw()
    love.graphics.setColor(1, 1, 1)

    for i, asset in ipairs(self.scene) do
        local assetWidth = asset:getWidth() * self.scale
        local x = self.xOffset + (i-1) * assetWidth
        love.graphics.draw(
            asset,
            x, -- X
            self.y, -- Y
            0, -- rotation
            self.scale, -- scaleX
            self.scale) -- scaleY
    end
end

function ScrollingEnvironment:buildScene()
    local randomIndex = math.random(1, #self.assetStack)
    local asset = self.assetStack[randomIndex]

    if self.scene == nil then
        self.scene = {}
    end

    if #self.scene < self.maxSceneSize then
        for _ = #self.scene + 1, self.maxSceneSize do
            randomIndex = math.random(1, #self.assetStack)
            asset = self.assetStack[randomIndex]

            table.insert(self.scene, asset)

        end
    end

    return self.scene
end


function ScrollingEnvironment:calculateSize()
    local topLane = self.lanes.lane1
    local environmentX = 0
    local environmentY = topLane.y
    local environmentWidth = topLane.width
    local environmentHeight = environmentY      

    if config.DebugToggle  then
        print("Scrolling Environment X: " .. environmentX .. " Y: " .. environmentY .. " Width: " .. environmentWidth .. " Height: " .. environmentHeight)
    end

    return environmentX,  environmentY, environmentWidth, environmentHeight
end

return ScrollingEnvironment
