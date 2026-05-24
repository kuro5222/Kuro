local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local LocalPlayer = Players.LocalPlayer
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
playerGui.ScreenOrientation = Enum.ScreenOrientation.LandscapeSensor

local GrowGame = 126884695634066

local hour = tonumber(os.date("%H"))
local Good = ""
if hour >= 6 and hour < 12 then
    Good = "🌸Ohayou gozaimasu, ojou-sama🌸"
elseif hour >= 12 and hour < 18 then
    Good = "☀️Konnichiwa, ojou-sama☀️"
elseif hour >= 18 and hour < 22 then
    Good = "🌙Konbanwa, ojou-sama🌙"
else
    Good = "🌌Oyasumi nasai, ojou-sama🌌"
end

local Lighting = game:GetService("Lighting")

local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 0
TweenService:Create(blur, TweenInfo.new(0.5), {Size = 24}):Play()

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "StellarLoader"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundTransparency = 1

local bg = Instance.new("Frame", frame)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
bg.BackgroundTransparency = 1
bg.ZIndex = 0
TweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 0.3}):Play()

local word = "Kuro | WindUi"
local letters = {}

local function tweenOutAndDestroy()
	for _, label in ipairs(letters) do
		TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 1, TextSize = 20}):Play()
	end
	TweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
	TweenService:Create(blur, TweenInfo.new(0.5), {Size = 0}):Play()
	wait(0.6)
	screenGui:Destroy()
	blur:Destroy()
end

for i = 1, #word do
	local char = word:sub(i, i)

	local label = Instance.new("TextLabel")
	label.Text = char
	label.Font = Enum.Font.GothamBlack
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 1 
	label.TextTransparency = 1
	label.TextScaled = false
	label.TextSize = 30 
	label.Size = UDim2.new(0, 60, 0, 60)
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Position = UDim2.new(0.5, (i - (#word / 2 + 0.5)) * 65, 0.5, 0)
	label.BackgroundTransparency = 1
	label.Parent = frame

	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 170, 255)), -- biru muda cerah
		ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 100, 160))   -- biru muda gelap
	})
	gradient.Rotation = 90
	gradient.Parent = label

	local tweenIn = TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 0, TextSize = 60})
	tweenIn:Play()

	table.insert(letters, label)
	wait(0.25)
end

wait(2)

tweenOutAndDestroy()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local function Notify(title, context, duration)
    WindUI:Notify({
        Title = title,
        Content = context,
        Icon = "info",
        Duration = duration,
    })
end

local Window = WindUI:CreateWindow({
    Title = "KuroWindUi",
    Icon = "rbxassetid://129260712070622",
    IconThemed = true,
    Author = Good,
    Folder = "KuroWindUi",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
    User = {
        Enabled = true,
        Anonymous = false
    },
    SideBarWidth = 200,
    ScrollBarEnabled = true,
})

local StatusSection = Window:Tab({
    Title = "Server",
    Opened = true,
})

local JID = nil

StatusSection:Input({
    Title = "Join Jobid",
    Desc = nil,
    Value = nil,
    InputIcon = "bird",
    Type = "Input", -- or "Textarea"
    Placeholder = "Input Jobid...",
    Callback = function(JobId)
        JID = JobId
    end,
})

StatusSection:Button({
    Title = "Join Id",
    Callback = function()
        if not JID or JID == "" then
            warn("No JobId | Input JobId first")
            return
        end
        local placeId = game.PlaceId
        local targetJobId = JID
        TeleportService:TeleportToPlaceInstance(placeId, targetJobId, LocalPlayer)
    end,
})

local LTT = StatusSection:Paragraph({
    Title = "Local Time: --:--:--",
    Desc = "",
    Flag = "LocalTime",
})

local UTT = StatusSection:Paragraph({
    Title = "Utc Time : --:--:--",
    Desc = "World Time",
    Flag = "UtcTime",
})

local PlayerCount = StatusSection:Paragraph({
    Title = "Players: --",
    Desc = "Players in the server",
    Flag = "PlayerCount",
})

local CJobId = StatusSection:Paragraph({
    Title = "Current JobId: --",
    Desc = "",
    Flag = "JobId",
})

local CopyJob = StatusSection:Button({
    Title = "Copy JobId",
    Callback = function()
        if setclipboard then
            setclipboard(game.JobId)
            Notify("Copied JobId", tostring(game.JobId), 2)
            CopyJob:SetTitle("Copied")
            wait(1)
            CopyJob:SetTitle("Copy JobId")
        else
            Notify("Error", "Cannot copy", 2)
            warn("setclipboard not supported")
        end
    end,
})

task.spawn(function()
    while task.wait(0.5) do
        local localTime = os.date("%I:%M:%S %p")
        local utcTime = os.date("!%I:%M:%S %p")
        LTT:SetTitle("Local Time | " .. localTime)
        UTT:SetTitle("Utc Time | " .. utcTime)
    end
end)

