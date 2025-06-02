--Outline
local Players = game:GetService("Players")

local function applyHighlight(player)
local function onCharacterAdded(character)
local highlight = Instance.new("Highlight", character)

highlight.Archivable = true
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.Enabled = true
highlight.FillColor = Color3.fromRGB(128, 128, 128)
highlight.OutlineColor = Color3.fromRGB(102, 0, 204)
highlight.FillTransparency = 0.5
highlight.OutlineTransparency = 0
end

if player.Character then
onCharacterAdded(player.Character)
end

player.CharacterAdded:Connect(onCharacterAdded)
end

for _, player in pairs(Players:GetPlayers()) do
applyHighlight(player)
end

Players.PlayerAdded:Connect(applyHighlight)

--nametag
local function ApplyESP(v)
   if v.Character and v.Character:FindFirstChildOfClass'Humanoid' then
       v.Character.Humanoid.NameDisplayDistance = 9e9
       v.Character.Humanoid.NameOcclusion = "NoOcclusion"
   end
end
for i,v in pairs(game.Players:GetPlayers()) do
   ApplyESP(v)
   v.CharacterAdded:Connect(function()
       task.wait(0.33)
       ApplyESP(v)
   end)
end

game.Players.PlayerAdded:Connect(function(v)
   ApplyESP(v)
   v.CharacterAdded:Connect(function()
       task.wait(0.33)
       ApplyESP(v)
   end)
  end)
