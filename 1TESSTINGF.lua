local KuroNotif = {}
KuroNotif.__index = KuroNotif

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")

local webhookUrl = "https://discord.com/api/webhooks/your_webhook_url"

function KuroNotif.new()
    local self = setmetatable({}, KuroNotif)
    return self
end

-- Renamed the method to SendNotif
function KuroNotif:sSendNotif(customMessage)
    customMessage = customMessage or "No message provided."
    local title = (LocalPlayer and LocalPlayer.DisplayName) or "Unknown Player"
    local productInfo = MarketplaceService:GetProductInfo(game.PlaceId)
    local gameName = productInfo.Name or "Unknown Game"
    
    local timestamp = os.date("%a %B %d %I:%M:%S %p")
    
    local embed = {
        title = title .. " says: " .. customMessage,
        color = 11546102,
        footer = { text = "Timestamp: " .. timestamp },
        fields = {
            {
                name = "Game Info",
                value = "Game: " .. gameName .. "\nJobID: " .. tostring(game.JobId)
            }
        }
    }
    
    local data = {
        content = "",
        embeds = { embed }
    }
    
    local jsonData = HttpService:JSONEncode(data)
    
    local requestFunc = http_request -- Ensure that http_request is available in your environment
    local success, response = pcall(function()
        return requestFunc({
            Url = webhookUrl,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = jsonData
        })
    end)
    
    if not success then
        warn("Notification failed:", response)
    end
    return success, response
end

return KuroNotif