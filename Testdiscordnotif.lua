local WebhookNotifier = {}
WebhookNotifier.__index = WebhookNotifier

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")

local productInfo = MarketplaceService:GetProductInfo(game.PlaceId)
local gameName = productInfo.Name

local webhookUrl = "https://discord.com/api/webhooks/1381314605212762213/f8xgBzMo97LhGTbOq0TQVrMRQIyLf1mFbzPbgLQLuEDA_HLbAbrtoYh36ykFD4d8PP_h"

function WebhookNotifier.new()
    local self = setmetatable({}, WebhookNotifier)
    return self
end

function WebhookNotifier:sendNotification(customTitle, customMessage)
    customTitle = customTitle or LocalPlayer.DisplayName
    customMessage = customMessage or "No message provided."

    local timeNow = os.time()
    local timeFormatted = os.date("!*t", timeNow)
    local timestamp = string.format(
        "%d-%02d-%02dT%02d:%02d:%02dZ",
        timeFormatted.year,
        timeFormatted.month,
        timeFormatted.day,
        timeFormatted.hour,
        timeFormatted.min,
        timeFormatted.sec
    )

    local embed = {
        title = customTitle,
        color = 11546102,
        footer = { text = "" },
        author = {
            name = "Notify on script"
        },
        fields = {
            {
                name = "Used in | " .. gameName,
                value = game.JobId
            },
            {
                name = "Message",
                value = customMessage
            }
        },
        timestamp = timestamp
    }

    local payload = {
        content = "",
        embeds = { embed }
    }
    
    local requestFunc = (syn and syn.request) or http_request
    requestFunc {
        Url = webhookUrl,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode(payload)
    }
end

return WebhookNotifier