local function updatePlayerCount()
    local count = #Players:GetPlayers()
    PlayerCount:SetTitle("Players in server | " .. count)
end
Players.PlayerAdded:Connect(updatePlayerCount)
Players.PlayerRemoving:Connect(updatePlayerCount)
updatePlayerCount()

task.spawn(function()
    while task.wait(1) do
        CJobId:SetTitle("Current JobId | " .. tostring(game.JobId))
    end
end)

local UStuff = Window:Section({
    Title = "Player",
    Icon = nil,
    Opened = false,
})

local PlayerTab = UStuff:Tab({
    Title = "Character",
    Opened = false,
})

local WalkS = PlayerTab:Slider({
    Title = "WalkSpeed",
    Step = 1,
    Value = {
        Min = 0,
        Max = 100,
        Default = 16,
    },
    Callback = function(value)
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = value
            end
        end
    end,
})

local JumpP = PlayerTab:Slider({
    Title = "Jumppower",
    Step = 1,
    Value = {
        Min = 0,
        Max = 150,
        Default = 50,
    },
    Callback = function(value)
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = value
            end
        end
    end,
})

PlayerTab:Button({
    Title = "Reset Speed",
    Callback = function()
        WalkS:Set(16)
    end,
})

PlayerTab:Button({
    Title = "Reset Jump",
    Callback = function()
        JumpP:Set(50)
    end,
})

PlayerTab:Button({
    Title = "Reset",
    Callback = function()
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Dead)
        end
    end,
})

local CamTab = UStuff:Tab({
    Title = "Camera",
    Opened = false,
})

CamTab:Toggle({
    Title = "Cam Noclip",
    Value = false,
    Callback = function(state)
        if state then
            Players.LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
        else
            Players.LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
        end
    end,
})

CamTab:Button({
    Title = "Cam NoClip",
    Callback = function()
        local player = Players.LocalPlayer
        local camera = workspace.CurrentCamera

        local SetConstant = (debug and debug.setconstant) or setconstant
        local GetConstants = (debug and debug.getconstants) or getconstants
        local HasAdvancedAccess = (getgc and SetConstant and GetConstants)

        if HasAdvancedAccess then
            local PlayerModule = player:FindFirstChild("PlayerScripts") and player.PlayerScripts:FindFirstChild("PlayerModule")
            local Popper = PlayerModule 
                and PlayerModule:FindFirstChild("CameraModule") 
                and PlayerModule.CameraModule:FindFirstChild("ZoomController") 
                and PlayerModule.CameraModule.ZoomController:FindFirstChild("Popper")

            if Popper then
                for i, v in pairs(getgc()) do
                    if type(v) == "function" and getfenv(v).script == Popper then
                        for i2, v2 in pairs(GetConstants(v)) do
                            if tonumber(v2) == 0.25 then
                                SetConstant(v, i2, 0)
                            elseif tonumber(v2) == 0 then
                                SetConstant(v, i2, 0.25)
                            end
                        end
                    end
                end
            end
        else
            Players.LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
        end
    end,
})

CamTab:Button({
    Title = "First Person🧑",
    Callback = function()
        LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
    end,
})

CamTab:Button({
    Title = "Normal Zoom",
    Callback = function()
        LocalPlayer.CameraMaxZoomDistance = 128
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
    end,
})

CamTab:Button({
    Title = "Inf Zoom",
    Callback = function()
        LocalPlayer.CameraMaxZoomDistance = math.huge
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
    end,
})

PlayerTab:Button({
    Title = "Outline Players",
    Callback = function()
        local function applyHighlight(player)
            local function onCharacterAdded(character)
                local highlight = Instance.new("Highlight")
                highlight.Parent = character
                highlight.Archivable = true
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Enabled = true
                highlight.FillColor = Color3.fromRGB(128, 128, 128)
                highlight.OutlineColor = Color3.fromRGB(100, 100, 100)
                highlight.FillTransparency = 1
                highlight.OutlineTransparency = 1
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
    end,
})

local UtilityTab = UStuff:Tab({
    Title = "Utilities",
    Opened = false,
})

local function getBp()
    return LocalPlayer:WaitForChild("Backpack")
end

UtilityTab:Button({
    Title = "Equip all",
    Callback = function()
        local backpack = getBp()
        if backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.Parent = character
                end
            end
        end
    end,
})

local function getChar()
    return Players.LocalPlayer.Character
end

local isFrozen = false

local function toggleFreeze(value)
    local char = getChar()
    if not char then return end

    isFrozen = value
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Anchored = isFrozen
        end
    end
end

local char = getChar()
if char then
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Anchored = isFrozen
        end
    end
end

