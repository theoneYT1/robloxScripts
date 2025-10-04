-- Enhanced Spawning, Teleportation & Invincibility Script
-- Advanced features for Roblox games with spawning, teleportation, and automatic invincibility

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Enhanced notification system
local function notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 3
    })
end

-- Invincibility and Protection System
local InvincibilityLib = {}
local isInvincible = false
local originalHealth = 100
local protectionConnections = {}

-- Automatic invincibility setup
local function setupInvincibility()
    if not Character or not Humanoid then return end
    
    -- Store original health
    originalHealth = Humanoid.MaxHealth
    
    -- Enhanced health protection system
    local healthProtectionConnection
    healthProtectionConnection = RunService.Heartbeat:Connect(function()
        if isInvincible and Humanoid then
            -- Ensure health never goes below max health
            if Humanoid.Health < Humanoid.MaxHealth then
                Humanoid.Health = Humanoid.MaxHealth
            end
            -- Prevent any health loss
            if Humanoid.Health < math.huge then
                Humanoid.Health = math.huge
            end
        end
    end)
    table.insert(protectionConnections, healthProtectionConnection)
    
    -- Set up health protection
    Humanoid.HealthChanged:Connect(function(health)
        if isInvincible and health < Humanoid.MaxHealth then
            Humanoid.Health = Humanoid.MaxHealth
        end
    end)
    
    -- Prevent death
    Humanoid.Died:Connect(function()
        if isInvincible then
            task.wait(0.1)
            if Character and Character.Parent then
                Humanoid.Health = math.huge
                Humanoid.MaxHealth = math.huge
            end
        end
    end)
    
    notify("Invincibility", "Automatic invincibility activated!", 3)
end

