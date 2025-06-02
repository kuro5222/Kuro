--nametag
local function RemoveESP(v)
   if v.Character and v.Character:FindFirstChildOfClass'Humanoid' then
       v.Character.Humanoid.NameDisplayDistance = 100
       v.Character.Humanoid.NameOcclusion = "OccludeAll" 
   end
end

for i,v in pairs(game.Players:GetPlayers()) do
   RemoveESP(v)
end

game.Players.PlayerAdded:Connect(function(v)
   RemoveESP(v)
end)

game.Players.PlayerAdded:Connect(function(v)
   v.CharacterAdded:Connect(function()
       task.wait(0.33)
       RemoveESP(v)
   end)
end)

--outline
local Players = game:GetService("Players")

local function removeHighlights(character)
    for _, obj in ipairs(character:GetDescendants()) do
        if obj:IsA("Highlight") then
            obj:Destroy()
        end
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then
        removeHighlights(player.Character)
    end
    player.CharacterAdded:Connect(removeHighlights)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(removeHighlights)
end)
