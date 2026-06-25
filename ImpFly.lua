--[[
    Improved Fly GUI – v2.0
    No dependencies, self-contained.
]]

local function createFlyGUI()
    -- Services
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local StarterGui = game:GetService("StarterGui")
    local Workspace = game:GetService("Workspace")

    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    -- GUI elements
    local gui = Instance.new("ScreenGui")
    gui.Name = "FlyGUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 220, 0, 130)
    frame.Position = UDim2.new(0.5, -110, 0.5, -65)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = gui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 80, 90)
    stroke.Thickness = 1.5
    stroke.Parent = frame

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 25)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "✈ Fly"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    -- Toggle button
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 80, 0, 30)
    toggleBtn.Position = UDim2.new(1, -90, 0, 5)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextScaled = true
    toggleBtn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = toggleBtn

    -- Speed controls
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 50, 0, 30)
    speedLabel.Position = UDim2.new(0.5, -25, 0.4, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "50"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextScaled = true
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.Parent = frame

    local speedDec = Instance.new("TextButton")
    speedDec.Size = UDim2.new(0, 30, 0, 30)
    speedDec.Position = UDim2.new(0.5, -60, 0.4, 0)
    speedDec.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    speedDec.Text = "−"
    speedDec.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedDec.Font = Enum.Font.GothamBold
    speedDec.TextScaled = true
    speedDec.Parent = frame
    Instance.new("UICorner").CornerRadius = UDim.new(0, 6); speedDec:AddTag("UICorner")

    local speedInc = Instance.new("TextButton")
    speedInc.Size = UDim2.new(0, 30, 0, 30)
    speedInc.Position = UDim2.new(0.5, +30, 0.4, 0)
    speedInc.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    speedInc.Text = "+"
    speedInc.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedInc.Font = Enum.Font.GothamBold
    speedInc.TextScaled = true
    speedInc.Parent = frame
    Instance.new("UICorner").CornerRadius = UDim.new(0, 6); speedInc:AddTag("UICorner")

    -- Up / Down buttons (vertical)
    local upBtn = Instance.new("TextButton")
    upBtn.Size = UDim2.new(0, 60, 0, 30)
    upBtn.Position = UDim2.new(0.1, 0, 0.75, 0)
    upBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    upBtn.Text = "▲"
    upBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    upBtn.Font = Enum.Font.GothamBold
    upBtn.TextScaled = true
    upBtn.Parent = frame
    Instance.new("UICorner").CornerRadius = UDim.new(0, 6); upBtn:AddTag("UICorner")

    local downBtn = Instance.new("TextButton")
    downBtn.Size = UDim2.new(0, 60, 0, 30)
    downBtn.Position = UDim2.new(0.5, -30, 0.75, 0)
    downBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    downBtn.Text = "▼"
    downBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    downBtn.Font = Enum.Font.GothamBold
    downBtn.TextScaled = true
    downBtn.Parent = frame
    Instance.new("UICorner").CornerRadius = UDim.new(0, 6); downBtn:AddTag("UICorner")

    -- Close / Minimize
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -30, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextScaled = true
    closeBtn.Parent = frame
    Instance.new("UICorner").CornerRadius = UDim.new(0, 6); closeBtn:AddTag("UICorner")

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 25, 0, 25)
    minBtn.Position = UDim2.new(1, -57, 0, 5)
    minBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    minBtn.Text = "−"
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextScaled = true
    minBtn.Parent = frame
    Instance.new("UICorner").CornerRadius = UDim.new(0, 6); minBtn:AddTag("UICorner")

    -- State
    local isFlying = false
    local speed = 50
    local minSpeed = 1
    local maxSpeed = 100
    local flyThread = nil
    local connections = {}

    -- Vertical movement while buttons held
    local upConn, downConn
    local function startVertical(direction)
        if not isFlying then return end
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local bv = root:FindFirstChild("FlyBodyVelocity")
        if bv then
            bv.Velocity = bv.Velocity + Vector3.new(0, direction * 10, 0)
        end
    end

    upBtn.MouseButton1Down:Connect(function()
        upConn = RunService.Heartbeat:Connect(function()
            startVertical(1)
        end)
    end)
    upBtn.MouseButton1Up:Connect(function()
        if upConn then upConn:Disconnect(); upConn = nil end
    end)
    downBtn.MouseButton1Down:Connect(function()
        downConn = RunService.Heartbeat:Connect(function()
            startVertical(-1)
        end)
    end)
    downBtn.MouseButton1Up:Connect(function()
        if downConn then downConn:Disconnect(); downConn = nil end
    end)

    -- Speed buttons
    speedDec.MouseButton1Click:Connect(function()
        speed = math.max(minSpeed, speed - 5)
        speedLabel.Text = tostring(speed)
    end)
    speedInc.MouseButton1Click:Connect(function()
        speed = math.min(maxSpeed, speed + 5)
        speedLabel.Text = tostring(speed)
    end)

    -- Toggle flight
    local function setFlying(state)
        isFlying = state
        if state then
            toggleBtn.Text = "ON"
            toggleBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
            toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
        else
            toggleBtn.Text = "OFF"
            toggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
            toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        end
    end

    local function cleanupFly()
        if flyThread then
            flyThread:Disconnect()
            flyThread = nil
        end
        local char = LocalPlayer.Character
        if char then
            local bv = char:FindFirstChild("FlyBodyVelocity")
            if bv then bv:Destroy() end
            local bg = char:FindFirstChild("FlyBodyGyro")
            if bg then bg:Destroy() end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.PlatformStand = false
                -- Re‑enable all states
                for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
                    hum:SetStateEnabled(state, true)
                end
                hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
            end
            local anim = char:FindFirstChild("Animate")
            if anim then anim.Disabled = false end
        end
        setFlying(false)
    end

    local function startFly()
        cleanupFly() -- ensure clean start
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        -- Disable all humanoid states to prevent interference
        for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
            hum:SetStateEnabled(state, false)
        end
        hum:ChangeState(Enum.HumanoidStateType.Swimming) -- forces flying
        hum.PlatformStand = true

        -- Disable animations
        local anim = char:FindFirstChild("Animate")
        if anim then anim.Disabled = true end

        -- BodyVelocity for movement
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyBodyVelocity"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = root

        -- BodyGyro for orientation
        local bg = Instance.new("BodyGyro")
        bg.Name = "FlyBodyGyro"
        bg.P = 9e4
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = root.CFrame
        bg.Parent = root

        setFlying(true)

        -- Main flight loop
        local function updateFly()
            if not isFlying or not char or not root or not hum then
                cleanupFly()
                return
            end
            local camera = Workspace.CurrentCamera
            if not camera then return end

            -- Get movement input
            local move = Vector3.new(
                (UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
                (UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 1 or 0),
                (UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
            )

            if move.Magnitude > 0 then
                move = move.Unit * speed
                local velocity = camera.CFrame:VectorToWorldSpace(move)
                bv.Velocity = velocity
            else
                -- If no input, slow down slightly (or stop)
                bv.Velocity = bv.Velocity * 0.9
                if bv.Velocity.Magnitude < 0.1 then
                    bv.Velocity = Vector3.new(0, 0, 0)
                end
            end

            -- Keep gyro aligned with camera
            bg.CFrame = camera.CFrame
        end

        flyThread = RunService.Heartbeat:Connect(updateFly)
    end

    toggleBtn.MouseButton1Click:Connect(function()
        if isFlying then
            cleanupFly()
        else
            startFly()
        end
    end)

    -- Close button – full cleanup
    local function destroyGUI()
        cleanupFly()
        if upConn then upConn:Disconnect() end
        if downConn then downConn:Disconnect() end
        for _, conn in ipairs(connections) do conn:Disconnect() end
        gui:Destroy()
    end
    closeBtn.MouseButton1Click:Connect(destroyGUI)

    -- Minimize toggle (hide/show UI)
    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        frame.Visible = not minimized
    end)

    -- Handle respawn: re‑start fly if active
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        task.wait(0.5) -- wait for character to load
        if isFlying then
            cleanupFly()
            startFly()
        end
    end)

    -- Draggable frame
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMove then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Notification
    StarterGui:SetCore("SendNotification", {
        Title = "Fly GUI",
        Text = "Press SPACE to go up, SHIFT to go down.",
        Duration = 3
    })

    return gui
end

-- Expose for external use
return createFlyGUI