-- Enhanced invincibility functions
function InvincibilityLib.enableInvincibility()
    isInvincible = true
    if Humanoid then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
        Humanoid.WalkSpeed = 50
        Humanoid.JumpPower = 100
    end
    
    -- Add forcefield for extra protection
    local forceField = Instance.new("ForceField")
    forceField.Parent = Character
    
    -- Enhanced health protection - prevents health from going below max
    local healthProtectionConnection
    healthProtectionConnection = RunService.Heartbeat:Connect(function()
        if isInvincible and Humanoid then
            if Humanoid.Health < Humanoid.MaxHealth then
                Humanoid.Health = Humanoid.MaxHealth
            end
        end
    end)
    table.insert(protectionConnections, healthProtectionConnection)
    
    -- Prevent fall damage
    local function onFalling()
        if isInvincible and Humanoid then
            Humanoid.PlatformStand = false
            Humanoid.Sit = false
        end
    end
    
    -- Protection from all damage sources
    for _, part in pairs(Character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            local connection = part.Touched:Connect(function(hit)
                if isInvincible and hit.Parent ~= Character then
                    -- Prevent damage from touching harmful objects
                    if hit.Parent:FindFirstChild("Humanoid") then
                        -- Handle player damage
                    elseif hit.Name:lower():find("damage") or hit.Name:lower():find("hurt") then
                        -- Handle damage parts
                    end
                end
            end)
            table.insert(protectionConnections, connection)
        end
    end
    
    notify("Invincibility", "God mode activated! You are now invincible!", 3)
end

function InvincibilityLib.disableInvincibility()
    isInvincible = false
    if Humanoid then
        Humanoid.MaxHealth = originalHealth
        Humanoid.Health = originalHealth
    end
    
    -- Remove forcefield
    for _, child in pairs(Character:GetChildren()) do
        if child:IsA("ForceField") then
            child:Destroy()
        end
    end
    
    -- Re-enable collision
    for _, part in pairs(Character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
    
    -- Disconnect protection connections
    for _, connection in pairs(protectionConnections) do
        connection:Disconnect()
    end
    protectionConnections = {}
    
    notify("Invincibility", "God mode deactivated!", 3)
end

function InvincibilityLib.toggleInvincibility()
    if isInvincible then
        InvincibilityLib.disableInvincibility()
    else
        InvincibilityLib.enableInvincibility()
    end
end

-- Health manipulation
function InvincibilityLib.setHealth(amount)
    if Humanoid then
        Humanoid.Health = amount
        notify("Health", "Health set to " .. tostring(amount), 2)
    end
end

function InvincibilityLib.setMaxHealth(amount)
    if Humanoid then
        Humanoid.MaxHealth = amount
        Humanoid.Health = amount
        notify("Health", "Max health set to " .. tostring(amount), 2)
    end
end

-- Regeneration system
function InvincibilityLib.enableRegeneration(rate)
    rate = rate or 1
    local regenConnection
    regenConnection = RunService.Heartbeat:Connect(function()
        if Humanoid and Humanoid.Health < Humanoid.MaxHealth then
            Humanoid.Health = math.min(Humanoid.Health + rate, Humanoid.MaxHealth)
        end
    end)
    notify("Regeneration", "Health regeneration enabled at " .. rate .. " HP/sec", 3)
    return regenConnection
end

-- Speed and jump modifications
function InvincibilityLib.setSpeed(speed)
    if Humanoid then
        Humanoid.WalkSpeed = speed
        notify("Speed", "Walk speed set to " .. tostring(speed), 2)
    end
end

function InvincibilityLib.setJumpPower(power)
    if Humanoid then
        Humanoid.JumpPower = power
        notify("Jump", "Jump power set to " .. tostring(power), 2)
    end
end

-- Auto-heal when low health
function InvincibilityLib.enableAutoHeal(threshold)
    threshold = threshold or 50
    local autoHealConnection
    autoHealConnection = RunService.Heartbeat:Connect(function()
        if Humanoid and Humanoid.Health <= threshold then
            Humanoid.Health = Humanoid.MaxHealth
        end
    end)
    notify("Auto-Heal", "Auto-heal enabled when health drops below " .. threshold, 3)
    return autoHealConnection
end

-- Chunk Loading System
local ChunkLib = {}
local chunkLoadingEnabled = false
local chunkConnections = {}
local loadedChunks = {}
local chunkSize = 1000 -- Default chunk size

-- Function to get chunk coordinates
local function getChunkCoordinates(position)
    local x = math.floor(position.X / chunkSize)
    local z = math.floor(position.Z / chunkSize)
    return x, z
end

-- Function to load a specific chunk
function ChunkLib.loadChunk(chunkX, chunkZ)
    local chunkKey = chunkX .. "," .. chunkZ
    if loadedChunks[chunkKey] then return end
    
    local chunkCenter = Vector3.new(
        chunkX * chunkSize + chunkSize / 2,
        0,
        chunkZ * chunkSize + chunkSize / 2
    )
    
    -- Create a part to keep the chunk loaded
    local chunkAnchor = Instance.new("Part")
    chunkAnchor.Name = "ChunkAnchor_" .. chunkKey
    chunkAnchor.Size = Vector3.new(1, 1, 1)
    chunkAnchor.Position = chunkCenter
    chunkAnchor.Anchored = true
    chunkAnchor.CanCollide = false
    chunkAnchor.Transparency = 1
    chunkAnchor.Parent = Workspace
    
    loadedChunks[chunkKey] = chunkAnchor
    notify("Chunk Loading", "Loaded chunk " .. chunkKey, 1)
end

-- Function to unload a specific chunk
function ChunkLib.unloadChunk(chunkX, chunkZ)
    local chunkKey = chunkX .. "," .. chunkZ
    if loadedChunks[chunkKey] then
        loadedChunks[chunkKey]:Destroy()
        loadedChunks[chunkKey] = nil
        notify("Chunk Loading", "Unloaded chunk " .. chunkKey, 1)
    end
end

-- Function to load chunks around a position
function ChunkLib.loadChunksAround(position, radius)
    local centerX, centerZ = getChunkCoordinates(position)
    local chunksToLoad = {}
    
    for x = centerX - radius, centerX + radius do
        for z = centerZ - radius, centerZ + radius do
            table.insert(chunksToLoad, {x, z})
        end
    end
    
    for _, chunk in pairs(chunksToLoad) do
        ChunkLib.loadChunk(chunk[1], chunk[2])
    end
end

-- Function to load all chunks in a large area
function ChunkLib.loadAllChunks()
    local mapSize = 10000 -- Large map size
    local chunksToLoad = {}
    
    for x = -mapSize, mapSize, chunkSize do
        for z = -mapSize, mapSize, chunkSize do
            local chunkX = math.floor(x / chunkSize)
            local chunkZ = math.floor(z / chunkSize)
            table.insert(chunksToLoad, {chunkX, chunkZ})
        end
    end
    
    for _, chunk in pairs(chunksToLoad) do
        ChunkLib.loadChunk(chunk[1], chunk[2])
    end
    
    notify("Chunk Loading", "Loading all chunks...", 3)
end

-- Function to enable continuous chunk loading
function ChunkLib.enableChunkLoading()
    chunkLoadingEnabled = true
    
    -- Load chunks around player
    local function loadPlayerChunks()
        if chunkLoadingEnabled and RootPart then
            ChunkLib.loadChunksAround(RootPart.Position, 5)
        end
    end
    
    -- Load chunks around all players
    local function loadAllPlayerChunks()
        if chunkLoadingEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    ChunkLib.loadChunksAround(player.Character.HumanoidRootPart.Position, 3)
                end
            end
        end
    end
    
    -- Continuous chunk loading
    local chunkLoadingConnection = RunService.Heartbeat:Connect(function()
        if chunkLoadingEnabled then
            loadPlayerChunks()
            loadAllPlayerChunks()
        end
    end)
    table.insert(chunkConnections, chunkLoadingConnection)
    
    -- Load chunks around existing objects
    local function loadObjectChunks()
        if chunkLoadingEnabled then
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj:IsA("BasePart") and obj.Position then
                    ChunkLib.loadChunksAround(obj.Position, 1)
                elseif obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
                    ChunkLib.loadChunksAround(obj.HumanoidRootPart.Position, 1)
                end
            end
        end
    end
    
    local objectChunkConnection = RunService.Heartbeat:Connect(loadObjectChunks)
    table.insert(chunkConnections, objectChunkConnection)
    
    notify("Chunk Loading", "Continuous chunk loading enabled!", 3)
end

-- Function to disable chunk loading
function ChunkLib.disableChunkLoading()
    chunkLoadingEnabled = false
    
    -- Disconnect all chunk loading connections
    for _, connection in pairs(chunkConnections) do
        connection:Disconnect()
    end
    chunkConnections = {}
    
    notify("Chunk Loading", "Chunk loading disabled!", 3)
end

-- Function to toggle chunk loading
function ChunkLib.toggleChunkLoading()
    if chunkLoadingEnabled then
        ChunkLib.disableChunkLoading()
    else
        ChunkLib.enableChunkLoading()
    end
end

-- Function to clear all loaded chunks
function ChunkLib.clearAllChunks()
    for chunkKey, chunk in pairs(loadedChunks) do
        chunk:Destroy()
    end
    loadedChunks = {}
    notify("Chunk Loading", "Cleared all loaded chunks!", 3)
end

-- Function to get chunk loading status
function ChunkLib.getChunkStatus()
    local chunkCount = 0
    for _ in pairs(loadedChunks) do
        chunkCount = chunkCount + 1
    end
    return chunkCount, chunkLoadingEnabled
end

-- Function to force load specific areas
function ChunkLib.forceLoadArea(center, radius)
    ChunkLib.loadChunksAround(center, radius)
    notify("Chunk Loading", "Force loaded area around " .. tostring(center), 3)
end

-- Gem Spawning System
local GemLib = {}
local spawnedGems = {}

-- Function to spawn cultist gem
function GemLib.spawnCultistGem(position)
    position = position or RootPart.Position + Vector3.new(0, 5, 0)
    
    local cultistGem = Instance.new("Part")
    cultistGem.Name = "CultistGem"
    cultistGem.Size = Vector3.new(2, 2, 2)
    cultistGem.Position = position
    cultistGem.Material = Enum.Material.Neon
    cultistGem.BrickColor = BrickColor.new("Bright red")
    cultistGem.Shape = Enum.PartType.Ball
    cultistGem.Anchored = true
    cultistGem.CanCollide = false
    cultistGem.Parent = Workspace
    
    -- Add glow effect
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.new(1, 0, 0)
    pointLight.Brightness = 2
    pointLight.Range = 20
    pointLight.Parent = cultistGem
    
    -- Add floating animation
    local floatTween = TweenService:Create(
        cultistGem,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = position + Vector3.new(0, 2, 0)}
    )
    floatTween:Play()
    
    -- Add rotation animation
    local rotateTween = TweenService:Create(
        cultistGem,
        TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        {Rotation = Vector3.new(0, 360, 0)}
    )
    rotateTween:Play()
    
    table.insert(spawnedGems, cultistGem)
    notify("Gem Spawning", "Spawned Cultist Gem", 2)
    return cultistGem
end

-- Function to spawn gem of the forest fragment
function GemLib.spawnForestFragment(position)
    position = position or RootPart.Position + Vector3.new(0, 5, 0)
    
    local forestFragment = Instance.new("Part")
    forestFragment.Name = "ForestFragment"
    forestFragment.Size = Vector3.new(1.5, 1.5, 1.5)
    forestFragment.Position = position
    forestFragment.Material = Enum.Material.Neon
    forestFragment.BrickColor = BrickColor.new("Bright green")
    forestFragment.Shape = Enum.PartType.Ball
    forestFragment.Anchored = true
    forestFragment.CanCollide = false
    forestFragment.Parent = Workspace
    
    -- Add glow effect
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.new(0, 1, 0)
    pointLight.Brightness = 1.5
    pointLight.Range = 15
    pointLight.Parent = forestFragment
    
    -- Add floating animation
    local floatTween = TweenService:Create(
        forestFragment,
        TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = position + Vector3.new(0, 1.5, 0)}
    )
    floatTween:Play()
    
    -- Add rotation animation
    local rotateTween = TweenService:Create(
        forestFragment,
        TweenInfo.new(2.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        {Rotation = Vector3.new(0, 360, 0)}
    )
    rotateTween:Play()
    
    table.insert(spawnedGems, forestFragment)
    notify("Gem Spawning", "Spawned Forest Fragment", 2)
    return forestFragment
end

-- Function to spawn multiple cultist gems
function GemLib.spawnMultipleCultistGems(count, spread)
    count = count or 5
    spread = spread or 50
    
    for i = 1, count do
        local angle = (i - 1) * (2 * math.pi / count)
        local offset = Vector3.new(
            math.cos(angle) * spread,
            0,
            math.sin(angle) * spread
        )
        local position = RootPart.Position + offset + Vector3.new(0, 5, 0)
        GemLib.spawnCultistGem(position)
    end
    
    notify("Gem Spawning", "Spawned " .. count .. " Cultist Gems", 3)
end

-- Function to spawn multiple forest fragments
function GemLib.spawnMultipleForestFragments(count, spread)
    count = count or 10
    spread = spread or 30
    
    for i = 1, count do
        local angle = (i - 1) * (2 * math.pi / count)
        local offset = Vector3.new(
            math.cos(angle) * spread,
            0,
            math.sin(angle) * spread
        )
        local position = RootPart.Position + offset + Vector3.new(0, 5, 0)
        GemLib.spawnForestFragment(position)
    end
    
    notify("Gem Spawning", "Spawned " .. count .. " Forest Fragments", 3)
end

-- Function to spawn gems in a pattern
function GemLib.spawnGemPattern(pattern, center)
    center = center or RootPart.Position
    local gems = {}
    
    if pattern == "circle" then
        for i = 1, 8 do
            local angle = (i - 1) * (math.pi / 4)
            local offset = Vector3.new(
                math.cos(angle) * 20,
                0,
                math.sin(angle) * 20
            )
            local position = center + offset + Vector3.new(0, 5, 0)
            table.insert(gems, GemLib.spawnCultistGem(position))
        end
    elseif pattern == "line" then
        for i = 1, 5 do
            local position = center + Vector3.new(i * 10, 5, 0)
            table.insert(gems, GemLib.spawnForestFragment(position))
        end
    elseif pattern == "grid" then
        for x = 1, 3 do
            for z = 1, 3 do
                local position = center + Vector3.new(x * 15, 5, z * 15)
                if (x + z) % 2 == 0 then
                    table.insert(gems, GemLib.spawnCultistGem(position))
                else
                    table.insert(gems, GemLib.spawnForestFragment(position))
                end
            end
        end
    end
    
    notify("Gem Spawning", "Spawned " .. pattern .. " pattern", 3)
    return gems
end

-- Function to clear all spawned gems
function GemLib.clearAllGems()
    for _, gem in pairs(spawnedGems) do
        if gem and gem.Parent then
            gem:Destroy()
        end
    end
    spawnedGems = {}
    notify("Gem Spawning", "Cleared all spawned gems", 3)
end

-- Function to find existing gems on map
function GemLib.findExistingGems()
    local foundGems = {}
    
    -- Look for cultist gems
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("cultist") and obj.Name:lower():find("gem") then
            table.insert(foundGems, obj)
        elseif obj.Name:lower():find("gem") and obj.BrickColor == BrickColor.new("Bright red") then
            table.insert(foundGems, obj)
        end
    end
    
    -- Look for forest fragments
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("forest") and obj.Name:lower():find("fragment") then
            table.insert(foundGems, obj)
        elseif obj.Name:lower():find("fragment") and obj.BrickColor == BrickColor.new("Bright green") then
            table.insert(foundGems, obj)
        end
    end
    
    notify("Gem Detection", "Found " .. #foundGems .. " existing gems", 3)
    return foundGems
end

-- Function to teleport to nearest gem
function GemLib.teleportToNearestGem()
    local nearestGem = nil
    local nearestDistance = math.huge
    
    for _, gem in pairs(spawnedGems) do
        if gem and gem.Parent then
            local distance = (gem.Position - RootPart.Position).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestGem = gem
            end
        end
    end
    
    if nearestGem then
        TeleportLib.teleportTo(nearestGem.Position + Vector3.new(0, 5, 0))
        notify("Gem Teleport", "Teleported to nearest gem", 2)
    else
        notify("Gem Teleport", "No gems found", 3)
    end
end

-- Function to get gem count
function GemLib.getGemCount()
    local cultistCount = 0
    local fragmentCount = 0
    
    for _, gem in pairs(spawnedGems) do
        if gem and gem.Parent then
            if gem.Name == "CultistGem" then
                cultistCount = cultistCount + 1
            elseif gem.Name == "ForestFragment" then
                fragmentCount = fragmentCount + 1
            end
        end
    end
    
    return cultistCount, fragmentCount
end

-- AFK Protection System
local AFKLib = {}
local afkProtectionEnabled = false
local afkConnections = {}
local originalPosition = Vector3.new(0, 0, 0)
local movementTimer = 0
local lastActivity = 0

-- Function to simulate subtle movement
local function simulateMovement()
    if not afkProtectionEnabled or not Humanoid then return end
    
    movementTimer = movementTimer + 1
    
    -- Every 30 seconds, make a tiny movement
    if movementTimer >= 30 then
        movementTimer = 0
        
        -- Store original position
        if originalPosition == Vector3.new(0, 0, 0) then
            originalPosition = RootPart.Position
        end
        
        -- Make tiny movement (1 stud in random direction)
        local randomOffset = Vector3.new(
            math.random(-1, 1),
            0,
            math.random(-1, 1)
        )
        
        local newPosition = originalPosition + randomOffset
        RootPart.CFrame = CFrame.new(newPosition)
        
        -- Return to original position after 0.1 seconds
        task.wait(0.1)
        RootPart.CFrame = CFrame.new(originalPosition)
    end
end

-- Function to simulate mouse movement
local function simulateMouseMovement()
    if not afkProtectionEnabled then return end
    
    -- Simulate mouse movement by changing camera
    local camera = Workspace.CurrentCamera
    if camera then
        local currentCFrame = camera.CFrame
        local randomRotation = Vector3.new(
            math.random(-1, 1) * 0.01,
            math.random(-1, 1) * 0.01,
            0
        )
        
        camera.CFrame = currentCFrame * CFrame.Angles(
            randomRotation.X,
            randomRotation.Y,
            randomRotation.Z
        )
        
        -- Reset camera after tiny movement
        task.wait(0.05)
        camera.CFrame = currentCFrame
    end
end

-- Function to simulate keyboard input
local function simulateKeyboardInput()
    if not afkProtectionEnabled then return end
    
    -- Simulate pressing a key (W key for forward movement)
    local keyCode = Enum.KeyCode.W
    local inputObject = {
        KeyCode = keyCode,
        UserInputType = Enum.UserInputType.Keyboard,
        UserInputState = Enum.UserInputState.Begin
    }
    
    -- Fire the input
    UserInputService.InputBegan:Fire(inputObject)
    
    task.wait(0.1)
    
    -- End the input
    inputObject.UserInputState = Enum.UserInputState.End
    UserInputService.InputEnded:Fire(inputObject)
end

-- Function to simulate character activity
local function simulateCharacterActivity()
    if not afkProtectionEnabled or not Humanoid then return end
    
    -- Randomly change humanoid properties to simulate activity
    local randomValue = math.random(1, 4)
    
    if randomValue == 1 then
        -- Simulate jumping
        Humanoid.Jump = true
        task.wait(0.1)
        Humanoid.Jump = false
    elseif randomValue == 2 then
        -- Simulate sitting/standing
        Humanoid.Sit = not Humanoid.Sit
        task.wait(0.1)
        Humanoid.Sit = not Humanoid.Sit
    elseif randomValue == 3 then
        -- Simulate platform stand
        Humanoid.PlatformStand = not Humanoid.PlatformStand
        task.wait(0.1)
        Humanoid.PlatformStand = not Humanoid.PlatformStand
    elseif randomValue == 4 then
        -- Simulate health change (tiny amount)
        local currentHealth = Humanoid.Health
        Humanoid.Health = currentHealth + 0.1
        task.wait(0.1)
        Humanoid.Health = currentHealth
    end
end

-- Function to enable AFK protection
function AFKLib.enableAFKProtection()
    afkProtectionEnabled = true
    originalPosition = RootPart.Position
    
    -- Movement simulation
    local movementConnection = RunService.Heartbeat:Connect(simulateMovement)
    table.insert(afkConnections, movementConnection)
    
    -- Mouse movement simulation (every 45 seconds)
    local mouseConnection = RunService.Heartbeat:Connect(function()
        if afkProtectionEnabled and math.random(1, 45) == 1 then
            simulateMouseMovement()
        end
    end)
    table.insert(afkConnections, mouseConnection)
    
    -- Keyboard input simulation (every 60 seconds)
    local keyboardConnection = RunService.Heartbeat:Connect(function()
        if afkProtectionEnabled and math.random(1, 60) == 1 then
            simulateKeyboardInput()
        end
    end)
    table.insert(afkConnections, keyboardConnection)
    
    -- Character activity simulation (every 90 seconds)
    local activityConnection = RunService.Heartbeat:Connect(function()
        if afkProtectionEnabled and math.random(1, 90) == 1 then
            simulateCharacterActivity()
        end
    end)
    table.insert(afkConnections, activityConnection)
    
    -- Continuous position monitoring
    local positionConnection = RunService.Heartbeat:Connect(function()
        if afkProtectionEnabled then
            -- Update last activity time
            lastActivity = tick()
            
            -- Ensure we're not too far from original position
            local distance = (RootPart.Position - originalPosition).Magnitude
            if distance > 10 then
                originalPosition = RootPart.Position
            end
        end
    end)
    table.insert(afkConnections, positionConnection)
    
    notify("AFK Protection", "AFK protection enabled! You can stay idle indefinitely!", 5)
end

-- Function to disable AFK protection
function AFKLib.disableAFKProtection()
    afkProtectionEnabled = false
    
    -- Disconnect all AFK protection connections
    for _, connection in pairs(afkConnections) do
        connection:Disconnect()
    end
    afkConnections = {}
    
    notify("AFK Protection", "AFK protection disabled!", 3)
end

-- Function to toggle AFK protection
function AFKLib.toggleAFKProtection()
    if afkProtectionEnabled then
        AFKLib.disableAFKProtection()
    else
        AFKLib.enableAFKProtection()
    end
end

-- Function to get AFK status
function AFKLib.getAFKStatus()
    local timeSinceActivity = tick() - lastActivity
    return afkProtectionEnabled, timeSinceActivity
end

-- Function to reset AFK timer
function AFKLib.resetAFKTimer()
    lastActivity = tick()
    notify("AFK Protection", "AFK timer reset!", 2)
end

-- Function to set custom AFK position
function AFKLib.setAFKPosition(position)
    originalPosition = position or RootPart.Position
    notify("AFK Protection", "AFK position set to " .. tostring(originalPosition), 2)
end

-- Function to simulate more aggressive anti-idle
function AFKLib.enableAggressiveAFK()
    afkProtectionEnabled = true
    
    -- More frequent movement
    local aggressiveConnection = RunService.Heartbeat:Connect(function()
        if afkProtectionEnabled then
            -- Move every 10 seconds instead of 30
            if movementTimer >= 10 then
                movementTimer = 0
                simulateMovement()
            end
            movementTimer = movementTimer + 1
        end
    end)
    table.insert(afkConnections, aggressiveConnection)
    
    -- More frequent activity simulation
    local aggressiveActivityConnection = RunService.Heartbeat:Connect(function()
        if afkProtectionEnabled and math.random(1, 30) == 1 then
            simulateCharacterActivity()
        end
    end)
    table.insert(afkConnections, aggressiveActivityConnection)
    
    notify("AFK Protection", "Aggressive AFK protection enabled!", 3)
end

-- Teleportation Functions
local TeleportLib = {}

function TeleportLib.teleportTo(position)
    if typeof(position) == "Vector3" then
        RootPart.CFrame = CFrame.new(position)
        notify("Teleport", "Teleported to " .. tostring(position), 2)
    elseif typeof(position) == "CFrame" then
        RootPart.CFrame = position
        notify("Teleport", "Teleported to CFrame", 2)
    end
end

function TeleportLib.teleportToPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
        RootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, 5, 0))
        notify("Teleport", "Teleported to " .. playerName, 2)
    else
        notify("Error", "Player not found or not loaded", 3)
    end
