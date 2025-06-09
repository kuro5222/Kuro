local KuroNotif = {}
KuroNotif.__index = KuroNotif

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")

local productInfo = MarketplaceService:GetProductInfo(game.PlaceId)
local gameName = productInfo.Name

local webhookUrl = "https://discord.com/api/webhooks/1381312522858270720/BwYnfcLuMi0rsW5xrgHbEzAZ0oEcyMUZ7YWKdGk5j_prrK5Foxz2TTQrxQeAnkeku9oZ"

function KuroNotif.new()
    local self = setmetatable({}, KuroNotif)
    return self
end

function KuroNotif:SendNotif(customMessage)
    customMessage = customMessage or "Missing code"
    local title = LocalPlayer.DisplayName

local function getCustomTimestamp()
    local timeNow = os.time()
    local weekday = os.date("%a", timeNow)
    local month = os.date("%B", timeNow)
    local day = tonumber(os.date("%d", timeNow))
    
    local hour24 = tonumber(os.date("%H", timeNow))
    local hour12 = hour24 % 12
    local minute = os.date("%M", timeNow)
    local second = os.date("%S", timeNow)
    local ampm = (hour24 < 12) and "AM" or "PM"
    
    local timeString = string.format("%d:%s:%s %s", hour12, minute, second, ampm)
    return string.format("Time of execute | %s %s %d %s", weekday, month, day, timeString)
end

local customTimestamp = getCustomTimestamp()

    local embed = {
        title = title .. " executes | " .. customMessage,
        color = 11546102,
        footer = { text = customTimestamp },
        author = {
            name = "Script Notifier"
        },
        fields = {
            {
                name = "Executed in | " .. gameName,
            },
            {   name = "Game/Job Id | " .. tostring(gameId)
        },
    }

    local payload = {
        content = "",
        embeds = { embed }
    }
    
    local requestFunc = http_request
    requestFunc {
        Url = webhookUrl,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode(payload)
    }
end

return KuroNotif