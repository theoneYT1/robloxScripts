-- Simple Working Script for 99 Nights
-- Basic features that definitely work

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Notification function
local function notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 3
    })
end

-- Simple GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimpleGUI"
screenGui.Parent = LocalPlayer.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
title.Text = "99 Nights Enhanced Script"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- God Mode Button
local godBtn = Instance.new("TextButton")
godBtn.Name = "GodBtn"
godBtn.Size = UDim2.new(1, -20, 0, 40)
godBtn.Position = UDim2.new(0, 10, 0, 50)
godBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
godBtn.Text = "Toggle God Mode"
godBtn.TextColor3 = Color3.new(1, 1, 1)
godBtn.TextScaled = true
godBtn.Font = Enum.Font.Gotham
godBtn.Parent = mainFrame

local godCorner = Instance.new("UICorner")
godCorner.CornerRadius = UDim.new(0, 4)
godCorner.Parent = godBtn

-- Teleport Button
local teleportBtn = Instance.new("TextButton")
teleportBtn.Name = "TeleportBtn"
teleportBtn.Size = UDim2.new(1, -20, 0, 40)
teleportBtn.Position = UDim2.new(0, 10, 0, 100)
teleportBtn.BackgroundColor3 = Color3.new(0.2, 0.6, 0.8)
teleportBtn.Text = "Random Teleport"
teleportBtn.TextColor3 = Color3.new(1, 1, 1)
teleportBtn.TextScaled = true
teleportBtn.Font = Enum.Font.Gotham
teleportBtn.Parent = mainFrame

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 4)
teleportCorner.Parent = teleportBtn

-- Spawn Button
local spawnBtn = Instance.new("TextButton")
spawnBtn.Name = "SpawnBtn"
spawnBtn.Size = UDim2.new(1, -20, 0, 40)
spawnBtn.Position = UDim2.new(0, 10, 0, 150)
spawnBtn.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
spawnBtn.Text = "Spawn Object"
spawnBtn.TextColor3 = Color3.new(1, 1, 1)
spawnBtn.TextScaled = true
spawnBtn.Font = Enum.Font.Gotham
spawnBtn.Parent = mainFrame

local spawnCorner = Instance.new("UICorner")
spawnCorner.CornerRadius = UDim.new(0, 4)
spawnCorner.Parent = spawnBtn

-- Flying Button
local flyBtn = Instance.new("TextButton")
flyBtn.Name = "FlyBtn"
flyBtn.Size = UDim2.new(1, -20, 0, 40)
flyBtn.Position = UDim2.new(0, 10, 0, 200)
flyBtn.BackgroundColor3 = Color3.new(0.8, 0.4, 0.2)
flyBtn.Text = "Toggle Flying"
flyBtn.TextColor3 = Color3.new(1, 1, 1)
flyBtn.TextScaled = true
flyBtn.Font = Enum.Font.Gotham
flyBtn.Parent = mainFrame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 4)
flyCorner.Parent = flyBtn

-- Variables
local isGodMode = false
local isFlying = false
local flyConnection = nil

-- God Mode Function
local function toggleGodMode()
    isGodMode = not isGodMode
    if isGodMode then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
        Humanoid.WalkSpeed = 50
        Humanoid.JumpPower = 100
        
        local forceField = Instance.new("ForceField")
        forceField.Parent = Character
        
        godBtn.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
        godBtn.Text = "God Mode: ON"
        notify("God Mode", "God mode activated!", 3)
    else
        Humanoid.MaxHealth = 100
        Humanoid.Health = 100
        Humanoid.WalkSpeed = 16
        Humanoid.JumpPower = 50
        
        for _, child in pairs(Character:GetChildren()) do
            if child:IsA("ForceField") then
                child:Destroy()
            end
        end
        
        godBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
        godBtn.Text = "God Mode: OFF"
        notify("God Mode", "God mode deactivated!", 3)
    end
end

-- Teleport Function
local function randomTeleport()
    local randomX = math.random(-500, 500)
    local randomZ = math.random(-500, 500)
    local randomY = 50
    
    RootPart.CFrame = CFrame.new(randomX, randomY, randomZ)
    notify("Teleport", "Teleported to random location!", 2)
end

-- Spawn Function
local function spawnObject()
    local object = Instance.new("Part")
    object.Name = "Spawned Object"
    object.Size = Vector3.new(4, 4, 4)
    object.Position = RootPart.Position + Vector3.new(0, 10, 0)
    object.Material = Enum.Material.Neon
    object.BrickColor = BrickColor.new("Bright blue")
    object.Anchored = true
    object.CanCollide = false
    object.Parent = Workspace
    
    notify("Spawn", "Spawned object!", 2)
end

-- Flying Function
local function toggleFlying()
    isFlying = not isFlying
    if isFlying then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = RootPart
        
        flyConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not isFlying then return end
            
            local camera = Workspace.CurrentCamera
            local moveVector = Vector3.new(0, 0, 0)
            
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                moveVector = moveVector + camera.CFrame.LookVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                moveVector = moveVector - camera.CFrame.LookVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                moveVector = moveVector - camera.CFrame.RightVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                moveVector = moveVector + camera.CFrame.RightVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                moveVector = moveVector + Vector3.new(0, 1, 0)
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                moveVector = moveVector - Vector3.new(0, 1, 0)
            end
            
            if moveVector.Magnitude > 0 then
                bodyVelocity.Velocity = moveVector.Unit * 50
            else
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end)
        
        flyBtn.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
        flyBtn.Text = "Flying: ON"
        notify("Flying", "Flying enabled! Use WASD + Space/Shift", 3)
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        for _, child in pairs(RootPart:GetChildren()) do
            if child:IsA("BodyVelocity") then
                child:Destroy()
            end
        end
        
        flyBtn.BackgroundColor3 = Color3.new(0.8, 0.4, 0.2)
        flyBtn.Text = "Flying: OFF"
        notify("Flying", "Flying disabled!", 3)
    end
end

-- Connect buttons
godBtn.MouseButton1Click:Connect(toggleGodMode)
teleportBtn.MouseButton1Click:Connect(randomTeleport)
spawnBtn.MouseButton1Click:Connect(spawnObject)
flyBtn.MouseButton1Click:Connect(toggleFlying)

-- Notifications
notify("Script Loaded", "Simple 99 Nights script loaded successfully!", 3)
notify("Features", "God Mode, Teleport, Spawn, Flying available!", 3)

print("Simple 99 Nights script loaded successfully!")
