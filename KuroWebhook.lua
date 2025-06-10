local KuroNotif = {}
KuroNotif.__index = KuroNotif

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")

local productInfo = MarketplaceService:GetProductInfo(game.PlaceId)
local gameName = productInfo.Name

local webhookUrl = "https://discord.com/api/webhooks/1381314605212762213/f8xgBzMo97LhGTbOq0TQVrMRQIyLf1mFbzPbgLQLuEDA_HLbAbrtoYh36ykFD4d8PP_h"

function KuroNotif.new()
    local self = setmetatable({}, KuroNotif)
    return self
end

function KuroNotif:sendnotif(customMessage)
    customMessage = customMessage or "Missing Message"
    local title = LocalPlayer.DisplayName

    local function getCustomTimestamp()
        local timeNow = os.time()
        local weekday = os.date("%a", timeNow)
        local month = os.date("%B", timeNow)
        local day = tonumber(os.date("%d", timeNow))
        
        local hour24 = tonumber(os.date("%H", timeNow))
        local hour12 = hour24 % 12
        if hour12 == 0 then
            hour12 = 12
        end
        local minute = os.date("%M", timeNow)
        local second = os.date("%S", timeNow)
        local ampm = (hour24 < 12) and "AM" or "PM"
        
        local timeString = string.format("%d:%s:%s %s", hour12, minute, second, ampm)
        return string.format("%s | %s %d, | Time | %s", weekday, month, day, timeString)
    end

    local Time = getCustomTimestamp()

    local embed = {
        title = "# " .. title .. " used | " .. customMessage,
        color = 11546102,
        footer = { text = "Time execution | " .. Time },
        fields = {
            {
                name = "While in | " .. gameName,
                value = ""
            },
            {
                name = "Job Id",
                value = tostring(game.PlaceId)
            }
        }
    }

    local data = { content = "", embeds = { embed } }
    local jsonData = HttpService:JSONEncode(data)
    
    local requestFunc = http_request
    requestFunc({
        Url = webhookUrl,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = jsonData
    })
end

return KuroNotif