local Config = require "config.config"

local Debug = {}
Debug.__index = Debug

function Debug:new()
    local o = {}
    setmetatable(o, Debug)

    o.peakMem = 0

    return o
end


function Debug:drawDebugInfo()
    if not Config.DebugToggle then return end

    local fps = love.timer.getFPS()
    local memKB = collectgarbage("count")
    local memMB = memKB / 1024

    if memMB > self.peakMem then
        self.peakMem = memMB
    end

    local lines = {
        string.format("FPS: %d", fps),
        string.format("MEM: %.2f MB", memMB),
        string.format("Peak MEM: %.2f MB", self.peakMem),
        string.format("NPCs: %d", NPCs and #NPCs or 0),
    }

    local padding = 10
    local lineHeight = 25
    local x = ScreenWidth - 250
    local y = ScreenHeight - padding - (#lines * lineHeight) - 100

    love.graphics.setColor(0, 0, 0, 0.5)

    love.graphics.setColor(1, 1, 1)
    for i, line in ipairs(lines) do
        love.graphics.print(line, x, y + (i - 1) * lineHeight)
    end

    love.graphics.setColor(1, 1, 1)
end

return Debug