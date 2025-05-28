local AllPlayers = ""
for _, v in pairs(game.Players:GetPlayers()) do 
   if v.Name ~= game.Players.LocalPlayer.Name then
       AllPlayers = AllPlayers.." "..v.Name
   end
end



--Notify Function
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
--

wait(1)
game:GetService('RunService').RenderStepped:connect(function()
for _, v in pairs(game.Players:GetPlayers()) do 
   if v.Name ~= game.Players.LocalPlayer.Name then
       if not AllPlayers.find(AllPlayers, v.Name) then
          AllPlayers = AllPlayers.." "..v.Name
          message = v.Name.." has joined the Experience."
          Notify()
      end
   end
end
end)

game.Players.PlayerRemoving:Connect(function(player)
if AllPlayers.find(AllPlayers, player.Name) then
   AllPlayers = string.gsub(AllPlayers, player.Name, "")
   message = player.Name.." has left the Experience."
   Notify()
end
end)
