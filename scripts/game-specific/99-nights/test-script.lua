-- Simple Test Script for 99 Nights
-- This is a basic version to test if the URL works

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

-- Simple notification function
local function notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 3
    })
end

-- Simple GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TestGUI"
screenGui.Parent = LocalPlayer.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
title.Text = "Test Script Loaded!"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local testBtn = Instance.new("TextButton")
testBtn.Name = "TestBtn"
testBtn.Size = UDim2.new(1, -20, 0, 30)
testBtn.Position = UDim2.new(0, 10, 0, 50)
testBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
testBtn.Text = "Test Button"
testBtn.TextColor3 = Color3.new(1, 1, 1)
testBtn.TextScaled = true
testBtn.Font = Enum.Font.Gotham
testBtn.Parent = mainFrame

testBtn.MouseButton1Click:Connect(function()
    notify("Test", "Button clicked! Script is working!", 3)
end)

-- Test notifications
notify("Test Script", "Simple test script loaded successfully!", 3)
notify("GitHub", "If you see this, the GitHub URL is working!", 3)

print("Test script loaded successfully!")
