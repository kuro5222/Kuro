local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

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
    Title = "KiroWindUi",
    IconThemed = false,
    Author = "Made by Kiro.",
    Folder = "KiroWUi",
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

local PlayerSection = Window:Section({
    Title = "Player",
    Icon = nil,
    Opened = false,
})

local OtherInfo = Window:Tab({
    Title = "More Info",
    Icon = "info",
})

local JID = nil

StatusSection:Input({
    Title = "Join Jobid",
    Desc = nil,
    Value = nil,
    InputIcon = "bird",
    Type = "Input",
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
            task.wait(1)
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

local PlayerTab = PlayerSection:Tab({
    Title = "Character",
    Opened = false,
})

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

Goto = PlayerTab:Input({
  Title = "Goto",
  Placeholder = "Enter Name",
  Flag = "goto",
  Callback = function(inputvalue)
      local targetPlayers = getPlr(inputValue)
        if #targetPlayers == 0 then
            Notify("Player " .. inputValue, "NOT FOUND", 2.5)
            return
        end

        local targetPlayer = targetPlayers[1]
        local targetCharacter = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
        local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")

        local myCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")

        if targetRoot and myRoot then
            myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 5, 0)
            Notify("Teleported to " .. targetPlayer.Name, "SUCCESS", 2.5)
        else
            Notify("Teleport Failed", "Could not find the target or your character parts.", 2.5)
        end
    end,
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
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
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
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
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
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Dead)
        end
    end,
})

PlayerTab:Button({
    Title = "Outline Players",
    Callback = function()
        local function applyHighlight(player)
            local function onCharacterAdded(char)
                local highlight = Instance.new("Highlight")
                highlight.Parent = char
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

local CamTab = PlayerSection:Tab({
    Title = "Camera",
    Opened = false,
})

CamTab:Toggle({
    Title = "Cam Noclip",
    Value = false,
    Callback = function(state)
        if state then
            LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
        else
            LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
        end
    end,
})

CamTab:Button({
    Title = "Cam NoClip",
    Callback = function()
        local SetConstant = (debug and debug.setconstant) or setconstant
        local GetConstants = (debug and debug.getconstants) or getconstants
        local HasAdvancedAccess = (getgc and SetConstant and GetConstants)

        if HasAdvancedAccess then
            local PlayerModule = LocalPlayer:FindFirstChild("PlayerScripts") and LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule")
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
            LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
        end
    end,
})

CamTab:Button({
    Title = "First Person 🧑",
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

local UtilityTab = PlayerSection:Tab({
    Title = "Utilities",
    Opened = false,
})

local function getBp()
    return LocalPlayer:WaitForChild("Backpack")
end

local function getChar()
    return LocalPlayer.Character
end

UtilityTab:Button({
    Title = "Equip all",
    Callback = function()
        local backpack = getBp()
        if backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.Parent = getChar()
                end
            end
        end
    end,
})

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

UtilityTab:Toggle({
    Title = "Freeze",
    Value = false,
    Callback = function(value)
        toggleFreeze(value)
    end,
})

LocalPlayer.CharacterAdded:Connect(function(newChar)
    for _, part in ipairs(newChar:GetChildren()) do
        if part:IsA("BasePart") then
            part.Anchored = isFrozen
        end
    end
end)

UtilityTab:Button({
    Title = "Sit",
    Callback = function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Sit = true
        end
    end,
})

UtilityTab:Button({
    Title = "Lay",
    Callback = function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        humanoid.Sit = true
        task.wait(0.1)

        local rootPart = char:FindFirstChild("HumanoidRootPart")
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
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local noclipEnabled = false

local function setNoclip(state)
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end
    end
end

local noclipConnection = RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        setNoclip(true)
    end
end)

UtilityTab:Toggle({
    Title = "Noclip",
    Value = false,
    Callback = function(state)
        noclipEnabled = state
        if noclipEnabled then
            setNoclip(true)
          else
            setNoclip(false)
        end
    end,
})

UtilityTab:Button({
  Title = "Fly",
  Callback = function()
        WindUI:Popup({
          Title = "Fly Gui",
          Icon = "info",
          Content = "Run fly gui?",
          Buttons = {
            {
              Title = "No",
              Variant = "Tertiary",
            },
            {
              Title = "Yes",
              Callback = function()
                loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kiro-git/Kuro/main/fly%20gui.lua"))()
                end,
            }
          }
        })
    end,
})

UtilityTab:Button({
    Title = "Rejoin",
    Callback = function()
        local placeId = game.PlaceId
        local jobId = game.JobId
        local success, result = pcall(function()
            return TeleportService:TeleportAsync(placeId, { LocalPlayer }, { jobId = jobId })
        end)
        if not success then
            Notify("Rejoin failed:", "Failed to rejoin "
                 .. tostring(result), 2.5)
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

OtherInfo:Paragraph({
  Title = "Paragraph i guess?",
  
})