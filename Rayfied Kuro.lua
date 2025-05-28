local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Kuro test",
   Icon = 0,
   LoadingTitle = "Loading...",
   LoadingSubtitle = "",
   Theme = "Default",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Kuro Rayfield"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = false
})

local StatusTab = Window:CreateTab("Status", 4483362458)

local LocalTimeLabel = StatusTab:CreateLabel("Current Time: --:--:-- --")
local UTCTimeLabel = StatusTab:CreateLabel("UTC time: --:--:-- --")
local PlayerCountLabel = StatusTab:CreateLabel("Current players: --")
local PosLabel = StatusTab:CreateLabel("Position: --, --, --")
spawn(function()
    while true do
        local localTime = os.date("%I:%M:%S %p")
        local utcTime = os.date("!%I:%M:%S %p")
        LocalTimeLabel:Set("Local Time: " .. localTime)
        UTCTimeLabel:Set("UTC Time: " .. utcTime)
        wait(0.5)
    end
end)

local function updatePlayerCount()
    PlayerCountLabel:Set("Players in server: " .. #Players:GetPlayers())
end

Players.PlayerAdded:Connect(updatePlayerCount)
Players.PlayerRemoving:Connect(updatePlayerCount)

updatePlayerCount()

spawn(function()
    while true do
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local pos = hrp.Position
            PosLabel:Set(string.format("Position: %.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z))
        else
            PosLabel:Set("Position: --, --, --")
        end
        wait(0.1)
    end
end)

local PlayerTab = Window:CreateTab("Player", 4483362458)

local noclipEnabled = false
local noclipConnection

local function setNoclip(state)
    if state then
        if not noclipConnection then
            noclipConnection = RunService.Stepped:Connect(function()
                local character = Players.LocalPlayer.Character
                if character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        local character = Players.LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        noclipEnabled = Value
        setNoclip(noclipEnabled)
    end
})

Players.LocalPlayer.CharacterAdded:Connect(function()
    if noclipEnabled then
        setNoclip(true)
    end
end)

local WalkSpeed = PlayerTab:CreateInput({
   Name = "WalkSpeed",
   CurrentValue = "16",
   PlaceholderText = "Set Speed",
   RemoveTextAfterFocusLost = false,
   Flag = "Speed",
   Callback = function(Value)
       local character = Players.LocalPlayer.Character
if character and character:FindFirstChild("Humanoid") then
    character.Humanoid.WalkSpeed = tonumber(Value)
        end
    end,
})

local JumpPower = PlayerTab:CreateInput({
   Name = "JumpPower",
   CurrentValue = "50",
   PlaceholderText = "Set Power",
   RemoveTextAfterFocusLost = false,
   Flag = "JumpPower",
   Callback = function(Value)
      local character = Players.LocalPlayer.Character
if character and character:FindFirstChild("Humanoid") then
    character.Humanoid.JumpPower = tonumber(Value)
        end
    end,
})

local FlyButton = PlayerTab:CreateButton({
   Name = "Fly gui",
   Callback = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/fly%20gui.lua"))()
   end,
})

local luluButton = PlayerTab:CreateButton({
    Name = "lulu 🤨🤨",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/Jork.lua"))()
    end,
})

PlayerTab:CreateButton({
    Name = "No interaction",
    Callback = function()
        while true do
wait(0,3)
for i,v in ipairs(game:GetService("Workspace"):GetDescendants()) do if v.ClassName == "ProximityPrompt" then v.HoldDuration = 0 end end
        end
    end
})

local reset = PlayerTab:CreateButton({
    Name = "reset",
    Callback = function()
        local player = Players.LocalPlayer
        if player and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                humanoid.Health = 0
            end
        end
    end
})

local 1stPerson = PlayerTab:CreateButton({
    Name = "First Person🧑",
    Callback = function()
        Player.CameraMode="LockFirstPerson"
    end
})

local 3rdPerson = PlayerTab:CreateButton({
    Name = "Third Person",
    Callback = function()
        Player.CameraMaxZoomDistance-math.huge
        Player.CameraMode="Classic"
    end
})

local MaxZoom = PlayerTab:CreateInput({
    Name = "Max Zoom",
    CurrentValue = "",
    PlaceholderText = "Place Zoom Distance",
    RemoveTextAfterFocusLost = false,
    Flag = "Zoom",
    Callback = function(num)
        local n = tonumber(num) or 128
        Players.LocalPlayer.CameraMaxZoomDistance = n
    end
})

local GuiTab = Window:CreateTab("Gui", 4483362458)

local Keyboard = GuiTab:CreateButton({
    Name = "Keyboard",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/Keyboard.lua"))()
    end
})

local Notepad = GuiTab:CreateButton({
    Name = "Notepad",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/notepad.lua"))()
    end
})

local Tpu = GuiTab:CreateButton({
    Name = "Tpu",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/Universe%20Viewer.lua"))()
    end
})

local console = GuiTab:CreateButton({
    Name = "console",
    Callback = function()
        StarterGui:SetCore("DevConsoleVisible", true)
    end
})

local SimpleSpy = GuiTab:CreateButton({
    Name = "Simple Spy",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/SimpleSpy.lua"))()
    end
})

local ShiftLock = GuiTab:CreateButton({
    Name = " ShiftLock",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/ShiftLock.lua"))()
    end
})

local Destroy = GuiTab:CreateButton({
    Name = "Destroy Rayfield",
    Callback = function()
        Rayfield:Destroy()
    end
})
local Crash = GuiTab:CreateButton({
    Name = "Crash💀",
    Callback = function()
        while true do
        end
    end
})

