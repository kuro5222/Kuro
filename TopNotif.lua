--Made by Leadmarker
local TweenService = game:GetService('TweenService')

if not _G.noti_stack then _G.noti_stack = {} end
if not _G.noti_gui then
    local screen_gui = Instance.new('ScreenGui')
    screen_gui.Parent = gethui and gethui() or game:GetService('CoreGui')
    screen_gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    _G.noti_gui = screen_gui
end

local BASE_Y = 0.1
local SPACING = 30

local function refreshPositions()
    for i, v in pairs(_G.noti_stack) do
        local offset = (i - 1) * SPACING
        TweenService:Create(v, TweenInfo.new(.25), {
            Position = UDim2.new(0.5, 0, BASE_Y, -offset)
        }):Play()
    end
end

local function notify(name, time)
    local name, time = name or 'Notify', time or 3

    local label = Instance.new('TextLabel')
    label.AnchorPoint = Vector2.new(0.5, 0)
    label.Parent = _G.noti_gui
    label.BackgroundTransparency = 1.000
    label.BorderSizePixel = 0
    label.Position = UDim2.new(0.5, 0, BASE_Y, 0)
    label.Size = UDim2.new(0, 0, 0, 20)
    label.Font = Enum.Font.Code
    label.Text = name
    label.TextColor3 = Color3.fromRGB(235, 235, 235)
    label.TextSize = 12.000
    label.TextStrokeTransparency = 0.000
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.RichText = true
    label.ClipsDescendants = true

    table.insert(_G.noti_stack, label)

    TweenService:Create(label, TweenInfo.new(.25), {
        Size = UDim2.new(0, label.TextBounds.x + 10, 0, 20)
    }):Play()

    refreshPositions()

    task.delay(time, function()
        local tween = TweenService:Create(label, TweenInfo.new(.25), {
            Size = UDim2.new(0, 0, 0, 20)
        })
        tween:Play()
        tween.Completed:Wait()
        label:Destroy()

        local idx = table.find(_G.noti_stack, label)
        if idx then table.remove(_G.noti_stack, idx) end

        refreshPositions()
    end)
end

return notify