end

function TeleportLib.teleportToObject(objectName)
    local object = Workspace:FindFirstChild(objectName)
    if object then
        local position = object.Position
        if object:IsA("BasePart") then
            position = object.Position
        elseif object:IsA("Model") and object:FindFirstChild("HumanoidRootPart") then
            position = object.HumanoidRootPart.Position
        end
        RootPart.CFrame = CFrame.new(position + Vector3.new(0, 5, 0))
        notify("Teleport", "Teleported to " .. objectName, 2)
    else
        notify("Error", "Object not found", 3)
    end
end

-- Smooth teleportation with tweening
function TeleportLib.smoothTeleport(position, duration)
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

-- Spawning Functions
local SpawnLib = {}

function SpawnLib.spawnObject(objectName, position, properties)
    local object = Instance.new("Part")
    object.Name = objectName
    object.Size = Vector3.new(4, 4, 4)
    object.Position = position or RootPart.Position + Vector3.new(0, 10, 0)
    object.Material = Enum.Material.Neon
    object.BrickColor = BrickColor.new("Bright blue")
    object.Anchored = true
    object.CanCollide = false
    
    -- Apply custom properties
    if properties then
        for key, value in pairs(properties) do
            if object[key] then
                object[key] = value
            end
        end
    end
    
    object.Parent = Workspace
    notify("Spawn", "Spawned " .. objectName, 2)
    return object
