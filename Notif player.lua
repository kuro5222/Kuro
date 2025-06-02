-- notification for leaving/joining players with pfp 😄😄
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local function getAvatarIcon(userId)
    return "https://www.roblox.com/headshot-thumbnail/image?userId="..userId.."&width=150&height=150&format=png"
end

local function notifyPlayerEvent(player, eventText)
    StarterGui:SetCore("SendNotification", {
        Title = "Player " .. player.Name ,
        Text = " HAS😩 " .. eventText .. " THE GAME🔥! ",
        Duration = 2.5,
        Icon = getAvatarIcon(player.UserId)
    })
end

Players.PlayerAdded:Connect(function(player)
    if player ~= Players.LocalPlayer then
        notifyPlayerEvent(player, "JOINED😃")
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if player ~= Players.LocalPlayer then
        notifyPlayerEvent(player, "LEFT🙁")
    end
end)