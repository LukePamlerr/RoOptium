-- Core.lua
local Core = {}
Core.__index = Core

local Modules = script.Parent.Modules
local Utilities = script.Parent.Utilities
local HttpService = game:GetService("HttpService")
local VERSION = "3.1.0"

function Core.new(groupId, config)
    local self = setmetatable({}, Core)
    self.GroupId = groupId
    self.Config = config or { DebugMode = false, WebhookUrl = "" }
    self.Modules = {}
    self.Version = VERSION
    
    -- Load modules with error handling
    for _, module in pairs(Modules:GetChildren()) do
        local success, result = pcall(function()
            self.Modules[module.Name] = require(module)
        end)
        if not success then
            warn("Failed to load module " .. module.Name .. ": " .. result)
        end
    end
    
    -- Initialize modules with advanced context
    for name, module in pairs(self.Modules) do
        if module.Init then
            module:Init(self, self.Config)
        end
    end
    
    -- Sync with website on startup
    self:SyncWithWebsite()
    
    return self
end

function Core:GetModule(name)
    return self.Modules[name] or error("Module " .. name .. " not found")
end

function Core:SyncWithWebsite()
    local webAPI = self:GetModule("WebAPI")
    if self.Config.WebhookUrl then
        webAPI:SendUpdate("CoreInitialized", { GroupId = self.GroupId, Version = self.Version })
    end
end

function Core:Shutdown()
    for _, module in pairs(self.Modules) do
        if module.Shutdown then module:Shutdown() end
    end
end

return Core