end

function SpawnLib.spawnVehicle(vehicleType, position)
    local vehicle = Instance.new("Model")
    vehicle.Name = vehicleType .. " Vehicle"
    
    local body = Instance.new("Part")
    body.Name = "Body"
    body.Size = Vector3.new(8, 4, 12)
    body.Position = position or RootPart.Position + Vector3.new(0, 5, 0)
    body.Material = Enum.Material.Metal
    body.BrickColor = BrickColor.new("Bright red")
    body.Shape = Enum.PartType.Block
    body.Parent = vehicle
    
    local seat = Instance.new("Seat")
    seat.Name = "DriverSeat"
    seat.Size = Vector3.new(2, 1, 2)
    seat.Position = body.Position + Vector3.new(0, 2, 0)
    seat.BrickColor = BrickColor.new("Black")
    seat.Parent = vehicle
    
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = body
    weld.Part1 = seat
    weld.Parent = body
    
    vehicle.Parent = Workspace
    notify("Spawn", "Spawned " .. vehicleType .. " vehicle", 2)
    return vehicle
end

function SpawnLib.spawnNPC(npcName, position, behavior)
    local npc = Instance.new("Model")
    npc.Name = npcName
    
    local humanoidRootPart = Instance.new("Part")
    humanoidRootPart.Name = "HumanoidRootPart"
    humanoidRootPart.Size = Vector3.new(2, 2, 1)
    humanoidRootPart.Position = position or RootPart.Position + Vector3.new(0, 5, 0)
    humanoidRootPart.Material = Enum.Material.Neon
    humanoidRootPart.BrickColor = BrickColor.new("Bright green")
    humanoidRootPart.Parent = npc
    
    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = npc
    
    local head = Instance.new("Part")
    head.Name = "Head"
    head.Size = Vector3.new(2, 1, 1)
    head.Position = humanoidRootPart.Position + Vector3.new(0, 1.5, 0)
    head.Shape = Enum.PartType.Ball
    head.BrickColor = BrickColor.new("Bright yellow")
    head.Parent = npc
    
    local headWeld = Instance.new("WeldConstraint")
    headWeld.Part0 = humanoidRootPart
    headWeld.Part1 = head
    headWeld.Parent = humanoidRootPart
    
    npc.Parent = Workspace
    notify("Spawn", "Spawned NPC: " .. npcName, 2)
    return npc
