-- God Mode Utility Script
-- Simple invincibility script for Roblox games

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local isInvincible = false
local originalHealth = Humanoid.MaxHealth

-- Notification function
local function notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 3
    })
end

-- Enable god mode
local function enableGodMode()
    isInvincible = true
    Humanoid.MaxHealth = math.huge
    Humanoid.Health = math.huge
    
    -- Health protection
    local healthConnection
    healthConnection = RunService.Heartbeat:Connect(function()
        if isInvincible and Humanoid then
            if Humanoid.Health < Humanoid.MaxHealth then
                Humanoid.Health = Humanoid.MaxHealth
            end
        end
    end)
    
    notify("God Mode", "God mode enabled!", 3)
end

-- Disable god mode
local function disableGodMode()
    isInvincible = false
    Humanoid.MaxHealth = originalHealth
    Humanoid.Health = originalHealth
    
    notify("God Mode", "God mode disabled!", 3)
end

-- Toggle god mode
local function toggleGodMode()
    if isInvincible then
        disableGodMode()
    else
        enableGodMode()
    end
end

-- Export functions
_G.god = enableGodMode
_G.ungod = disableGodMode
_G.toggleGod = toggleGodMode

notify("God Mode Utility", "God mode utility loaded! Use _G.god(), _G.ungod(), or _G.toggleGod()", 5)
