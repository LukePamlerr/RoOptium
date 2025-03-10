-- SecurityModule.lua
local SecurityModule = {}
SecurityModule.__index = SecurityModule

local Logger = require(script.Parent.Parent.Utilities.Logger)

function SecurityModule:Init(core)
    self.Core = core
    self.AuthTokens = {}
end

function SecurityModule:Generate2FAToken(userId)
    local token = HttpService:GenerateGUID(false)
    self.AuthTokens[userId] = token
    return token
end

function SecurityModule:Verify2FA(userId, token)
    return self.AuthTokens[userId] == token
end

function SecurityModule:LogAction(userId, action)
    Logger:Log("Security", string.format("%s performed %s on %s", userId, action, os.date("%c")))
    self.Core:GetModule("WebAPI"):SendUpdate("SecurityLog", { UserId = userId, Action = action })
end

return SecurityModule
