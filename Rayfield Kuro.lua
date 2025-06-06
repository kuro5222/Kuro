-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")

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
    Icon = 0,
    LoadingTitle = "Loading...",
    LoadingSubtitle = "WHATS UP NIKA 🍆🥒",
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
    Title = "Welcome! " .. LocalPlayer.DisplayName,
    Text = "How's are you bro?😏😘",
    Icon = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=180&h=180",
    Duration = 5
})

-- Status Tab
local StatusTab = Window:CreateTab("Status", 4483362458)
local LocalTimeLabel = StatusTab:CreateLabel("Current Time: --:--:--")
local UTCTimeLabel = StatusTab:CreateLabel("UTC Time: --:--:--")
local PlayerCountLabel = StatusTab:CreateLabel("Players: --")
local StatusPosLabel = StatusTab:CreateLabel("Position: --, --, --")

-- Update Time (using task.spawn and task.wait)
task.spawn(function()
    while task.wait(0.5) do -- Use task.wait
        local localTime = os.date("%I:%M:%S %p")
        local utcTime = os.date("!%I:%M:%S %p")
        LocalTimeLabel:Set("Local Time: " .. localTime)
        UTCTimeLabel:Set("UTC Time: " .. utcTime)
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

-- Update Player Position (using task.spawn and task.wait, with checks)
task.spawn(function()
    while task.wait(0.1) do -- Use task.wait
        local character = LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart") -- Check character first
        local posText = "Position: --, --, --"
        if hrp then
            posText = string.format("Position: %.2f, %.2f, %.2f", hrp.Position.X, hrp.Position.Y, hrp.Position.Z)
        end
        StatusPosLabel:Set(posText)
        PlayerPosLabel:Set(posText)
    end
end)

-- Save Position
PlayerTab:CreateButton({
    Name = "Set Position",
    Callback = function()
        local character = LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if hrp then
            lastPos = hrp.CFrame
            StatusLabel:Set(string.format("Saved Position: X=%.2f, Y=%.2f, Z=%.2f", lastPos.Position.X, lastPos.Position.Y, lastPos.Position.Z))
        else
            StatusLabel:Set("Could not find HumanoidRootPart. Make sure your character is loaded.")
        end
    end,
})

-- Teleport to Saved Position
PlayerTab:CreateButton({
    Name = "Teleport to Saved Position",
    Callback = function()
        if lastPos then
            local character = LocalPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Teleport with a small vertical offset to prevent clipping into the ground
                hrp.CFrame = lastPos + Vector3.new(0, 1, 0)
                StatusLabel:Set(string.format("Teleported to: X=%.2f, Y=%.2f, Z=%.2f", lastPos.Position.X, lastPos.Position.Y, lastPos.Position.Z))
            else
                StatusLabel:Set("Could not find HumanoidRootPart. Make sure your character is loaded.")
            end
        else
            StatusLabel:Set("No position saved yet.")
        end
    end,
})

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
    end,
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
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        else
            warn("JumpRequest: Humanoid not found!")
        end
    end
end)

PlayerTab:CreateInput({
    Name = "⚡WalkSpeed",
    CurrentValue = "16",
    PlaceholderText = "Input Speed",
    RemoveTextAfterFocusLost = false,
    Flag = "Speed",
    Callback = function(Value)
        local speed = tonumber(Value)
        if speed then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
        else
            warn("Invalid WalkSpeed value: " .. tostring(Value))
        end
    end,
})

PlayerTab:CreateSlider({
    Name = "JumpPower",
    Range = {10, 150},
    Increment = 5,
    Suffix = "Power",
    CurrentValue = 50,
    Flag = "Power",
    Callback = function(Value)
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = Value
        else
            warn("JumpPower: Humanoid not found!")
        end
    end,
})

-- Other Buttons and Inputs (WARNING: loadstring usage remains)
PlayerTab:CreateButton({
    Name = "🕊️Fly gui",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/fly%20gui.lua"))()
    end,
})

PlayerTab:CreateButton({
    Name = "Jork",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/Jork.lua"))()
    end,
})

PlayerTab:CreateButton({
    Name = "reset",
    Callback = function()
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Dead)
            -- humanoid.Health = 0
        else
            warn("Reset: Humanoid not found!")
        end
    end,
})

PlayerTab:CreateButton({
    Name = "First Person🧑",
    Callback = function()
        LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
    end,
})

PlayerTab:CreateButton({
    Name = "Third Person",
    Callback = function()
        LocalPlayer.CameraMaxZoomDistance = 128
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
    end,
})