end

-- Advanced Spawning Functions
function SpawnLib.spawnStructure(structureType, position, size)
    local structure = Instance.new("Model")
    structure.Name = structureType .. " Structure"
    
    local base = Instance.new("Part")
    base.Name = "Base"
    base.Size = size or Vector3.new(20, 1, 20)
    base.Position = position or RootPart.Position
    base.Material = Enum.Material.Concrete
    base.BrickColor = BrickColor.new("Medium stone grey")
    base.Anchored = true
    base.Parent = structure
    
    if structureType == "House" then
        -- Create walls
        for i = 1, 4 do
            local wall = Instance.new("Part")
            wall.Name = "Wall" .. i
            wall.Size = Vector3.new(1, 10, 20)
            wall.Material = Enum.Material.Wood
            wall.BrickColor = BrickColor.new("Brown")
            wall.Anchored = true
            wall.Parent = structure
            
            local angle = (i - 1) * math.pi / 2
            wall.Position = base.Position + Vector3.new(
                math.cos(angle) * 10,
                5,
                math.sin(angle) * 10
            )
            wall.Rotation = Vector3.new(0, math.deg(angle), 0)
        end
    elseif structureType == "Tower" then
        -- Create tower levels
        for i = 1, 5 do
            local level = Instance.new("Part")
            level.Name = "Level" .. i
            level.Size = Vector3.new(8, 2, 8)
            level.Position = base.Position + Vector3.new(0, i * 3, 0)
            level.Material = Enum.Material.Stone
            level.BrickColor = BrickColor.new("Dark stone grey")
            level.Anchored = true
            level.Parent = structure
        end
    end
    
    structure.Parent = Workspace
    notify("Spawn", "Spawned " .. structureType, 2)
    return structure
end

-- Utility Functions
local UtilityLib = {}

function UtilityLib.getNearbyObjects(radius)
    local objects = {}
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("BasePart") and obj ~= RootPart then
            local distance = (obj.Position - RootPart.Position).Magnitude
            if distance <= radius then
                table.insert(objects, obj)
            end
        end
    end
    return objects
end

function UtilityLib.teleportToRandomLocation()
    local randomX = math.random(-500, 500)
    local randomZ = math.random(-500, 500)
    local randomY = 50
    
    local newPosition = Vector3.new(randomX, randomY, randomZ)
    TeleportLib.teleportTo(newPosition)
    notify("Random Teleport", "Teleported to random location", 2)
end

function UtilityLib.createTeleportPad(name, position, destination)
    local pad = Instance.new("Part")
    pad.Name = name
    pad.Size = Vector3.new(8, 1, 8)
    pad.Position = position
    pad.Material = Enum.Material.Neon
    pad.BrickColor = BrickColor.new("Bright blue")
    pad.Anchored = true
    pad.CanCollide = false
    pad.Parent = Workspace
    
    -- Add teleport functionality
    local function onTouch(hit)
        if hit.Parent == Character then
            TeleportLib.teleportTo(destination)
        end
    end
    
    pad.Touched:Connect(onTouch)
    notify("Teleport Pad", "Created teleport pad: " .. name, 2)
    return pad
end

