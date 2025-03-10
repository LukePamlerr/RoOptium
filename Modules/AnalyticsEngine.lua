-- AnalyticsEngine.lua
local AnalyticsEngine = {}
AnalyticsEngine.__index = AnalyticsEngine

local DataStoreService = game:GetService("DataStoreService")
local analyticsStore = DataStoreService:GetDataStore("AnalyticsData")

function AnalyticsEngine:Init(core)
    self.Core = core
    self.Metrics = {}
end

function AnalyticsEngine:LogEvent(userId, eventType, value)
    local data = analyticsStore:GetAsync(userId) or { PlayTime = 0, Contributions = 0 }
    if eventType == "PlayTime" then
        data.PlayTime = data.PlayTime + value
    elseif eventType == "Contribution" then
        data.Contributions = data.Contributions + value
    end
    analyticsStore:SetAsync(userId, data)
    self.Core:GetModule("WebAPI"):SendUpdate("AnalyticsUpdate", { UserId = userId, Event = eventType, Value = value })
end

function AnalyticsEngine:GetPlayerMetrics(userId)
    return analyticsStore:GetAsync(userId) or { PlayTime = 0, Contributions = 0 }
end

function AnalyticsEngine:GetGroupTrends()
    local totalPlayTime, totalContribs = 0, 0
    for _, player in pairs(game.Players:GetPlayers()) do
        local metrics = self:GetPlayerMetrics(player.UserId)
        totalPlayTime = totalPlayTime + metrics.PlayTime
        totalContribs = totalContribs + metrics.Contributions
    end
    return { AvgPlayTime = totalPlayTime / #game.Players:GetPlayers(), AvgContributions = totalContribs / #game.Players:GetPlayers() }
end

return AnalyticsEngine
