-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

-- Variables
local LocalPlayer = Players.LocalPlayer
local jumpEnabled = false
local noclipEnabled = false
local noclipConnection
local lastPos = nil

-- Ensure PlayerGui orientation
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
playerGui.ScreenOrientation = Enum.ScreenOrientation.LandscapeSensor

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "Kuro GUI",
    Icon = nil,
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Just for Fun lol",
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

StarterGui:SetCore("SendNotification", {
    Title = "Weclome! " .. Players.LocalPlayer.DisplayName,
    Text = "😏Whats up bby gurl😏",
    Icon = "rbxthumb://type=AvatarHeadShot&id=" .. Players.LocalPlayer.UserId .. "&w=180&h=180 true",
    Duration = 30
})

-- Status Tab
local StatusTab = Window:CreateTab("Status", 4483362458)
local LocalTimeLabel = StatusTab:CreateLabel("Current Time: --:--:--")
local UTCTimeLabel = StatusTab:CreateLabel("UTC Time: --:--:--")
local PlayerCountLabel = StatusTab:CreateLabel("Players: --")
local StatusPosLabel = StatusTab:CreateLabel("Position: --, --, --")

-- Update Time
task.spawn(function()
    while true do
        local localTime = os.date("%I:%M:%S %p")
        local utcTime = os.date("!%I:%M:%S %p")
        LocalTimeLabel:Set("Local Time: " .. localTime)
        UTCTimeLabel:Set("UTC Time: " .. utcTime)
        wait(0.5)
    end
end)

-- Update Player Count
local function updatePlayerCount()
    PlayerCountLabel:Set("Players in server: " .. #Players:GetPlayers())
end
Players.PlayerAdded:Connect(updatePlayerCount)
Players.PlayerRemoving:Connect(updatePlayerCount)
updatePlayerCount()

-- Player Tab
local PlayerTab = Window:CreateTab("Player", 4483362458)
local PlayerPosLabel = PlayerTab:CreateLabel("Position: --, --, --")
local StatusLabel = PlayerTab:CreateLabel("No position saved yet.")

-- Update Player Position
task.spawn(function()
    while true do
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local posText = hrp and string.format("Position: %.2f, %.2f, %.2f", hrp.Position.X, hrp.Position.Y, hrp.Position.Z) or "Position: --, --, --"
        StatusPosLabel:Set(posText)
        PlayerPosLabel:Set(posText)
        wait(0.1)
    end
end)

-- Save Position
PlayerTab:CreateButton({
    Name = "Set Position",
    Callback = function()
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            lastPos = hrp.CFrame
            StatusLabel:Set(string.format("Saved Position: X=%.2f, Y=%.2f, Z=%.2f", lastPos.Position.X, lastPos.Position.Y, lastPos.Position.Z))
        else
            StatusLabel:Set("Could not find HumanoidRootPart.")
        end
    end
})

-- Teleport to Saved Position
PlayerTab:CreateButton({
    Name = "Teleport to Saved Position",
    Callback = function()
        if lastPos then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = lastPos
                StatusLabel:Set(string.format("Teleported to: X=%.2f, Y=%.2f, Z=%.2f", lastPos.Position.X, lastPos.Position.Y, lastPos.Position.Z))
            else
                StatusLabel:Set("Could not find HumanoidRootPart.")
            end
        else
            StatusLabel:Set("No position saved yet.")
        end
    end
})

-- Noclip Functionality
local function setNoclip(state)
    if state then
        if not noclipConnection then
            noclipConnection = RunService.Stepped:Connect(function()
                local character = LocalPlayer.Character
                if character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
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
        local character = LocalPlayer.Character
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

LocalPlayer.CharacterAdded:Connect(function()
    if noclipEnabled then
        setNoclip(true)
    end
end)

-- Jump Override Toggle
PlayerTab:CreateToggle({
    Name = "Enable Jump Override",
    CurrentValue = false,
    Flag = "JumpOverrideToggle",
    Callback = function(Value)
        jumpEnabled = Value
    end,
})

UserInputService.JumpRequest:Connect(function()
    if jumpEnabled then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        else
            warn("Humanoid not found!")
        end
    end
end)

PlayerTab:CreateSlider({
   Name = "Walkseed",
   Range = {0.1, 150},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Speed",
   Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end
})

PlayerTab:CreateSlider({
    Name = "JumpPower",
    Range = {10, 150},
    Increment = 5,
    Suffix = "Power",
    CurrentValue = 50,
    Flag = "Power",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
        end
})
-- Other Buttons and Inputs
PlayerTab:CreateButton({
    Name = "🕊️Fly gui",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/fly%20gui.lua"))()
    end
})

PlayerTab:CreateButton({
    Name = "Jork",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/Jork.lua"))()
    end
})

PlayerTab:CreateButton({
    Name = "reset",
    Callback = function()
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                humanoid.Health = 0
            end
        end
    end
})

PlayerTab:CreateButton({
    Name = "First Person🧑",
    Callback = function()
        LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
    end
})

PlayerTab:CreateButton({
    Name = "Third Person",
    Callback = function()
        LocalPlayer.CameraMaxZoomDistance = 128
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
    end
})

PlayerTab:CreateInput({
    Name = "Max Zoom",
    CurrentValue = "",
    PlaceholderText = "Place Zoom Distance",
    RemoveTextAfterFocusLost = false,
    Flag = "Zoom",
    Callback = function(num)
        local n = tonumber(num) or 128
        LocalPlayer.CameraMaxZoomDistance = n
    end
})

local utility = Window:CreateTab("Utility", "rewind")

-- Function to get players by name or display name
local function getPlr(name)
    local foundPlayers = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        local searchName = string.lower(name)
        local usernameMatch = string.find(string.lower(plr.Name), searchName, 1, true)
        local displayNameMatch = plr.DisplayName and string.find(string.lower(plr.DisplayName), searchName, 1, true)
        if usernameMatch or displayNameMatch then
            table.insert(foundPlayers, plr)
        end
    end
    return foundPlayers
end

-- Goto Functionality
utility:CreateInput({
    Name = "Goto",
    CurrentValue = "",
    PlaceholderText = "Enter Player Name",
    RemoveTextAfterFocusLost = true,
    Flag = "goto",
    Callback = function(inputValue)
        local targetPlayers = getPlr(inputValue)
        if #targetPlayers == 0 then
            StarterGui:SetCore("SendNotification", {
                Title = "Player " .. inputValue,
                Text = "❌NOT FOUND❌",
                Duration = 2.5,
            })
            return
        end

        local targetPlayer = targetPlayers[1]
        local targetCharacter = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
        local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
        local myCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")

        if targetRoot and myRoot then
            myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 5, 0)
            StarterGui:SetCore("SendNotification", {
                Title = "Teleported to " .. targetPlayer.Name,
                Text = "SUCCESS",
                Duration = 2.5,
            })
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Player " .. targetPlayer.Name,
                Text = "Failed❌",
                Duration = 2.5,
            })
        end
    end
})

