local message = ""
local function Notify()
    if game.TextChatService:FindFirstChild("TextChannels") then
        if game.TextChatService.TextChannels:FindFirstChild("RBXGeneral") then
            game.TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(message)
        end
    else

game.StarterGui:SetCore("ChatMakeSystemMessage", {
    Text = message;
})
end
end

game:GetService('RunService').Heartbeat:connect(function()for _, v in pairs(game.Players:GetPlayers()) do
    if v.Name ~= game.Players.LocalPlayer.Name then
        if v.Character.Humanoid.Health == 0 or v.Character.Humanoid.Health <= 0 then
            message = v.Name.." Died💀"
            Notify()
            v.Character:Destroy()
            end
        end
    end
end)

LocalPlayerDied = false
    getgenv().LocalPlayerDiedOperator = true
        while getgenv().LocalPlayerDiedOperator == true do
        spawn(function()
            if LocalPlayerDied == false then
                if not game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or game.Players.LocalPlayer.Character.Humanoid.Health == 0 or game.Players.LocalPlayer.Character.Humanoid.Health <= 0 then
    LocalPlayerDied = true
    message = game.Players.LocalPlayer.Name.."Died💀"
    Notify()
end
else
    if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and
    game.Players.LocalPlayer.Character.Humanoid.Health >= 1 then
        LocalPlayerDied = false
    end
            end
end)
wait(0.1)
end
