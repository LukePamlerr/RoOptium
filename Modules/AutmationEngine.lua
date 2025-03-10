-- AutomationEngine.lua
local AutomationEngine = {}
AutomationEngine.__index = AutomationEngine

function AutomationEngine:Init(core)
    self.Core = core
    self.Tasks = {}
    self:ScheduleTasks()
end

function AutomationEngine:ScheduleTasks()
    local rewardSystem = self.Core:GetModule("RewardSystem")
    local roleManager = self.Core:GetModule("RoleManager")
    
    -- Weekly top performer payout
    task.spawn(function()
        while wait(604800) do -- 1 week
            rewardSystem:RewardTopPerformers()
        end
    end)
    
    -- Daily role suggestion check
    task.spawn(function()
        while wait(86400) do -- 1 day
            for _, player in pairs(game.Players:GetPlayers()) do
                local suggestedRole = roleManager:SuggestPromotion(player)
                if suggestedRole then
                    roleManager:AssignRole(player, suggestedRole)
                end
            end
        end
    end)
end

return AutomationEngine