utility:CreateButton({
    Name = "Esp on",
    Callback = function(Value)
            loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/Esp.lua"))()
    end
})

utility:CreateButton({
    Name = "Esp off",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/Remove.lua"))()
    end
})

utility:CreateInput({
    Name = "Quality",
    CurrentValue = "",
    PlaceholderText = "1-10",
    RemoveTextAfterFocusLost = false,
    Flag = "Quality",
    Callback = function(value)
        local lvl = tonumber(value) or 5
        lvl = math.clamp(lvl, 1, 10)
        settings().Rendering.QualityLevel = lvl
    end
})

-- GUI Tab
local GuiTab = Window:CreateTab("Gui", 4483362458)

-- Other GUI Buttons

GuiTab:CreateButton({
    Name = "⌨️Keyboard",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/Keyboard.lua"))()
    end
})

GuiTab:CreateButton({
    Name = "📒Notepad",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/notepad.lua"))()
    end
})

GuiTab:CreateButton({
    Name = "Tpu",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/Universe%20Viewer.lua"))()
    end
})

GuiTab:CreateButton({
    Name = "👀Simple Spy",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/SimpleSpy.lua"))()
    end
})

GuiTab:CreateButton({
    Name = "🗂️Dex v3",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/DexMobile.lua"))()
    end
})

GuiTab:CreateButton({
    Name = "🔒ShiftLock",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/ShiftLock.lua"))()
    end
})

GuiTab:CreateButton({
    Name = "Exec",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/executor.lua"))()
    end
})

GuiTab:CreateButton({
    Name = "Destroy Rayfield",
    Callback = function()
        Rayfield:Destroy()
    end
})

GuiTab:CreateButton({
    Name = "Crash💀",
    Callback = function()
        while true do end
    end
})
