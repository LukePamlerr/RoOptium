-- RoleManager.lua
local RoleManager = {}
RoleManager.__index = RoleManager

local Permissions = require(script.Parent.Parent.Utilities.Permissions)

function RoleManager:Init(core, config)
    self.Core = core
    self.Roles = {}
    self.Config = config
    self:SyncRoles()
end

function RoleManager:SyncRoles()
    local groupService = game:GetService("GroupService")
    local roles = groupService:GetGroupInfo(self.Core.GroupId).Roles
    for _, role in pairs(roles) do
        self.Roles[role.Name] = { Rank = role.Rank, Permissions = {}, AIScore = 0 }
    end
end

function RoleManager:SuggestPromotion(player)
    local analytics = self.Core:GetModule("AnalyticsEngine")
    local activity = analytics:GetPlayerMetrics(player.UserId)
    local score = activity.PlayTime * 0.5 + activity.Contributions * 0.7
    for roleName, role in pairs(self.Roles) do
        if score > role.AIScore then
            return roleName
        end
    end
    return nil
end

function RoleManager:AssignRole(player, roleName)
    if not self.Roles[roleName] then return false end
    self.Core:GetModule("EventSystem"):Fire("RoleAssigned", player, roleName)
    return true
end

return RoleManager