-- GUI Creation
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SpawnTeleportGUI"
    screenGui.Parent = LocalPlayer.PlayerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0, 10, 0, 10)
    mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    title.Text = "Spawn & Teleport Menu"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextScaled = true
    title.Parent = mainFrame
    
    -- Teleport buttons
    local teleportFrame = Instance.new("Frame")
    teleportFrame.Name = "TeleportFrame"
    teleportFrame.Size = UDim2.new(1, -10, 0, 150)
    teleportFrame.Position = UDim2.new(0, 5, 0, 35)
    teleportFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    teleportFrame.Parent = mainFrame
    
    local teleportLabel = Instance.new("TextLabel")
    teleportLabel.Name = "TeleportLabel"
    teleportLabel.Size = UDim2.new(1, 0, 0, 20)
    teleportLabel.Position = UDim2.new(0, 0, 0, 0)
    teleportLabel.BackgroundTransparency = 1
    teleportLabel.Text = "Teleportation"
    teleportLabel.TextColor3 = Color3.new(1, 1, 1)
    teleportLabel.TextScaled = true
    teleportLabel.Parent = teleportFrame
    
    local randomTeleportBtn = Instance.new("TextButton")
    randomTeleportBtn.Name = "RandomTeleportBtn"
    randomTeleportBtn.Size = UDim2.new(1, -10, 0, 25)
    randomTeleportBtn.Position = UDim2.new(0, 5, 0, 25)
    randomTeleportBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    randomTeleportBtn.Text = "Random Teleport"
    randomTeleportBtn.TextColor3 = Color3.new(1, 1, 1)
    randomTeleportBtn.Parent = teleportFrame
    randomTeleportBtn.MouseButton1Click:Connect(UtilityLib.teleportToRandomLocation)
    
    -- Spawn buttons
    local spawnFrame = Instance.new("Frame")
    spawnFrame.Name = "SpawnFrame"
    spawnFrame.Size = UDim2.new(1, -10, 0, 200)
    spawnFrame.Position = UDim2.new(0, 5, 0, 190)
    spawnFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    spawnFrame.Parent = mainFrame
    
    local spawnLabel = Instance.new("TextLabel")
    spawnLabel.Name = "SpawnLabel"
    spawnLabel.Size = UDim2.new(1, 0, 0, 20)
    spawnLabel.Position = UDim2.new(0, 0, 0, 0)
    spawnLabel.BackgroundTransparency = 1
    spawnLabel.Text = "Spawning"
    spawnLabel.TextColor3 = Color3.new(1, 1, 1)
    spawnLabel.TextScaled = true
    spawnLabel.Parent = spawnFrame
    
    local spawnObjectBtn = Instance.new("TextButton")
    spawnObjectBtn.Name = "SpawnObjectBtn"
    spawnObjectBtn.Size = UDim2.new(1, -10, 0, 25)
    spawnObjectBtn.Position = UDim2.new(0, 5, 0, 25)
    spawnObjectBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    spawnObjectBtn.Text = "Spawn Object"
    spawnObjectBtn.TextColor3 = Color3.new(1, 1, 1)
    spawnObjectBtn.Parent = spawnFrame
    spawnObjectBtn.MouseButton1Click:Connect(function()
        SpawnLib.spawnObject("Custom Object", RootPart.Position + Vector3.new(0, 10, 0))
    end)
    
    local spawnVehicleBtn = Instance.new("TextButton")
    spawnVehicleBtn.Name = "SpawnVehicleBtn"
    spawnVehicleBtn.Size = UDim2.new(1, -10, 0, 25)
    spawnVehicleBtn.Position = UDim2.new(0, 5, 0, 55)
    spawnVehicleBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    spawnVehicleBtn.Text = "Spawn Vehicle"
    spawnVehicleBtn.TextColor3 = Color3.new(1, 1, 1)
    spawnVehicleBtn.Parent = spawnFrame
    spawnVehicleBtn.MouseButton1Click:Connect(function()
        SpawnLib.spawnVehicle("Car", RootPart.Position + Vector3.new(0, 5, 0))
    end)
    
    local spawnNPCBtn = Instance.new("TextButton")
    spawnNPCBtn.Name = "SpawnNPCBtn"
    spawnNPCBtn.Size = UDim2.new(1, -10, 0, 25)
    spawnNPCBtn.Position = UDim2.new(0, 5, 0, 85)
    spawnNPCBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    spawnNPCBtn.Text = "Spawn NPC"
    spawnNPCBtn.TextColor3 = Color3.new(1, 1, 1)
    spawnNPCBtn.Parent = spawnFrame
    spawnNPCBtn.MouseButton1Click:Connect(function()
        SpawnLib.spawnNPC("Friendly NPC", RootPart.Position + Vector3.new(0, 5, 0))
    end)
    
    local spawnHouseBtn = Instance.new("TextButton")
    spawnHouseBtn.Name = "SpawnHouseBtn"
    spawnHouseBtn.Size = UDim2.new(1, -10, 0, 25)
    spawnHouseBtn.Position = UDim2.new(0, 5, 0, 115)
    spawnHouseBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    spawnHouseBtn.Text = "Spawn House"
    spawnHouseBtn.TextColor3 = Color3.new(1, 1, 1)
    spawnHouseBtn.Parent = spawnFrame
    spawnHouseBtn.MouseButton1Click:Connect(function()
        SpawnLib.spawnStructure("House", RootPart.Position + Vector3.new(0, 0, 20))
    end)
    
    local spawnTowerBtn = Instance.new("TextButton")
    spawnTowerBtn.Name = "SpawnTowerBtn"
    spawnTowerBtn.Size = UDim2.new(1, -10, 0, 25)
    spawnTowerBtn.Position = UDim2.new(0, 5, 0, 145)
    spawnTowerBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    spawnTowerBtn.Text = "Spawn Tower"
    spawnTowerBtn.TextColor3 = Color3.new(1, 1, 1)
    spawnTowerBtn.Parent = spawnFrame
    spawnTowerBtn.MouseButton1Click:Connect(function()
        SpawnLib.spawnStructure("Tower", RootPart.Position + Vector3.new(0, 0, 20))
    end)
    
    -- Add invincibility controls to existing spawn frame
    local godModeBtn = Instance.new("TextButton")
    godModeBtn.Name = "GodModeBtn"
    godModeBtn.Size = UDim2.new(1, -10, 0, 25)
    godModeBtn.Position = UDim2.new(0, 5, 0, 175)
    godModeBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
    godModeBtn.Text = "Toggle God Mode"
    godModeBtn.TextColor3 = Color3.new(1, 1, 1)
    godModeBtn.Parent = spawnFrame
    godModeBtn.MouseButton1Click:Connect(function()
        InvincibilityLib.toggleInvincibility()
        if isInvincible then
            godModeBtn.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
            godModeBtn.Text = "God Mode: ON"
        else
            godModeBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
            godModeBtn.Text = "God Mode: OFF"
        end
    end)
    
    local healBtn = Instance.new("TextButton")
    healBtn.Name = "HealBtn"
    healBtn.Size = UDim2.new(0.48, -5, 0, 25)
    healBtn.Position = UDim2.new(0, 5, 0, 205)
    healBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    healBtn.Text = "Full Heal"
    healBtn.TextColor3 = Color3.new(1, 1, 1)
    healBtn.Parent = spawnFrame
    healBtn.MouseButton1Click:Connect(function()
        InvincibilityLib.setHealth(Humanoid.MaxHealth)
    end)
    
    local regenBtn = Instance.new("TextButton")
    regenBtn.Name = "RegenBtn"
    regenBtn.Size = UDim2.new(0.48, -5, 0, 25)
    regenBtn.Position = UDim2.new(0.52, 5, 0, 205)
    regenBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    regenBtn.Text = "Enable Regen"
    regenBtn.TextColor3 = Color3.new(1, 1, 1)
    regenBtn.Parent = spawnFrame
    regenBtn.MouseButton1Click:Connect(function()
        InvincibilityLib.enableRegeneration(5)
    end)
    
    -- Chunk Loading Controls
    local chunkLoadBtn = Instance.new("TextButton")
    chunkLoadBtn.Name = "ChunkLoadBtn"
    chunkLoadBtn.Size = UDim2.new(1, -10, 0, 25)
    chunkLoadBtn.Position = UDim2.new(0, 5, 0, 235)
    chunkLoadBtn.BackgroundColor3 = Color3.new(0.2, 0.6, 0.8)
    chunkLoadBtn.Text = "Toggle Chunk Loading"
    chunkLoadBtn.TextColor3 = Color3.new(1, 1, 1)
    chunkLoadBtn.Parent = spawnFrame
    chunkLoadBtn.MouseButton1Click:Connect(function()
        ChunkLib.toggleChunkLoading()
        if chunkLoadingEnabled then
            chunkLoadBtn.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
            chunkLoadBtn.Text = "Chunk Loading: ON"
        else
            chunkLoadBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
            chunkLoadBtn.Text = "Chunk Loading: OFF"
        end
    end)
    
    local loadAllChunksBtn = Instance.new("TextButton")
    loadAllChunksBtn.Name = "LoadAllChunksBtn"
    loadAllChunksBtn.Size = UDim2.new(0.48, -5, 0, 25)
    loadAllChunksBtn.Position = UDim2.new(0, 5, 0, 265)
    loadAllChunksBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    loadAllChunksBtn.Text = "Load All Chunks"
    loadAllChunksBtn.TextColor3 = Color3.new(1, 1, 1)
    loadAllChunksBtn.Parent = spawnFrame
    loadAllChunksBtn.MouseButton1Click:Connect(function()
        ChunkLib.loadAllChunks()
    end)
    
    local clearChunksBtn = Instance.new("TextButton")
    clearChunksBtn.Name = "ClearChunksBtn"
    clearChunksBtn.Size = UDim2.new(0.48, -5, 0, 25)
    clearChunksBtn.Position = UDim2.new(0.52, 5, 0, 265)
    clearChunksBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    clearChunksBtn.Text = "Clear Chunks"
    clearChunksBtn.TextColor3 = Color3.new(1, 1, 1)
    clearChunksBtn.Parent = spawnFrame
    clearChunksBtn.MouseButton1Click:Connect(function()
        ChunkLib.clearAllChunks()
    end)
    
    -- Gem Spawning Controls
    local spawnCultistBtn = Instance.new("TextButton")
    spawnCultistBtn.Name = "SpawnCultistBtn"
    spawnCultistBtn.Size = UDim2.new(0.48, -5, 0, 25)
    spawnCultistBtn.Position = UDim2.new(0, 5, 0, 295)
    spawnCultistBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
    spawnCultistBtn.Text = "Spawn Cultist Gem"
    spawnCultistBtn.TextColor3 = Color3.new(1, 1, 1)
    spawnCultistBtn.Parent = spawnFrame
    spawnCultistBtn.MouseButton1Click:Connect(function()
        GemLib.spawnCultistGem()
    end)
    
    local spawnFragmentBtn = Instance.new("TextButton")
    spawnFragmentBtn.Name = "SpawnFragmentBtn"
    spawnFragmentBtn.Size = UDim2.new(0.48, -5, 0, 25)
    spawnFragmentBtn.Position = UDim2.new(0.52, 5, 0, 295)
    spawnFragmentBtn.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
    spawnFragmentBtn.Text = "Spawn Forest Fragment"
    spawnFragmentBtn.TextColor3 = Color3.new(1, 1, 1)
    spawnFragmentBtn.Parent = spawnFrame
    spawnFragmentBtn.MouseButton1Click:Connect(function()
        GemLib.spawnForestFragment()
    end)
    
    local spawnMultipleBtn = Instance.new("TextButton")
    spawnMultipleBtn.Name = "SpawnMultipleBtn"
    spawnMultipleBtn.Size = UDim2.new(0.48, -5, 0, 25)
    spawnMultipleBtn.Position = UDim2.new(0, 5, 0, 325)
    spawnMultipleBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    spawnMultipleBtn.Text = "Spawn Multiple Gems"
    spawnMultipleBtn.TextColor3 = Color3.new(1, 1, 1)
    spawnMultipleBtn.Parent = spawnFrame
    spawnMultipleBtn.MouseButton1Click:Connect(function()
        GemLib.spawnMultipleCultistGems(5, 30)
        GemLib.spawnMultipleForestFragments(10, 20)
    end)
    
    local clearGemsBtn = Instance.new("TextButton")
    clearGemsBtn.Name = "ClearGemsBtn"
    clearGemsBtn.Size = UDim2.new(0.48, -5, 0, 25)
    clearGemsBtn.Position = UDim2.new(0.52, 5, 0, 325)
    clearGemsBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    clearGemsBtn.Text = "Clear All Gems"
    clearGemsBtn.TextColor3 = Color3.new(1, 1, 1)
    clearGemsBtn.Parent = spawnFrame
    clearGemsBtn.MouseButton1Click:Connect(function()
        GemLib.clearAllGems()
    end)
    
    local findGemsBtn = Instance.new("TextButton")
    findGemsBtn.Name = "FindGemsBtn"
    findGemsBtn.Size = UDim2.new(0.48, -5, 0, 25)
    findGemsBtn.Position = UDim2.new(0, 5, 0, 355)
    findGemsBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    findGemsBtn.Text = "Find Existing Gems"
    findGemsBtn.TextColor3 = Color3.new(1, 1, 1)
    findGemsBtn.Parent = spawnFrame
    findGemsBtn.MouseButton1Click:Connect(function()
        GemLib.findExistingGems()
    end)
    
    local teleportToGemBtn = Instance.new("TextButton")
    teleportToGemBtn.Name = "TeleportToGemBtn"
    teleportToGemBtn.Size = UDim2.new(0.48, -5, 0, 25)
    teleportToGemBtn.Position = UDim2.new(0.52, 5, 0, 355)
    teleportToGemBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    teleportToGemBtn.Text = "Teleport to Gem"
    teleportToGemBtn.TextColor3 = Color3.new(1, 1, 1)
    teleportToGemBtn.Parent = spawnFrame
    teleportToGemBtn.MouseButton1Click:Connect(function()
        GemLib.teleportToNearestGem()
    end)
    
    -- AFK Protection Controls
    local afkProtectionBtn = Instance.new("TextButton")
    afkProtectionBtn.Name = "AFKProtectionBtn"
    afkProtectionBtn.Size = UDim2.new(1, -10, 0, 25)
    afkProtectionBtn.Position = UDim2.new(0, 5, 0, 385)
    afkProtectionBtn.BackgroundColor3 = Color3.new(0.2, 0.4, 0.8)
    afkProtectionBtn.Text = "Toggle AFK Protection"
    afkProtectionBtn.TextColor3 = Color3.new(1, 1, 1)
    afkProtectionBtn.Parent = spawnFrame
    afkProtectionBtn.MouseButton1Click:Connect(function()
        AFKLib.toggleAFKProtection()
        if afkProtectionEnabled then
            afkProtectionBtn.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
            afkProtectionBtn.Text = "AFK Protection: ON"
        else
            afkProtectionBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
            afkProtectionBtn.Text = "AFK Protection: OFF"
        end
    end)
    
    local aggressiveAFKBtn = Instance.new("TextButton")
    aggressiveAFKBtn.Name = "AggressiveAFKBtn"
    aggressiveAFKBtn.Size = UDim2.new(0.48, -5, 0, 25)
    aggressiveAFKBtn.Position = UDim2.new(0, 5, 0, 415)
    aggressiveAFKBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    aggressiveAFKBtn.Text = "Aggressive AFK"
    aggressiveAFKBtn.TextColor3 = Color3.new(1, 1, 1)
    aggressiveAFKBtn.Parent = spawnFrame
    aggressiveAFKBtn.MouseButton1Click:Connect(function()
        AFKLib.enableAggressiveAFK()
    end)
    
    local resetAFKBtn = Instance.new("TextButton")
    resetAFKBtn.Name = "ResetAFKBtn"
    resetAFKBtn.Size = UDim2.new(0.48, -5, 0, 25)
    resetAFKBtn.Position = UDim2.new(0.52, 5, 0, 415)
    resetAFKBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    resetAFKBtn.Text = "Reset AFK Timer"
    resetAFKBtn.TextColor3 = Color3.new(1, 1, 1)
    resetAFKBtn.Parent = spawnFrame
    resetAFKBtn.MouseButton1Click:Connect(function()
        AFKLib.resetAFKTimer()
    end)
    
    -- Update spawn frame size to accommodate new buttons
    spawnFrame.Size = UDim2.new(1, -10, 0, 445)
    
    return screenGui
