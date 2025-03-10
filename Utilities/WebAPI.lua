-- WebAPI.lua
local WebAPI = {}
WebAPI.__index = WebAPI

local HttpService = game:GetService("HttpService")

function WebAPI:Init(core)
    self.Core = core
end

function WebAPI:SendUpdate(endpoint, data)
    if self.Core.Config.WebhookUrl then
        local success, err = pcall(function()
            HttpService:PostAsync(self.Core.Config.WebhookUrl .. "/" .. endpoint, HttpService:JSONEncode(data))
        end)
        if not success then warn("WebAPI error: " .. err) end
    end
end

return WebAPI