UtilityTab:Toggle({
    Title = "Freeze",
    Value = false,
    Callback = function(value)
        toggleFreeze(value)
    end,
})

Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
    for _, part in ipairs(newChar:GetChildren()) do
        if part:IsA("BasePart") then
            part.Anchored = isFrozen
        end
    end
end)

UtilityTab:Button({
    Title = "Sit",
    Callback = function()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Sit = true
    end
end,
})

UtilityTab:Button({
    Title = "Lay?",
    Callback = function()
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")
if not humanoid then return end

humanoid.Sit = true
wait(0.1)

local rootPart = character:FindFirstChild("HumanoidRootPart")
if rootPart then
    rootPart.CFrame = rootPart.CFrame * CFrame.Angles(math.pi * 0.5, 0, 0)
end

for _, animTrack in ipairs(humanoid:GetPlayingAnimationTracks()) do
    animTrack:Stop()
end
end,
})

UtilityTab:Toggle({
    Title = "Night",
    Value = false,
    Callback = function(On)
        if On then
            local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
            local tween = TweenService:Create(Lighting, tweenInfo, {ClockTime = 0})
            tween:Play()
        else
            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
            local tween = TweenService:Create(Lighting, tweenInfo, {ClockTime = 6.2})
            tween:Play()
        end
    end
})

local infiniteJumpEnabled = false

UtilityTab:Toggle({
    Title = "Infinite Jump",
    Desc = "Enables infinite jumping.",
    Value = false,
    Callback = function(state)
        infiniteJumpEnabled = state
    end,
})

UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local noclipEnabled = false

local function setNoclip(state)
    local character = LocalPlayer.Character
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end
    end
end

local noclipConnection
noclipConnection = RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        setNoclip(true)
    end
end)

UtilityTab:Toggle({
    Title = "Noclip",
    Value = false,
    Callback = function(state)
        noclipEnabled = state
        if not noclipEnabled then
            setNoclip(false)
        end
    end,
})

UtilityTab:Button({
    Title = "Rejoin",
    Callback = function()
        local placeId = game.PlaceId
        local jobId = game.JobId
        local success, result = pcall(function()
            return TeleportService:TeleportAsync(placeId, { Players.LocalPlayer }, { jobId = jobId })
        end)
        if not success then
            Notify("Rejoin failed: ", "Failed to rejoin" .. tostring(result), 2.5)
        end
    end
})

UtilityTab:Button({
    Title = "Leave Game",
    Callback = function()
        WindUI:Popup({
            Title = "Leave?",
            Icon = "info",
            Content = "Don't leave Daddy ugh!",
            Buttons = {
                {
                    Title = "Cancel",
                    Callback = function() end,
                    Variant = "Tertiary",
                },
                {
                    Title = "Continue",
                    Icon = "arrow-right",
                    Callback = function()
                        game:Shutdown()
                    end,
                }
            }
        })
    end,
})

if game.PlaceId == GrowGame then
    local autoBuyEggs = false
    local autoBuySeeds = false
    local autoBuyGears = false

    local GrowSection = Window:Section({
        Title = "Grow a Garden",
        Opened = false,
    })
    
    local GrowShopTab = GrowSection:Tab({
        Title = "Shop",
        Opened = false,
    })
    
    local GrowGuiTab = GrowSection:Tab({
        Title = "Gui",
        Opened = false,
    })
    
    local GrowOtherTab = GrowSection:Tab({
        Title = "Others",
        Opened = false,
    })

    GrowShopTab:Toggle({
        Title = "Buy Eggs(Best)",
        Value = true,
        Callback = function(state)
            autoBuyEggs = state
            task.spawn(function()
                while autoBuyEggs do
                    for _, name in ipairs({
                        "Bug Egg", "Paradise Egg", "Mythical Egg", "Rare Summer Egg"
                    }) do
                        ReplicatedStorage.GameEvents.BuyPetEgg:FireServer(name)
                    end
                    task.wait(0.1)
                end
            end)
        end,
    })

    GrowShopTab:Toggle({
        Title = "Buy Seeds(Best)",
        Value = true,
        Callback = function(state)
            autoBuySeeds = state
            task.spawn(function()
                while autoBuySeeds do
                    for _, name in ipairs({
                        "Carrot", "Blueberry", "Strawberry", "Tomato", "Corn", "Watermelon", "Pumpkin", "Apple", "Bamboo",
                        "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom",
                        "Pepper", "Cacao", "Ember Lily", "Sugar Apple", "Beanstalk", "Burning bud", "Giant Pinecone"
                    }) do
                        ReplicatedStorage.GameEvents.BuySeedStock:FireServer(name)
                    end
                    task.wait(0.1)
                end
            end)
        end,
    })

    GrowShopTab:Toggle({
        Title = "Buy Gears(Best)",
        Value = true,
        Callback = function(state)
            autoBuyGears = state
            task.spawn(function()
                while autoBuyGears do
                    for _, name in ipairs({
                        "Watering Can", "Basic Sprinkler",
                        "Advanced Sprinkler", "Godly Sprinkler", "Lightning Rod",
                        "Master Sprinkler", "Levelup Lollipop", "Tanning Mirror", "Medium Toy", "Medium Treat"
                    }) do
                        ReplicatedStorage.GameEvents.BuyGearStock:FireServer(name)
                    end
                    task.wait(0.1)
                end
            end)
        end,
    })

    GrowGuiTab:Toggle({
        Title = "Seed Shop",
        Value = false,
        Callback = function(state)
            local shop = playerGui:FindFirstChild("Seed_Shop")
            if shop then
                shop.Enabled = state
            end
        end,
    })

    GrowGuiTab:Toggle({
        Title = "Gear Shop",
        Value = false,
        Callback = function(state)
            local shop = playerGui:FindFirstChild("Gear_Shop")
            if shop then
                shop.Enabled = state
            end
        end,
    })

    GrowGuiTab:Button({
        Title = "Cosmetics Shop",
        Callback = function()
            if playerGui:FindFirstChild("CosmeticShop_UI") then
                playerGui.CosmeticShop_UI.Enabled = true
                playerGui.CosmeticShop_UI.IgnoreGuiInset = true
            end
        end,
    })
    