PlayerTab:CreateInput({
    Name = "Max Zoom",
    CurrentValue = "128",
    PlaceholderText = "Place Zoom Distance",
    RemoveTextAfterFocusLost = false,
    Flag = "Zoom",
    Callback = function(num)
        local n = tonumber(num)
        if n then
            LocalPlayer.CameraMaxZoomDistance = math.clamp(n, 0.5, 500) -- Clamp zoom to reasonable values
        else
            warn("Max Zoom: Invalid input, setting to default.")
            LocalPlayer.CameraMaxZoomDistance = 128 -- Default if invalid
        end
    end,
})

-- Utility Tab (Renamed from 'utility' to avoid nil error)
local UtilityTab = Window:CreateTab("Utility", "rewind") -- Correctly define UtilityTab

UtilityTab:CreateButton({
    Name = "Nameless Admin",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/NA%20testing.lua"))()
    end,
})

-- Function to get players by name or display name
local function getPlr(name)
    local foundPlayers = {}
    local searchNameLower = string.lower(name)
    for _, plr in ipairs(Players:GetPlayers()) do
        local usernameLower = string.lower(plr.Name)
        local displayNameLower = plr.DisplayName and string.lower(plr.DisplayName)
        
        local usernameMatch = string.find(usernameLower, searchNameLower, 1, true)
        local displayNameMatch = displayNameLower and string.find(displayNameLower, searchNameLower, 1, true)
        
        if usernameMatch or displayNameMatch then
            table.insert(foundPlayers, plr)
        end
    end
    return foundPlayers
end

-- Goto Functionality
UtilityTab:CreateInput({
    Name = "Goto",
    CurrentValue = "",
    PlaceholderText = "--Enter Player Name",
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
                Title = "Teleport Failed",
                Text = "Could not find target or your character parts.",
                Duration = 2.5,
            })
        end
    end,
})

UtilityTab:CreateButton({
    Name = "Esp on",
    Callback = function(Value)
            loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/Esp.lua"))()
    end,
})

UtilityTab:CreateButton({
    Name = "Esp off",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/Remove.lua"))()
    end,
})

UtilityTab:CreateInput({
    Name = "Quality",
    CurrentValue = "",
    PlaceholderText = "1-10",
    RemoveTextAfterFocusLost = false,
    Flag = "Quality",
    Callback = function(value)
        local lvl = tonumber(value)
        if lvl then
            lvl = math.clamp(lvl, 1, 10)
            settings().Rendering.QualityLevel = lvl
        else
            warn("Quality: Invalid input, QualityLevel not changed.")
        end
    end,
})

UtilityTab:CreateSlider({
    Name = "Time",
    Range = {1, 24},
    Increment = 1,
    Suffix = "time",
    CurrentValue = 12,
    Flag = "time",
    Callback = function(v)
        local hour = math.floor(v)
        game.Lighting.TimeOfDay = string.format("%02d:00:00", hour)
    end,
})

UtilityTab:CreateButton({ -- Use UtilityTab
    Name = "Rejoin",
    Callback = function()
        -- Only attempt if player exists
        if LocalPlayer then
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        else
            warn("Rejoin: LocalPlayer not found.")
        end
    end,
})

UtilityTab:CreateButton({
    Name = "Leave",
    Callback = function()
        game:Shutdown()
    end,
})

-- GUI Tab
local GuiTab = Window:CreateTab("Gui", 4483362458)

GuiTab:CreateButton({
    Name = "⌨️Keyboard",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/Keyboard.lua"))()
    end,
})

GuiTab:CreateButton({
    Name = "📒Notepad",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/notepad.lua"))()
    end,
})

GuiTab:CreateButton({
    Name = "Universal Viewer",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/Universe%20Viewer.lua"))()
    end,
})

GuiTab:CreateButton({
    Name = "👀Simple Spy",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/SimpleSpy.lua"))()
    end,
})

GuiTab:CreateButton({
    Name = "🗂️Dex v3",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/DexMobile.lua"))()
    end,
})

GuiTab:CreateButton({
    Name = "🔒ShiftLock",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/ShiftLock.lua"))()
    end,
})

GuiTab:CreateButton({
    Name = "Exec",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/executor.lua"))()
    end,
})

GuiTab:CreateButton({
    Name = "SICRET SCREPT",
    Callback = function()
        for i = 5, 1, -1 do
            StarterGui:SetCore("SendNotification", {
                Title = tostring(i),
                Text = "⚠️⚠️⚠️",
                Duration = 1
            })
            task.wait(1) -- Use task.wait
        end

        StarterGui:SetCore("SendNotification", {
            Title = "It's a prank",
            Text = "Nothing happened, but why did you click it?🤨🤨",
            Duration = 3
        })
    task.wait(25)
    
    game.Players.LocalPlayer:Kick("Perm ban (Reason: Hacking)")
    
        task.wait(1.5)
        while true do
    end
end,
})