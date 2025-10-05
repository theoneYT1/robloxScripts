-- Enhanced Voidware Loader with Auto-Features
repeat task.wait() until game:IsLoaded()

-- Auto-enable features for 99 Nights
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Auto-enable variables
local isAFKEnabled = false
local isChunkLoadingEnabled = false
local originalPosition = Vector3.new(0, 0, 0)
local movementTimer = 0
local lastAFKUpdate = 0
local lastChunkUpdate = 0
local chunkConnections = {}
local loadedChunks = {}
local chunkSize = 2000
local CHUNK_UPDATE_INTERVAL = 2
local AFK_UPDATE_INTERVAL = 5

-- Auto-invincibility (always enabled)
local isInvincible = true

-- Auto-invincibility system (always active) - ULTRA EFFECTIVE
local function enableAutoInvincibility()
    -- Method 1: Ultra-fast health protection
    spawn(function()
        while isInvincible do
            if Humanoid then
                Humanoid.MaxHealth = 999999
                Humanoid.Health = 999999
            end
            wait(0.001) -- Run 1000 times per second
        end
    end)
    
    -- Method 2: Additional ultra-fast protection
    spawn(function()
        while isInvincible do
            if Humanoid then
                Humanoid.Health = 999999
                Humanoid.MaxHealth = 999999
            end
            wait(0.0001) -- Run 10,000 times per second
        end
    end)
    
    -- Method 3: Health change protection with immediate reset
    spawn(function()
        while isInvincible do
            if Humanoid then
                Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                    Humanoid.Health = 999999
                    Humanoid.MaxHealth = 999999
                end)
            end
            wait(0.01)
        end
    end)
    
    -- Method 4: Teleport protection when taking damage
    spawn(function()
        local lastHealth = 999999
        while isInvincible do
            if Humanoid and Humanoid.Health < lastHealth then
                local safePosition = RootPart.Position + Vector3.new(0, 50, 0)
                RootPart.CFrame = CFrame.new(safePosition)
                Humanoid.Health = 999999
                Humanoid.MaxHealth = 999999
            end
            lastHealth = Humanoid.Health
            wait(0.01)
        end
    end)
    
    -- Method 5: BodyVelocity protection
    spawn(function()
        while isInvincible do
            if RootPart then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.Parent = RootPart
                wait(0.1)
                if bodyVelocity then
                    bodyVelocity:Destroy()
                end
            end
            wait(0.1)
        end
    end)
    
    -- Handle respawning
    LocalPlayer.CharacterAdded:Connect(function(character)
        local newHumanoid = character:WaitForChild("Humanoid")
        local newRootPart = character:WaitForChild("HumanoidRootPart")
        spawn(function()
            while isInvincible do
                if newHumanoid then
                    newHumanoid.MaxHealth = 999999
                    newHumanoid.Health = 999999
                end
                wait(0.001)
            end
        end)
    end)
    
    -- Notify user
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Invincibility",
        Text = "ULTRA God mode activated!",
        Duration = 3
    })
end

-- Auto-enable AFK protection
local function enableAutoAFK()
    isAFKEnabled = true
    originalPosition = RootPart.Position
end

-- Auto-enable chunk loading
local function enableAutoChunkLoading()
    isChunkLoadingEnabled = true
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

-- Auto-enable all features
task.wait(1)
enableAutoInvincibility()
enableAutoAFK()
enableAutoChunkLoading()

-- Original Voidware Loader
local meta = {
    [2619619496] = {
        title = "Bedwars",
        dev = "vwdev/vwrw.lua",
        script = "https://raw.githubusercontent.com/VapeVoidware/VWRewrite/main/NewMainScript.lua"
    },
    [7008097940] = {
       title = "Ink Game",
       dev = "vwdev/inkgame.lua",
       script = "https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/inkgame.lua"
    },
    [6331902150] = {
        title = "Forsaken",
        dev = "vwdev/forsaken.lua",
        script = "https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/forsaken.lua"
    },
    [7326934954] = {
        title = "99 Nights In The Forest",
        dev = "vwdev/nightsintheforest.lua",
        script = "https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/nightsintheforest.lua"
    }
}
local data = meta[game.GameId]
if not data then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Voidware | Loader",
        Text = "Unsupported game :c",
        Duration = 15
    })
    return
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Voidware | Loader",
        Text = "Loading for "..tostring(data.title).."...",
        Duration = 15
    })
    local res
    if shared.VoidDev and data.dev ~= nil and pcall(function() return isfile(data.dev) end) then
        res = loadstring(readfile(data.dev))
    else
        res = loadstring(game:HttpGet(data.script, true))
    end
    if type(res) ~= "function" then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Voidware Loading Error",
            Text = tostring(res),
            Duration = 15
        })
        task.delay(0.5, function()
            if shared.VoidDev then return end
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Voidware Loading Error",
                Text = "Please report this issue to erchodev#0 \n or in discord.gg/voidware",
                Duration = 15
            })
        end)
    else
        local suc, err = pcall(res)
        if not suc then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Voidware Main Error",
                Text = tostring(err),
                Duration = 15
            })
            task.delay(0.5, function()
                if shared.VoidDev then return end
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Voidware Main Error",
                    Text = "Please report this issue to erchodev#0 \n or in discord.gg/voidware",
                    Duration = 15
                })
            end)
        else
            -- Successfully loaded Voidware, now execute it
            print("Voidware loaded successfully!")
        end
    end
end