game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Notif Joined/Leave",
    Text = "Successfully executed",
    Duration = 2,
})
wait(0.1)
--Notif
loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/Notif%20player.lua"))()

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Notif on chat",
    Text = "Successfully executed",
    Duration = 2,
})
wait(0.1)
--Notif on chat
loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/Joined%20Left.lua"))()

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Notif Died",
    Text = "Successfully executed",
    Duration = 2,
})
wait(0.1)

--Notif died
loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/Dead%20notify.lua"))()

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Shiftlock",
    Text = "Successfully executed",
    Duration = 2,
})

--shiftlock
loadstring(game:HttpGet("https://raw.githubusercontent.com/kuro5222/Kuro/main/ShiftLock.lua"))()
