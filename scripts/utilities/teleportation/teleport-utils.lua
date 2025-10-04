-- Teleportation Utility Script
-- Simple teleportation functions for Roblox games

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Notification function
local function notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 3
    })
end

-- Basic teleportation
local function teleportTo(position)
    if typeof(position) == "Vector3" then
        RootPart.CFrame = CFrame.new(position)
        notify("Teleport", "Teleported to " .. tostring(position), 2)
    elseif typeof(position) == "CFrame" then
        RootPart.CFrame = position
        notify("Teleport", "Teleported to CFrame", 2)
    end
end

-- Teleport to player
local function teleportToPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
        RootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, 5, 0))
        notify("Teleport", "Teleported to " .. playerName, 2)
    else
        notify("Error", "Player not found or not loaded", 3)
    end
end

-- Smooth teleportation with tweening
local function smoothTeleport(position, duration)
    duration = duration or 1
    local startPosition = RootPart.Position
    local tween = TweenService:Create(
        RootPart,
        TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {CFrame = CFrame.new(position)}
    )
    tween:Play()
    notify("Smooth Teleport", "Smoothly teleporting...", duration)
end

-- Random teleportation
local function teleportToRandomLocation()
    local randomX = math.random(-500, 500)
    local randomZ = math.random(-500, 500)
    local randomY = 50
    
    local newPosition = Vector3.new(randomX, randomY, randomZ)
    teleportTo(newPosition)
    notify("Random Teleport", "Teleported to random location", 2)
end

-- Export functions
_G.teleport = teleportTo
_G.teleportToPlayer = teleportToPlayer
_G.smoothTeleport = smoothTeleport
_G.randomTeleport = teleportToRandomLocation

notify("Teleportation Utility", "Teleportation utility loaded! Use _G.teleport(), _G.teleportToPlayer(), etc.", 5)