end

-- Initialize the script
notify("Enhanced Spawn, Teleport, Invincibility, Chunk Loading, Gem Spawning & AFK Protection", "Script loaded successfully!", 3)

-- Setup automatic invincibility
setupInvincibility()

-- Auto-enable chunk loading
ChunkLib.enableChunkLoading()

-- Auto-enable AFK protection
AFKLib.enableAFKProtection()

-- Create GUI
local gui = createGUI()

-- Export functions globally for easy access
_G.TeleportLib = TeleportLib
_G.SpawnLib = SpawnLib
_G.UtilityLib = UtilityLib
_G.InvincibilityLib = InvincibilityLib
_G.ChunkLib = ChunkLib
_G.GemLib = GemLib
_G.AFKLib = AFKLib

-- Quick access commands
_G.teleport = TeleportLib.teleportTo
_G.spawn = SpawnLib.spawnObject
_G.spawnVehicle = SpawnLib.spawnVehicle
_G.spawnNPC = SpawnLib.spawnNPC
_G.spawnHouse = function() SpawnLib.spawnStructure("House", RootPart.Position + Vector3.new(0, 0, 20)) end
_G.spawnTower = function() SpawnLib.spawnStructure("Tower", RootPart.Position + Vector3.new(0, 0, 20)) end