local GrowText = ""

GrowOtherTab:Input({
    Title = "Grow a garden notif",
    Desc = "Just for fun",
    Value = nil,
    Placeholder = "Input what you want to say",
    Callback = function(Text)
        GrowText = Text
    end,
})

local RS = game:GetService("ReplicatedStorage")
local notification = RS:WaitForChild("GameEvents"):WaitForChild("Notification")

local repeatConnection = nil

GrowOtherTab:Button({
    Title = "Notify",
    Callback = function()
        if GrowText ~= "" and GrowText ~= nil then
            local connection
            connection = notification.OnClientEvent:Connect(function(...)
                connection:Disconnect()
            end)
            
            for _, v in pairs(getconnections(notification.OnClientEvent)) do
                v.Function(GrowText)
            end
        end
    end,
})

GrowOtherTab:Toggle({
    Title = "Repeat Notify",
    Value = false,
    Callback = function(State)
        if State then
            repeatConnection = game:GetService("RunService").Heartbeat:Connect(function()
                wait(0.5) -- Wait 5 seconds between notifications
                
                if GrowText ~= "" then
                    local connection
                    connection = notification.OnClientEvent:Connect(function(...)
                        connection:Disconnect()
                    end)
                    
                    for _, v in pairs(getconnections(notification.OnClientEvent)) do
                        v.Function(GrowText)
                    end
                end
            end)
        else
            if repeatConnection then
                repeatConnection:Disconnect()
                repeatConnection = nil
            end
        end
    end,
})
    
    -- Auto Plant functionality
    local function getTool()
        return LocalPlayer.Character:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
    end

    local function firePlantEvent()
        local tool = getTool()
        if not tool then
            return false
        end
        if not tool:GetAttribute("Seed") then
            return false
        end
        local game_events = ReplicatedStorage:WaitForChild("GameEvents", 5)
        if not game_events then
            return false
        end
        local plant_re = game_events:WaitForChild("Plant_RE", 5)
        if not plant_re then
            return false
        end
        plant_re:FireServer(LocalPlayer.Character:GetPivot().Position, tool:GetAttribute("Seed"))
        return true
    end

    local isAutoPlanting = false
    local connection

    GrowOtherTab:Toggle({
        Title = "Auto Plant",
        Value = false,
        Callback = function(state)
            isAutoPlanting = state
            if isAutoPlanting then
                -- Start the auto-plant loop
                connection = RunService.Heartbeat:Connect(function()
                    if isAutoPlanting and LocalPlayer.Character and LocalPlayer.Character.Humanoid and LocalPlayer.Character.Humanoid.Health > 0 then
                        local tool = getTool()
                        if tool and tool:GetAttribute("Seed") then
                            if not firePlantEvent() then
                                isAutoPlanting = false
                                GrowOtherTab:Find("Auto Plant"):Set(false) -- Update toggle state
                            end
                        else
                            isAutoPlanting = false
                            GrowOtherTab:Find("Auto Plant"):Set(false) -- Update toggle state
                        end
                    else
                        isAutoPlanting = false
                        if connection then
                            connection:Disconnect()
                            connection = nil
                        end
                        GrowOtherTab:Find("Auto Plant"):Set(false) -- Update toggle state
                    end
                end)
            else
                -- Stop the auto-plant loop
                if connection then
                    connection:Disconnect()
                    connection = nil
                end
            end
        end,
    })
end