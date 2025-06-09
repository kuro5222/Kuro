local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")

local productInfo = MarketplaceService:GetProductInfo(game.PlaceId)
local gameName = productInfo.Name

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

local content = ""

local embed = {
    title = LocalPlayer.DisplayName .. " got Crashed",
    color = 11546102,
    footer = { text = "" },
    author = {
        name = "Crashed"
    },
    fields = {
        {
            name = "Crashed in | " .. gameName,
            value = game.JobId
        }
    },
    timestamp = timestamp
}

local webhookUrl = "https://discord.com/api/webhooks/1381312522858270720/BwYnfcLuMi0rsW5xrgHbEzAZ0oEcyMUZ7YWKdGk5j_prrK5Foxz2TTQrxQeAnkeku9oZ"

local requestFunc = syn and syn.request or http_request
requestFunc {
    Url = webhookUrl,
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = HttpService:JSONEncode({
        content = content,
        embeds = { embed }
    })
}