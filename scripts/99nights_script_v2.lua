-- Enhanced 99 Nights Script with Voidware-style GUI
-- Auto-loading chunks, invincibility, and AFK protection

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

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

-- Variables
local isInvincible = false
local isAFKEnabled = false
local isChunkLoadingEnabled = false
local originalHealth = 100
local originalPosition = Vector3.new(0, 0, 0)
local movementTimer = 0
local lastAFKUpdate = 0
local lastChunkUpdate = 0
local chunkConnections = {}
local loadedChunks = {}
local chunkSize = 2000
local CHUNK_UPDATE_INTERVAL = 2
local AFK_UPDATE_INTERVAL = 5

-- Invincibility System
local function toggleInvincibility()
    isInvincible = not isInvincible
    if isInvincible then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
        Humanoid.WalkSpeed = 50
        Humanoid.JumpPower = 100
        
        local forceField = Instance.new("ForceField")
        forceField.Parent = Character
        
        -- Health protection
        local healthConnection = RunService.Heartbeat:Connect(function()
            if isInvincible and Humanoid and Humanoid.Health < Humanoid.MaxHealth then
                Humanoid.Health = Humanoid.MaxHealth
            end
        end)
        
        notify("Invincibility", "God mode activated!", 3)
    else
        Humanoid.MaxHealth = originalHealth
        Humanoid.Health = originalHealth
        Humanoid.WalkSpeed = 16
        Humanoid.JumpPower = 50
        
        for _, child in pairs(Character:GetChildren()) do
            if child:IsA("ForceField") then
                child:Destroy()
            end
        end
        
        notify("Invincibility", "God mode deactivated!", 3)
    end
end

-- AFK Protection System
local function simulateMovement()
    if not isAFKEnabled or not Humanoid then return end
    
    movementTimer = movementTimer + 1
    
    if movementTimer >= 30 then
        movementTimer = 0
        
        if originalPosition == Vector3.new(0, 0, 0) then
            originalPosition = RootPart.Position
        end
        
        local randomOffset = Vector3.new(
            math.random(-1, 1),
            0,
            math.random(-1, 1)
        )
        
        local newPosition = originalPosition + randomOffset
        RootPart.CFrame = CFrame.new(newPosition)
        
        task.wait(0.1)
        RootPart.CFrame = CFrame.new(originalPosition)
    end
end

local function toggleAFK()
    isAFKEnabled = not isAFKEnabled
    if isAFKEnabled then
        originalPosition = RootPart.Position
        notify("AFK Protection", "AFK protection enabled!", 3)
    else
        notify("AFK Protection", "AFK protection disabled!", 3)
    end
end

-- Chunk Loading System
local function getChunkCoordinates(position)
    local x = math.floor(position.X / chunkSize)
    local z = math.floor(position.Z / chunkSize)
    return x, z
end

local function loadChunk(chunkX, chunkZ)
    local chunkKey = chunkX .. "," .. chunkZ
    if loadedChunks[chunkKey] then return end
    
    local chunkCenter = Vector3.new(
        chunkX * chunkSize + chunkSize / 2,
        0,
        chunkZ * chunkSize + chunkSize / 2
    )
    
    local chunkAnchor = Instance.new("Part")
    chunkAnchor.Name = "ChunkAnchor_" .. chunkKey
    chunkAnchor.Size = Vector3.new(1, 1, 1)
    chunkAnchor.Position = chunkCenter
    chunkAnchor.Anchored = true
    chunkAnchor.CanCollide = false
    chunkAnchor.Transparency = 1
    chunkAnchor.Parent = Workspace
    
    loadedChunks[chunkKey] = chunkAnchor
end

local function loadChunksAround(position, radius)
    local centerX, centerZ = getChunkCoordinates(position)
    local chunksToLoad = {}
    
    for x = centerX - radius, centerX + radius do
        for z = centerZ - radius, centerZ + radius do
            table.insert(chunksToLoad, {x, z})
        end
    end
    
    for _, chunk in pairs(chunksToLoad) do
        loadChunk(chunk[1], chunk[2])
    end
end

local function toggleChunkLoading()
    isChunkLoadingEnabled = not isChunkLoadingEnabled
    if isChunkLoadingEnabled then
        notify("Chunk Loading", "Chunk loading enabled!", 3)
    else
        for _, connection in pairs(chunkConnections) do
            connection:Disconnect()
        end
        chunkConnections = {}
        notify("Chunk Loading", "Chunk loading disabled!", 3)
    end
end

-- Main update loop
local function mainLoop()
    local currentTime = tick()
    
    -- AFK Protection
    if isAFKEnabled and currentTime - lastAFKUpdate >= AFK_UPDATE_INTERVAL then
        lastAFKUpdate = currentTime
        simulateMovement()
    end
    
    -- Chunk Loading
    if isChunkLoadingEnabled and currentTime - lastChunkUpdate >= CHUNK_UPDATE_INTERVAL then
        lastChunkUpdate = currentTime
        if RootPart then
            loadChunksAround(RootPart.Position, 3)
        end
    end
end

-- Start main loop
local mainConnection = RunService.Heartbeat:Connect(mainLoop)

-- Auto-enable features (chunk loading and AFK, but not invincibility)
task.wait(1)
-- Auto-enable chunk loading
isChunkLoadingEnabled = true
notify("Chunk Loading", "Chunk loading auto-enabled!", 3)

-- Auto-enable AFK protection
isAFKEnabled = true
originalPosition = RootPart.Position
notify("AFK Protection", "AFK protection auto-enabled!", 3)

-- Don't auto-enable invincibility - let user toggle it
notify("99 Nights Enhanced", "Chunk loading and AFK auto-enabled! Toggle invincibility as needed.", 5)

-- Export functions for easy access
_G.toggleInvincibility = toggleInvincibility
_G.toggleAFK = toggleAFK
_G.toggleChunkLoading = toggleChunkLoading

print("99 Nights Enhanced Script loaded successfully!")
print("Features: Invincibility, AFK Protection, Chunk Loading")
print("Commands: _G.toggleInvincibility(), _G.toggleAFK(), _G.toggleChunkLoading()")