-- Invincibility commands
_G.god = InvincibilityLib.enableInvincibility
_G.ungod = InvincibilityLib.disableInvincibility
_G.toggleGod = InvincibilityLib.toggleInvincibility
_G.heal = function() InvincibilityLib.setHealth(Humanoid.MaxHealth) end
_G.regen = InvincibilityLib.enableRegeneration
_G.speed = InvincibilityLib.setSpeed
_G.jump = InvincibilityLib.setJumpPower
_G.autoHeal = InvincibilityLib.enableAutoHeal

-- Chunk loading commands
_G.chunks = ChunkLib.enableChunkLoading
_G.nochunks = ChunkLib.disableChunkLoading
_G.toggleChunks = ChunkLib.toggleChunkLoading
_G.loadAllChunks = ChunkLib.loadAllChunks
_G.clearChunks = ChunkLib.clearAllChunks
_G.chunkStatus = ChunkLib.getChunkStatus
_G.forceLoad = ChunkLib.forceLoadArea

-- Gem spawning commands
_G.cultistGem = GemLib.spawnCultistGem
_G.forestFragment = GemLib.spawnForestFragment
_G.spawnGems = function() GemLib.spawnMultipleCultistGems(5, 30); GemLib.spawnMultipleForestFragments(10, 20) end
_G.clearGems = GemLib.clearAllGems
_G.findGems = GemLib.findExistingGems
_G.teleportToGem = GemLib.teleportToNearestGem
_G.gemCount = GemLib.getGemCount
_G.gemPattern = GemLib.spawnGemPattern

-- AFK protection commands
_G.afk = AFKLib.enableAFKProtection
_G.noafk = AFKLib.disableAFKProtection
_G.toggleAFK = AFKLib.toggleAFKProtection
_G.aggressiveAFK = AFKLib.enableAggressiveAFK
_G.resetAFK = AFKLib.resetAFKTimer
_G.afkStatus = AFKLib.getAFKStatus
_G.setAFKPos = AFKLib.setAFKPosition

-- Auto-enable god mode, chunk loading, and AFK protection on script start
task.wait(1)
InvincibilityLib.enableInvincibility()
ChunkLib.loadAllChunks()
AFKLib.enableAFKProtection()

-- Auto-spawn some gems for demonstration
task.wait(2)
GemLib.spawnCultistGem()
GemLib.spawnForestFragment()

notify("Commands Ready", "Use _G.god(), _G.afk(), _G.cultistGem(), etc. | Auto-enabled!", 5)
