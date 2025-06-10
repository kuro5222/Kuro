-- Services
loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/KuroLoginHook.lua"))()
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
local KuroNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/KuroLoggerHook.lua"))()

-- Variables
local GrowGame = 126884695634066
local LocalPlayer = Players.LocalPlayer
local jumpEnabled = false
local noclipEnabled = false
local noclipConnection
local lastPos = nil
local instantInteractEnabled = false
local disablePromptConnection
local Notif = KuroNotif.new()

-- Auto execute
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
playerGui.ScreenOrientation = Enum.ScreenOrientation.LandscapeSensor

--Random Messages 😏
local messages = {
    "Want some milk?😝",
    "Daiski😏🤭",
    "Ohayo Sensie😏",
    "Yoo Kenny is that you Kenny?",
    "Yoo using me again!??"
}

local RM = messages[math.random(#messages)]

local hour = tonumber(os.date("%H"))
local GT = ""
if hour >= 6 and hour < 12 then
    GT = "Good Morning Darling🤭"
elseif hour >= 12 and hour < 18 then
    GT = "Goodaftie Darling😝"
else
    GT = "Good evening Darling dont stay up too late 😤"
end

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = GT,
    Icon = 0,
    LoadingTitle = RM,
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

--[[StarterGui:SetCore("SendNotification", {
    Title = "MASTER " .. LocalPlayer.DisplayName,
    Text = "📸📸📸",
    Icon = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=180&h=180",
    Duration = 5
})]]

-- Status Tab
local StatusTab = Window:CreateTab("Status", nil)
local LocalTimeLabel = StatusTab:CreateLabel("Current Time: --:--:--")
local UTCTimeLabel = StatusTab:CreateLabel("UTC Time: --:--:--")
local PlayerCountLabel = StatusTab:CreateLabel("Players: --")
local StatusPosLabel = StatusTab:CreateLabel("Position: --, --, --")

-- Update Time (using task.spawn and task.wait)
task.spawn(function()
    while task.wait(0.5) do
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
local PlayerTab = Window:CreateTab("Player", nil)
local PlayerPosLabel = PlayerTab:CreateLabel("Position: --, --, --")
local StatusLabel = PlayerTab:CreateLabel("No position saved yet.")

-- Update Player Position (using task.spawn and task.wait, with checks)
task.spawn(function()
    while task.wait(0.1) do
        local character = LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
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

PlayerTab:CreateButton({
    Name = "Copy Position",
    Callback = function()
        setclipboard(tostring(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame))
        print("Copied", tostring(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame))
    end,
})

local S = PlayerTab:CreateInput({
    Name = "⚡WalkSpeed",
    CurrentValue = "",
    PlaceholderText = "-> Input Speed <-",
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

PlayerTab:CreateButton({
    Name = "Reset Speed",
    Callback = function()
        S:Set("")
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end,
})

local P = PlayerTab:CreateInput({
    Name = "🦵JumpPower",
    CurrentValue = "",
    PlaceholderText = "-> Input JumpPower <-",
    RemoveTextAfterFocusLost = false,
    Flag = "Power",
    Callback = function(Value)
        local Power = tonumber(Value)
        if Power then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = Power
        else
            warn("Invalid JumpPower value: " .. tostring(Value))
        end
    end,
})

PlayerTab:CreateButton({
    Name = "Reset Jump",
    Callback = function()
        P:Set("")
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
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

PlayerTab:CreateButton({
    Name = "🕊️Fly gui",
    Callback = function()
        Notif:sendnotif("Fly Gui")
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/fly%20gui.lua"))()
    end,
})

PlayerTab:CreateButton({
    Name = "Jork",
    Callback = function()
        Notif:sendnotif("Jork")
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/Jork.lua"))()
    end,
})

PlayerTab:CreateButton({
    Name = "reset",
    Callback = function()
        Notif:sendnotif("Reset")
        local function CallDie(D)
            if D == "Yes" then
                Notif:sendnotif("Picked Yes on Reset")
                local character = LocalPlayer.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                    print("Dies from cringe 😬 😬 ")
                end
            elseif D == "No" then
            end
        end

        local Die = Instance.new("BindableFunction")
        Die.OnInvoke = CallDie

        game.StarterGui:SetCore("SendNotification", {
            Title = "Die??",
            Text = "💀💀💀",
            Duration = 5,
            Button1 = "Yes",
            Button2 = "No",
            Callback = Die,
        })
    end,
})

PlayerTab:CreateButton({
    Name = "Cam Noclip",
    Callback = function()
        Notif:sendnotif("Cam Noclip")
        Players.LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
    end,
})

PlayerTab:CreateButton({
    Name = "Cam Clip",
    Callback = function()
        Notif:sendnotif("Cam Clip")
        Players.LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
    end,
})
PlayerTab:CreateButton({
    Name = "First Person🧑",
    Callback = function()
        Notif:sendnotif("First Person")
        LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
    end,
})

PlayerTab:CreateButton({
    Name = "Normal Zoom",
    Callback = function()
        Notif:sendnotif("Normal Zoom")
        LocalPlayer.CameraMaxZoomDistance = 128
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
    end,
})

PlayerTab:CreateButton({
    Name = "Inf Zoom",
    Callback = function()
        Notif:SendNotif("Inf Zoom")
        LocalPlayer.CameraMaxZoomDistance = math.huge
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
    end,
})

-- Utility Tab (Renamed from 'utility' to avoid nil error)
local UtilityTab = Window:CreateTab("Utility", nil) -- Correctly define UtilityTab

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
    PlaceholderText = "-> Enter Name <-",
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

UtilityTab:CreateInput({
    Name = "Quality",
    CurrentValue = "",
    PlaceholderText = "-> Pick 1-10 <-",
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

UtilityTab:CreateButton({
    Name = "Esp on",
    Callback = function()
        Notif:sendnotif("Esp On")
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/Esp.lua"))()
    end,
})

UtilityTab:CreateButton({
    Name = "Esp off",
    Callback = function()
        Notif:sendnotif("Esp Off")
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/Remove.lua"))()
    end,
})

--[[ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt, player)
    if instantInteractEnabled then
        fireproximityprompt(prompt)
    end
end)

UtilityTab:CreateToggle({
    Name = "Instant Interact",
    CurrentValue = false,
    Flag = "Interact",
    Callback = function(Value)
        instantInteractEnabled = Value
    end,
})]]

local function disablePrompts()
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            obj.Enabled = false
        end
    end

disablePromptConnection = game.DescendantAdded:Connect(function(child)
        if child:IsA("ProximityPrompt") then
            child.Enabled = false
        end
    end)
end

local function enablePrompts()
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            obj.Enabled = true
        end
    end

    if disablePromptConnection then
        disablePromptConnection:Disconnect()
        disablePromptConnection = nil
    end
end

UtilityTab:CreateToggle({
    Name = "Disable interact",
    CurrentValue = true,
    Flag = "interact2",
    Callback = function(toggled)
        if toggled then
            disablePrompts()
        else
            enablePrompts()
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

--[[UtilityTab:CreateButton({
    Name = "Rejoin",
    Callback = function()
        local function Rj(R)
            if R == "Yes" then
                task.wait(0.5)
                if LocalPlayer then
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end
            elseif R == "No" then
            end
        end

        local rejoin = Instance.new("BindableFunction")
        rejoin.OnInvoke = Rj

        game.StarterGui:SetCore("SendNotification", {
            Title = "Rejoin?",
            Text = "⚠️",
            Duration = 5,
            Button1 = "Yes",
            Button2 = "No",
            Callback = rejoin,
        })
    end,
})

UtilityTab:CreateButton({
    Name = "Server hop",
    Callback = function()
        local function Shop(Hop)
            if Hop == "Yes" then
                task.wait(0.5)
             local Http = game:GetService("HttpService")
local TPS = game:GetService("TeleportService")
local Api = "https://games.roblox.com/v1/games/"
local _place = game.PlaceId
local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
function ListServers(cursor)
  local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
  return Http:JSONDecode(Raw)
end

local Server, Next; repeat
  local Servers = ListServers(Next)
  Server = Servers.data[1]
  Next = Servers.nextPageCursor
until Server

TPS:TeleportToPlaceInstance(_place,Server.id,game.Players.LocalPlayer)
            elseif Hop == "No" then
            end
        end

        local SHop = Instance.new("BindableFunction")
        SHop.OnInvoke = Shop

        game.StarterGui:SetCore("SendNotification", {
            Title = "Server hop",
            Text = "⚠️",
            Duration = 5,
            Button1 = "Yes",
            Button2 = "No",
            Callback = SHop,
        })
    end,
})]]

UtilityTab:CreateButton({
    Name = "Leave",
    Callback = function()
        Notif:sendnotif("Leave")
        local function Shut(L)
            if L == "Yes" then
                task.wait(1.5)
                game:Shutdown()
            elseif L == "No" then
            end
        end

        local Down = Instance.new("BindableFunction")
        Down.OnInvoke = Shut

        game.StarterGui:SetCore("SendNotification", {
            Title = "Leave?",
            Text = "⚠️",
            Duration = 5,
            Button1 = "Yes",
            Button2 = "No",
            Callback = Down,
        })
    end,
})

if game.PlaceId == GrowGame then
    local GrowTab = Window:CreateTab("Grow a Garden (W.I.P)", nil)
    
    GrowTab:CreateButton({
        Name = "Gear Ui",
        Callback = function()
            Notif:sendnotif("Gear Ui")
            _G.toggleGear = _G.toggleGear or false

            local shop = playerGui.Gear_Shop

            if _G.toggleGear then
                shop.Enabled = false
                shop.IgnoreGuiInset = false
                _G.toggleGear = false
            else
                shop.Enabled = true
                shop.IgnoreGuiInset = true
                _G.toggleGear = true
            end
        end,
    })

    GrowTab:CreateButton({
        Name = "Seed Ui",
        Callback = function()
            Notif:sendnotif("Seed Ui")
            _G.toggleSeed = _G.toggleSeed or false

            local shop = playerGui.Seed_Shop

            if _G.toggleSeed then
                shop.Enabled = false
                shop.IgnoreGuiInset = false
                _G.toggleSeed = false
            else
                shop.Enabled = true
                shop.IgnoreGuiInset = true
                _G.toggleSeed = true
            end
        end,
    })

    GrowTab:CreateButton({
        Name = "Cosmetic Ui",
        Callback = function()
            Notif:sendnotif("Cosmetic Ui")
            _G.toggleCosmetic = _G.toggleCosmetic or false

            local shop = playerGui.CosmeticShop_UI

            if _G.toggleCosmetic then
                shop.Enabled = false
                shop.IgnoreGuiInset = false
                _G.toggleCosmetic = false
            else
                shop.Enabled = true
                shop.IgnoreGuiInset = true
                _G.toggleCosmetic = true
            end
        end,
    })
end

local Scripts = Window:CreateTab("Scripts", nil)

Scripts:CreateButton({
    Name = "Nameless Admin",
    Callback = function()
        Notif:sendnotif("Nameless Admin")
        local function CallNa(NA)
            if NA == "Yes" then
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/NA%20testing.lua"))()
            elseif NA == "No" then
            end
        end

        local SayNa = Instance.new("BindableFunction")
        SayNa.OnInvoke = CallNa

        game.StarterGui:SetCore("SendNotification", {
            Title = "EXECUTE",
            Text = "Nameless-Admin?",
            Duration = 5,
            Button1 = "Yes",
            Button2 = "No",
            Callback = SayNa
        })
    end,
})

Scripts:CreateButton({
    Name = "Native",
    Callback = function()
        Notif:sendnotif("Native loader")
        local function CallNate(Nate)
            if Nate == "Yes" then
                (loadstring or load)(game:HttpGet("https://getnative.cc/script/loader"))()  
            elseif Nate == "No" then
            end
        end

        local SayNate = Instance.new("BindableFunction")
        SayNate.OnInvoke = CallNate

        game.StarterGui:SetCore("SendNotification", {
            Title = "EXECUTE",
            Text = "Native?",
            Duration = 5,
            Button1 = "Yes",
            Button2 = "No",
            Callback = SayNate
        })
    end,
})

Scripts:CreateButton({
    Name = "No-lag",
    Callback = function()
        Notif:sendnotif("No-Lag")
        local function CallLag(Lag)
            if Lag == "Yes" then
                loadstring(game:HttpGet("https://rawscripts.net/raw/Grow-a-Garden-NoLag-Hub-no-key-38699"))()  
            elseif Lag == "No" then
            end
        end

        local SayLag = Instance.new("BindableFunction")
        SayLag.OnInvoke = CallLag

        game.StarterGui:SetCore("SendNotification", {
            Title = "EXECUTE",
            Text = "No-lag?",
            Duration = 5,
            Button1 = "Yes",
            Button2 = "No",
            Callback = SayLag
        })
    end,
})

Scripts:CreateButton({
    Name = "SpeedX",
    Callback = function()
        Notif:sendnotif("SpeedX hub")
        local function CallSpeed(Speed)
            if Speed == "Yes" then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
            elseif Speed == "No" then
            end
        end

        local SaySpeed = Instance.new("BindableFunction")
        SaySpeed.OnInvoke = CallSpeed

        game.StarterGui:SetCore("SendNotification", {
            Title = "EXECUTE",
            Text = "SpeedX?",
            Duration = 5,
            Button1 = "Yes",
            Button2 = "No",
            Callback = SaySpeed
        })
    end,
})

--GUI Tab
local GuiTab = Window:CreateTab("Gui", nil)

GuiTab:CreateButton({
    Name = "⌨️keyboard",
    Callback = function()
        Notif:sendnotif("keyboard")
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/Keyboard.lua"))()
    end,
})

GuiTab:CreateButton({
    Name = "📒Notepad",
    Callback = function()
        Notif:sendnotif("Notepad")
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/notepad.lua"))()
    end,
})

GuiTab:CreateButton({
    Name = "Universal Viewer",
    Callback = function()
        Notif:sendnotif("Universal Viewer")
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/Universe%20Viewer.lua"))()
    end,
})

GuiTab:CreateButton({
    Name = "👀Simple Spy",
    Callback = function()
        Notif:sendnotif("Simple Spy")
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/SimpleSpy.lua"))()
    end,
})

GuiTab:CreateButton({
    Name = "🗂️Dex v3",
    Callback = function()
        Notif:sendnotif("Dex v3")
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/DexMobile.lua"))()
    end,
})

GuiTab:CreateButton({
    Name = "🔒ShiftLock",
    Callback = function()
        Notif:sendnotif("ShiftLock")
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/ShiftLock.lua"))()
    end,
})

--[[GuiTab:CreateButton({
    Name = "Executor",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kuro5222/Kuro/main/executor.lua"))()
    end,
})]]

GuiTab:CreateButton({
    Name = "⚠️SICRET SCREPT⚠️",
    Callback = function()
        Notif:sendnotif("⚠️SICRET⚠️")
        local function Lol(Secret)
            if Secret == "YUH UH" then
                for i = 5, 1, -1 do
                    StarterGui:SetCore("SendNotification", {
                        Title = tostring(i),
                        Text = "⚠️⚠️⚠️",
                        Duration = 1
                    })
                    task.wait(1)
                end

                StarterGui:SetCore("SendNotification", {
                    Title = "It's a prank",
                    Text = "Nothing happened, but why did you pick YUH UH?🤨",
                    Duration = 3
                })
                task.wait(60)
                loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/Crashed.lua"))()
                task.wait(1)
                game.Players.LocalPlayer:Kick("Perm ban (Reason: Hacking)")

                task.wait(1.5)
                while true do end
            elseif Secret == "NAH UH" then
                task.wait(60)
                loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/Crashed.lua"))()
                task.wait(1)
                game:Shutdown()
            end
        end

        local Dumb = Instance.new("BindableFunction")
        Dumb.OnInvoke = Lol

        game.StarterGui:SetCore("SendNotification", {
            Title = "DUDE WHY DID YOU CLICK IT?🤨📸📸",
            Text = "⚠️still wanna continue?⚠️",
            Duration = 5,
            Button1 = "YUH UH",
            Button2 = "NAH UH",
            Callback = Dumb,
        })
    end,
})

local Message = Window:CreateTab("Send a message", nil)

local webhookMessage = ""
local cooldownTime = 5
local isOnCooldown = false

Message:CreateInput({
    Name = "Say something",
    CurrentValue = "",
    PlaceholderText = "-> Send me a message honey😏 <-",
    RemoveTextAfterFocusLost = false,
    Flag = "Chat",
    Callback = function(message)
        webhookMessage = message
    end,
})

local send = Message:CreateButton({
    Name = "Send",
    Callback = function()
        if isOnCooldown then
            return
        end

        isOnCooldown = true

        local productInfo = MarketplaceService:GetProductInfo(game.PlaceId)
        local gameName = productInfo.Name

        local timeNow = os.time()
        local timeFormatted = os.date("!*t", timeNow)
        local timestamp = string.format(
            "%d-%02d-%02dT%02d:%02d:%02dZ",
            timeFormatted.year,
            timeFormatted.month,
            timeFormatted.day,
            timeFormatted.hour,
            timeFormatted.min,
            timeFormatted.sec
        )

        local content = ""

        local embed = {
            title = LocalPlayer.DisplayName .. " said " .. webhookMessage,
            color = 11546102,
            footer = { text = "" },
            author = {
                name = "Message"
            },
            fields = {
                {
                    name = "Said While in | " .. gameName,
                    value = game.JobId
                }
            },
            timestamp = timestamp
        }

        local webhookUrl = "https://discord.com/api/webhooks/1381312522858270720/BwYnfcLuMi0rsW5xrgHbEzAZ0oEcyMUZ7YWKdGk5j_prrK5Foxz2TTQrxQeAnkeku9oZ"

        local requestFunc = http_request
        requestFunc {
            Url = webhookUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode({
                content = content,
                embeds = { embed }
            })
        }
        
        delay(cooldownTime, function()
            isOnCooldown = false
        end)
    end,
})