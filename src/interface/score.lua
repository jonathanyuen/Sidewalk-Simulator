local Config = require "config.config"

local Score = {}
Score.__index = Score

function Score:new()
    local o = {}
    setmetatable(o, Score)
    o.score = 0
    o.frameCount = 0
    o.font = love.graphics.newFont(25)
    o.speedLevel = 0
    return o
end

function Score:update()
    self.frameCount = self.frameCount + 1
    if self.frameCount % 10 == 0 then
        self.score = self.score + 1
        self:increaseSpeed()
    end
end

function Score:increaseSpeed()
    local speedIncrease = Config.SpeedIncreasePerLevel or 0.05
    local pointsPerSpeedLevel = Config.PointsPerSpeedLevel or 50
    local newSpeedLevel = math.floor(self.score / pointsPerSpeedLevel)
    
    if newSpeedLevel > self.speedLevel then
        Config.SpeedMultiplier = Config.SpeedMultiplier + (speedIncrease * (newSpeedLevel - self.speedLevel))
        self.speedLevel = newSpeedLevel
    end
end

function Score:draw()
    local scorePos = {
        x = ScreenWidth - 200,
        y = 35
    }

    love.graphics.setFont(self.font)
    love.graphics.setColor(0,0,0)
    love.graphics.print("Score: " .. tostring(self.score), scorePos.x, scorePos.y)
    love.graphics.print(string.format("Speed: %.1f mph", 10 * Config.SpeedMultiplier), scorePos.x, scorePos.y + 30)
end

function Score:reset()
    self.score = 0
    self.frameCount = 0
end

return Score
