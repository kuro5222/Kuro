local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew",true))()

local 1Tab = library:CreateWindow("Test")

local folder = 1Tab:AddFolder("Folder")

folder:AddButton({
	text = "Click me",
	flag = "button",
	callback = function()
	print("hello world")
end
})

folder:AddToggle({
	text = "Toggle",
	flag = "toggle",
	callback = function(v)
	print(v)
end
})

folder:AddLabel({
	text = "This Is Sick!",
	type = "label"
	})