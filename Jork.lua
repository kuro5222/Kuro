local speaker = game:GetService("Players").localPlayer
function r15(plr)
	if plr.Character:FindFirstChildOfClass('Humanoid').RigType == Enum.HumanoidRigType.R15 then
		return true
	end
end
function lulu()
    local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
    local backpack = speaker:FindFirstChildWhichIsA("Backpack")
    if not humanoid or not backpack then return end

    local tool = Instance.new("Tool")
    tool.Name = "lulu"
    tool.ToolTip = "Ewwwwwwww whats that glue stuff??"
    tool.RequiresHandle = false
    tool.Parent = backpack

    local jorkin = false
    local track = nil

    local function stopTomfoolery()
        jorkin = false
        if track then
            track:Stop()
            track = nil
        end
    end

    tool.Equipped:Connect(function() jorkin = true end)
    tool.Unequipped:Connect(stopTomfoolery)
    humanoid.Died:Connect(stopTomfoolery)

    while task.wait() do
        if not jorkin then continue end

        local isR15 = r15(speaker)
        if not track then
            local anim = Instance.new("Animation")
            anim.AnimationId = not isR15 and "rbxassetid://72042024" or "rbxassetid://698251653"
            track = humanoid:LoadAnimation(anim)
        end

        track:Play()
        track:AdjustSpeed(isR15 and 0.7 or 0.65)
        track.TimePosition = 0.6
        task.wait(0.1)
        while track and track.TimePosition < (not isR15 and 0.65 or 0.7) do task.wait(0.1) end
        if track then
            track:Stop()
            track = nil
        end
	end
end
lulu()
