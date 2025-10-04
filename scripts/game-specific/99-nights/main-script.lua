-- Voidware-Style Enhanced Script
-- Advanced GUI system with private features and flying

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local Mouse = Players.LocalPlayer:GetMouse()

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Private access system (Voidware style)
local PRIVATE_USERS = {
    "theoneYT1", -- Your username for private access
    "VoidwareUser",
    "PrivateUser"
}

local function isPrivateUser()
    for _, username in pairs(PRIVATE_USERS) do
        if LocalPlayer.Name == username then
            return true
        end
    end
    return false
end

-- Performance settings
local PERFORMANCE_MODE = true
local HEARTBEAT_INTERVAL = 0.1
local lastHeartbeat = 0

-- Enhanced notification system
local function notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 3
    })
end

-- Optimized heartbeat system
local function shouldRunHeartbeat()
    if not PERFORMANCE_MODE then return true end
    local currentTime = tick()
    if currentTime - lastHeartbeat >= HEARTBEAT_INTERVAL then
        lastHeartbeat = currentTime
        return true
    end
    return false
end

-- Invincibility and Protection System
local InvincibilityLib = {}
local isInvincible = false
local originalHealth = 100
local protectionConnections = {}

local function setupInvincibility()
    if not Character or not Humanoid then return end
    
    originalHealth = Humanoid.MaxHealth
    
    local healthProtectionConnection
    healthProtectionConnection = RunService.Heartbeat:Connect(function()
        if not shouldRunHeartbeat() then return end
        if isInvincible and Humanoid and Humanoid.Health < Humanoid.MaxHealth then
                Humanoid.Health = Humanoid.MaxHealth
        end
    end)
    table.insert(protectionConnections, healthProtectionConnection)
    
    Humanoid.HealthChanged:Connect(function(health)
        if isInvincible and health < Humanoid.MaxHealth then
            Humanoid.Health = Humanoid.MaxHealth
        end
    end)
    
    notify("Invincibility", "Optimized invincibility activated!", 3)
end

function InvincibilityLib.enableInvincibility()
    isInvincible = true
    if Humanoid then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
        Humanoid.WalkSpeed = 50
        Humanoid.JumpPower = 100
    end
    
    local forceField = Instance.new("ForceField")
    forceField.Parent = Character
    
    notify("Invincibility", "God mode activated!", 3)
end

function InvincibilityLib.disableInvincibility()
    isInvincible = false
    if Humanoid then
        Humanoid.MaxHealth = originalHealth
        Humanoid.Health = originalHealth
    end
    
    for _, child in pairs(Character:GetChildren()) do
        if child:IsA("ForceField") then
            child:Destroy()
        end
    end
    
    notify("Invincibility", "God mode deactivated!", 3)
end

function InvincibilityLib.toggleInvincibility()
    if isInvincible then
        InvincibilityLib.disableInvincibility()
    else
        InvincibilityLib.enableInvincibility()
    end
end

-- Advanced Flying System (Voidware style)
local FlyLib = {}
local flySpeed = 50
local flyEnabled = false
local flyConnection = nil
local flyKeys = {
    W = false,
    A = false,
    S = false,
    D = false,
    Space = false,
    LeftShift = false
}

function FlyLib.enableFlying()
    if not isPrivateUser() then
        notify("Access Denied", "Flying is private feature only!", 3)
        return
    end
    
    flyEnabled = true
    
    -- Create BodyVelocity for smooth flying
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = RootPart
    
    -- Create BodyAngularVelocity for rotation
    local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
    bodyAngularVelocity.MaxTorque = Vector3.new(4000, 4000, 4000)
    bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
    bodyAngularVelocity.Parent = RootPart
    
    -- Input handling
    local function onInputBegan(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.W then
            flyKeys.W = true
        elseif input.KeyCode == Enum.KeyCode.A then
            flyKeys.A = true
        elseif input.KeyCode == Enum.KeyCode.S then
            flyKeys.S = true
        elseif input.KeyCode == Enum.KeyCode.D then
            flyKeys.D = true
        elseif input.KeyCode == Enum.KeyCode.Space then
            flyKeys.Space = true
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            flyKeys.LeftShift = true
    end
end

    local function onInputEnded(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.W then
            flyKeys.W = false
        elseif input.KeyCode == Enum.KeyCode.A then
            flyKeys.A = false
        elseif input.KeyCode == Enum.KeyCode.S then
            flyKeys.S = false
        elseif input.KeyCode == Enum.KeyCode.D then
            flyKeys.D = false
        elseif input.KeyCode == Enum.KeyCode.Space then
            flyKeys.Space = false
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            flyKeys.LeftShift = false
        end
    end
    
    UserInputService.InputBegan:Connect(onInputBegan)
    UserInputService.InputEnded:Connect(onInputEnded)
    
    -- Flying logic
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flyEnabled or not RootPart then return end
        
        local camera = Workspace.CurrentCamera
        local moveVector = Vector3.new(0, 0, 0)
        
        -- Calculate movement direction
        if flyKeys.W then
            moveVector = moveVector + camera.CFrame.LookVector
        end
        if flyKeys.S then
            moveVector = moveVector - camera.CFrame.LookVector
        end
        if flyKeys.A then
            moveVector = moveVector - camera.CFrame.RightVector
        end
        if flyKeys.D then
            moveVector = moveVector + camera.CFrame.RightVector
        end
        if flyKeys.Space then
            moveVector = moveVector + Vector3.new(0, 1, 0)
        end
        if flyKeys.LeftShift then
            moveVector = moveVector - Vector3.new(0, 1, 0)
        end
        
        -- Apply movement
        if moveVector.Magnitude > 0 then
            bodyVelocity.Velocity = moveVector.Unit * flySpeed
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    notify("Flying", "Flying enabled! Use WASD + Space/Shift", 3)
end

function FlyLib.disableFlying()
    flyEnabled = false
    
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    -- Remove flying parts
    for _, child in pairs(RootPart:GetChildren()) do
        if child:IsA("BodyVelocity") or child:IsA("BodyAngularVelocity") then
            child:Destroy()
    end
end

    notify("Flying", "Flying disabled!", 3)
end

function FlyLib.toggleFlying()
    if flyEnabled then
        FlyLib.disableFlying()
    else
        FlyLib.enableFlying()
        end
    end
    
function FlyLib.setFlySpeed(speed)
    flySpeed = speed
    notify("Flying", "Fly speed set to " .. speed, 2)
end

-- Enhanced Teleportation System
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

function TeleportLib.teleportToMouse()
    local hit = Mouse.Hit
    if hit then
        RootPart.CFrame = CFrame.new(hit.Position + Vector3.new(0, 5, 0))
        notify("Teleport", "Teleported to mouse position", 2)
        end
    end
    
-- Enhanced Spawning System
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

function SpawnLib.spawnAtMouse(objectName, properties)
    local hit = Mouse.Hit
    if hit then
        return SpawnLib.spawnObject(objectName, hit.Position + Vector3.new(0, 5, 0), properties)
    else
        return SpawnLib.spawnObject(objectName, RootPart.Position + Vector3.new(0, 10, 0), properties)
        end
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

function SpawnLib.spawnHouse(position, size)
    local house = Instance.new("Model")
    house.Name = "Custom House"
    
    local base = Instance.new("Part")
    base.Name = "Base"
    base.Size = size or Vector3.new(20, 1, 20)
    base.Position = position or RootPart.Position
    base.Material = Enum.Material.Concrete
    base.BrickColor = BrickColor.new("Medium stone grey")
    base.Anchored = true
    base.Parent = house
    
    -- Create walls
    for i = 1, 4 do
        local wall = Instance.new("Part")
        wall.Name = "Wall" .. i
        wall.Size = Vector3.new(1, 10, 20)
        wall.Material = Enum.Material.Wood
        wall.BrickColor = BrickColor.new("Brown")
        wall.Anchored = true
        wall.Parent = house
        
        local angle = (i - 1) * math.pi / 2
        wall.Position = base.Position + Vector3.new(
            math.cos(angle) * 10,
            5,
            math.sin(angle) * 10
        )
        wall.Rotation = Vector3.new(0, math.deg(angle), 0)
    end
    
    house.Parent = Workspace
    notify("Spawn", "Spawned Custom House", 2)
    return house
end

function SpawnLib.spawnTower(position, height)
    local tower = Instance.new("Model")
    tower.Name = "Custom Tower"
    
    local base = Instance.new("Part")
    base.Name = "Base"
    base.Size = Vector3.new(8, 1, 8)
    base.Position = position or RootPart.Position
    base.Material = Enum.Material.Stone
    base.BrickColor = BrickColor.new("Dark stone grey")
    base.Anchored = true
    base.Parent = tower
    
    -- Create tower levels
    for i = 1, (height or 5) do
        local level = Instance.new("Part")
        level.Name = "Level" .. i
        level.Size = Vector3.new(8, 2, 8)
        level.Position = base.Position + Vector3.new(0, i * 3, 0)
        level.Material = Enum.Material.Stone
        level.BrickColor = BrickColor.new("Dark stone grey")
        level.Anchored = true
        level.Parent = tower
    end
    
    tower.Parent = Workspace
    notify("Spawn", "Spawned Custom Tower", 2)
    return tower
end

-- Enhanced Gem Spawning System
local GemLib = {}
local spawnedGems = {}

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
    
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.new(1, 0, 0)
    pointLight.Brightness = 2
    pointLight.Range = 20
    pointLight.Parent = cultistGem
    
    local floatTween = TweenService:Create(
        cultistGem,
        TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = position + Vector3.new(0, 2, 0)}
    )
    floatTween:Play()
    
    table.insert(spawnedGems, cultistGem)
    notify("Gem Spawning", "Spawned Cultist Gem", 2)
    return cultistGem
end

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
    
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.new(0, 1, 0)
    pointLight.Brightness = 1.5
    pointLight.Range = 15
    pointLight.Parent = forestFragment
    
    local floatTween = TweenService:Create(
        forestFragment,
        TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = position + Vector3.new(0, 1.5, 0)}
    )
    floatTween:Play()
    
    table.insert(spawnedGems, forestFragment)
    notify("Gem Spawning", "Spawned Forest Fragment", 2)
    return forestFragment
end

function GemLib.clearAllGems()
    for _, gem in pairs(spawnedGems) do
        if gem and gem.Parent then
            gem:Destroy()
        end
    end
    spawnedGems = {}
    notify("Gem Spawning", "Cleared all spawned gems", 3)
end

-- Optimized Chunk Loading System
local ChunkLib = {}
local chunkLoadingEnabled = false
local chunkConnections = {}
local loadedChunks = {}
local chunkSize = 2000
local lastChunkUpdate = 0
local CHUNK_UPDATE_INTERVAL = 2

local function getChunkCoordinates(position)
    local x = math.floor(position.X / chunkSize)
    local z = math.floor(position.Z / chunkSize)
    return x, z
end

function ChunkLib.loadChunk(chunkX, chunkZ)
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
    
function ChunkLib.enableChunkLoading()
    chunkLoadingEnabled = true
    
    local chunkLoadingConnection = RunService.Heartbeat:Connect(function()
        if not shouldRunHeartbeat() then return end
        if not chunkLoadingEnabled then return end
        
        local currentTime = tick()
        if currentTime - lastChunkUpdate >= CHUNK_UPDATE_INTERVAL then
            lastChunkUpdate = currentTime
            
            if RootPart then
                ChunkLib.loadChunksAround(RootPart.Position, 3)
            end
        end
    end)
    table.insert(chunkConnections, chunkLoadingConnection)
    
    notify("Chunk Loading", "Chunk loading enabled!", 3)
end

function ChunkLib.disableChunkLoading()
    chunkLoadingEnabled = false
    
    for _, connection in pairs(chunkConnections) do
        connection:Disconnect()
    end
    chunkConnections = {}
    
    notify("Chunk Loading", "Chunk loading disabled!", 3)
end

function ChunkLib.toggleChunkLoading()
    if chunkLoadingEnabled then
        ChunkLib.disableChunkLoading()
    else
        ChunkLib.enableChunkLoading()
    end
end

-- Optimized AFK Protection System
local AFKLib = {}
local afkProtectionEnabled = false
local afkConnections = {}
local originalPosition = Vector3.new(0, 0, 0)
local movementTimer = 0
local lastAFKUpdate = 0
local AFK_UPDATE_INTERVAL = 5

local function simulateMovement()
    if not afkProtectionEnabled or not Humanoid then return end
    
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

function AFKLib.enableAFKProtection()
    afkProtectionEnabled = true
    originalPosition = RootPart.Position
    
    local afkConnection = RunService.Heartbeat:Connect(function()
        if not shouldRunHeartbeat() then return end
        if not afkProtectionEnabled then return end
        
        local currentTime = tick()
        if currentTime - lastAFKUpdate >= AFK_UPDATE_INTERVAL then
            lastAFKUpdate = currentTime
            simulateMovement()
        end
    end)
    table.insert(afkConnections, afkConnection)
    
    notify("AFK Protection", "AFK protection enabled!", 5)
end

function AFKLib.disableAFKProtection()
    afkProtectionEnabled = false
    
    for _, connection in pairs(afkConnections) do
        connection:Disconnect()
    end
    afkConnections = {}
    
    notify("AFK Protection", "AFK protection disabled!", 3)
end

function AFKLib.toggleAFKProtection()
    if afkProtectionEnabled then
        AFKLib.disableAFKProtection()
    else
        AFKLib.enableAFKProtection()
    end
end

-- Voidware-Style GUI System
local function createVoidwareGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VoidwareGUI"
    screenGui.Parent = LocalPlayer.PlayerGui
    
    -- Main Frame (Voidware style)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 450, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
    mainFrame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Voidware-style corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Voidware-style title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Voidware Enhanced System"
    title.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = titleBar
    
    -- Private access indicator
    if isPrivateUser() then
        local privateLabel = Instance.new("TextLabel")
        privateLabel.Name = "PrivateLabel"
        privateLabel.Size = UDim2.new(0, 80, 0, 20)
        privateLabel.Position = UDim2.new(0, 15, 0, 30)
        privateLabel.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
        privateLabel.Text = "PRIVATE ACCESS"
        privateLabel.TextColor3 = Color3.new(1, 1, 1)
        privateLabel.TextScaled = true
        privateLabel.Font = Enum.Font.GothamBold
        privateLabel.Parent = titleBar
        
        local privateCorner = Instance.new("UICorner")
        privateCorner.CornerRadius = UDim.new(0, 4)
        privateCorner.Parent = privateLabel
    end
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Tab System
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = "TabFrame"
    tabFrame.Size = UDim2.new(1, 0, 0, 40)
    tabFrame.Position = UDim2.new(0, 0, 0, 40)
    tabFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    tabFrame.BorderSizePixel = 0
    tabFrame.Parent = mainFrame
    
    local tabs = {"Teleport", "Spawn", "Gems", "Flying", "Settings"}
    local currentTab = "Teleport"
    
    for i, tabName in pairs(tabs) do
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tabName .. "Tab"
        tabBtn.Size = UDim2.new(1/#tabs, 0, 1, 0)
        tabBtn.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
        tabBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        tabBtn.Text = tabName
        tabBtn.TextColor3 = Color3.new(1, 1, 1)
        tabBtn.TextScaled = true
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.Parent = tabFrame
        
        tabBtn.MouseButton1Click:Connect(function()
            currentTab = tabName
            updateTabContent()
        end)
    end
    
    -- Content Frame
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -10, 1, -90)
    contentFrame.Position = UDim2.new(0, 5, 0, 85)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 6
    contentFrame.Parent = mainFrame
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 5)
    contentLayout.Parent = contentFrame
    
    -- Position Selection System
    local selectedPosition = RootPart.Position
    local positionMarker = nil
    
    local function createPositionMarker(position)
        if positionMarker then
            positionMarker:Destroy()
        end
        
        positionMarker = Instance.new("Part")
        positionMarker.Name = "PositionMarker"
        positionMarker.Size = Vector3.new(2, 0.2, 2)
        positionMarker.Position = position
        positionMarker.Material = Enum.Material.Neon
        positionMarker.BrickColor = BrickColor.new("Bright blue")
        positionMarker.Anchored = true
        positionMarker.CanCollide = false
        positionMarker.Parent = Workspace
        
        local pointLight = Instance.new("PointLight")
        pointLight.Color = Color3.new(0, 0, 1)
        pointLight.Brightness = 2
        pointLight.Range = 10
        pointLight.Parent = positionMarker
    end
    
    local function updateTabContent()
        -- Clear existing content
        for _, child in pairs(contentFrame:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        if currentTab == "Teleport" then
            -- Teleport Section
            local teleportSection = Instance.new("Frame")
            teleportSection.Name = "TeleportSection"
            teleportSection.Size = UDim2.new(1, 0, 0, 200)
            teleportSection.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            teleportSection.BorderSizePixel = 0
            teleportSection.Parent = contentFrame
            
            local teleportCorner = Instance.new("UICorner")
            teleportCorner.CornerRadius = UDim.new(0, 6)
            teleportCorner.Parent = teleportSection
            
            local teleportLayout = Instance.new("UIListLayout")
            teleportLayout.SortOrder = Enum.SortOrder.LayoutOrder
            teleportLayout.Padding = UDim.new(0, 5)
            teleportLayout.Parent = teleportSection
            
            -- Position Selection
            local posLabel = Instance.new("TextLabel")
            posLabel.Name = "PosLabel"
            posLabel.Size = UDim2.new(1, -10, 0, 20)
            posLabel.Position = UDim2.new(0, 5, 0, 5)
            posLabel.BackgroundTransparency = 1
            posLabel.Text = "Position Selection:"
            posLabel.TextColor3 = Color3.new(1, 1, 1)
            posLabel.TextScaled = true
            posLabel.Font = Enum.Font.GothamBold
            posLabel.Parent = teleportSection
            
            local selectPosBtn = Instance.new("TextButton")
            selectPosBtn.Name = "SelectPosBtn"
            selectPosBtn.Size = UDim2.new(1, -10, 0, 30)
            selectPosBtn.Position = UDim2.new(0, 5, 0, 30)
            selectPosBtn.BackgroundColor3 = Color3.new(0.3, 0.5, 0.8)
            selectPosBtn.Text = "Click to Select Position"
            selectPosBtn.TextColor3 = Color3.new(1, 1, 1)
            selectPosBtn.TextScaled = true
            selectPosBtn.Font = Enum.Font.Gotham
            selectPosBtn.Parent = teleportSection
            
            local posCorner = Instance.new("UICorner")
            posCorner.CornerRadius = UDim.new(0, 4)
            posCorner.Parent = selectPosBtn
            
            selectPosBtn.MouseButton1Click:Connect(function()
                local hit = Mouse.Hit
                if hit then
                    selectedPosition = hit.Position
                    createPositionMarker(selectedPosition)
                    notify("Position", "Position selected: " .. tostring(selectedPosition), 2)
                end
            end)
            
            -- Teleport Buttons
            local teleportBtns = {
                {text = "Teleport to Selected Position", func = function() TeleportLib.teleportTo(selectedPosition) end},
                {text = "Teleport to Mouse", func = TeleportLib.teleportToMouse},
                {text = "Random Teleport", func = function() 
    local randomX = math.random(-500, 500)
    local randomZ = math.random(-500, 500)
                    TeleportLib.teleportTo(Vector3.new(randomX, 50, randomZ))
                end}
            }
            
            for i, btnData in pairs(teleportBtns) do
                local btn = Instance.new("TextButton")
                btn.Name = "TeleportBtn" .. i
                btn.Size = UDim2.new(1, -10, 0, 30)
                btn.Position = UDim2.new(0, 5, 0, 70 + (i-1) * 35)
                btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
                btn.Text = btnData.text
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.TextScaled = true
                btn.Font = Enum.Font.Gotham
                btn.Parent = teleportSection
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 4)
                btnCorner.Parent = btn
                
                btn.MouseButton1Click:Connect(btnData.func)
            end
            
        elseif currentTab == "Spawn" then
            -- Spawn Section
            local spawnSection = Instance.new("Frame")
            spawnSection.Name = "SpawnSection"
            spawnSection.Size = UDim2.new(1, 0, 0, 300)
            spawnSection.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            spawnSection.BorderSizePixel = 0
            spawnSection.Parent = contentFrame
            
            local spawnCorner = Instance.new("UICorner")
            spawnCorner.CornerRadius = UDim.new(0, 6)
            spawnCorner.Parent = spawnSection
            
            local spawnLayout = Instance.new("UIListLayout")
            spawnLayout.SortOrder = Enum.SortOrder.LayoutOrder
            spawnLayout.Padding = UDim.new(0, 5)
            spawnLayout.Parent = spawnSection
            
            -- Spawn Buttons
            local spawnBtns = {
                {text = "Spawn Object at Selected Position", func = function() SpawnLib.spawnObject("Custom Object", selectedPosition) end},
                {text = "Spawn Object at Mouse", func = function() SpawnLib.spawnAtMouse("Custom Object") end},
                {text = "Spawn Vehicle at Selected Position", func = function() SpawnLib.spawnVehicle("Car", selectedPosition) end},
                {text = "Spawn House at Selected Position", func = function() SpawnLib.spawnHouse(selectedPosition) end},
                {text = "Spawn Tower at Selected Position", func = function() SpawnLib.spawnTower(selectedPosition) end},
                {text = "Spawn Multiple Objects (5x5 Grid)", func = function()
                    for x = 1, 5 do
                        for z = 1, 5 do
                            SpawnLib.spawnObject("Grid Object " .. x .. "," .. z, selectedPosition + Vector3.new(x * 5, 0, z * 5))
                        end
                    end
                end}
            }
            
            for i, btnData in pairs(spawnBtns) do
                local btn = Instance.new("TextButton")
                btn.Name = "SpawnBtn" .. i
                btn.Size = UDim2.new(1, -10, 0, 30)
                btn.Position = UDim2.new(0, 5, 0, 5 + (i-1) * 35)
                btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
                btn.Text = btnData.text
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.TextScaled = true
                btn.Font = Enum.Font.Gotham
                btn.Parent = spawnSection
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 4)
                btnCorner.Parent = btn
                
                btn.MouseButton1Click:Connect(btnData.func)
            end
            
        elseif currentTab == "Gems" then
            -- Gems Section
            local gemsSection = Instance.new("Frame")
            gemsSection.Name = "GemsSection"
            gemsSection.Size = UDim2.new(1, 0, 0, 200)
            gemsSection.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            gemsSection.BorderSizePixel = 0
            gemsSection.Parent = contentFrame
            
            local gemsCorner = Instance.new("UICorner")
            gemsCorner.CornerRadius = UDim.new(0, 6)
            gemsCorner.Parent = gemsSection
            
            local gemsLayout = Instance.new("UIListLayout")
            gemsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            gemsLayout.Padding = UDim.new(0, 5)
            gemsLayout.Parent = gemsSection
            
            -- Gem Buttons
            local gemBtns = {
                {text = "Spawn Cultist Gem at Selected Position", func = function() GemLib.spawnCultistGem(selectedPosition) end},
                {text = "Spawn Forest Fragment at Selected Position", func = function() GemLib.spawnForestFragment(selectedPosition) end},
                {text = "Spawn Cultist Gem at Mouse", func = function() GemLib.spawnCultistGem(Mouse.Hit.Position + Vector3.new(0, 5, 0)) end},
                {text = "Spawn Forest Fragment at Mouse", func = function() GemLib.spawnForestFragment(Mouse.Hit.Position + Vector3.new(0, 5, 0)) end},
                {text = "Clear All Gems", func = GemLib.clearAllGems}
            }
            
            for i, btnData in pairs(gemBtns) do
                local btn = Instance.new("TextButton")
                btn.Name = "GemBtn" .. i
                btn.Size = UDim2.new(1, -10, 0, 30)
                btn.Position = UDim2.new(0, 5, 0, 5 + (i-1) * 35)
                btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
                btn.Text = btnData.text
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.TextScaled = true
                btn.Font = Enum.Font.Gotham
                btn.Parent = gemsSection
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 4)
                btnCorner.Parent = btn
                
                btn.MouseButton1Click:Connect(btnData.func)
            end
            
        elseif currentTab == "Flying" then
            -- Flying Section (Private feature)
            local flyingSection = Instance.new("Frame")
            flyingSection.Name = "FlyingSection"
            flyingSection.Size = UDim2.new(1, 0, 0, 250)
            flyingSection.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            flyingSection.BorderSizePixel = 0
            flyingSection.Parent = contentFrame
            
            local flyingCorner = Instance.new("UICorner")
            flyingCorner.CornerRadius = UDim.new(0, 6)
            flyingCorner.Parent = flyingSection
            
            local flyingLayout = Instance.new("UIListLayout")
            flyingLayout.SortOrder = Enum.SortOrder.LayoutOrder
            flyingLayout.Padding = UDim.new(0, 5)
            flyingLayout.Parent = flyingSection
            
            -- Flying Buttons
            local flyingBtns = {
                {text = "Toggle Flying (Private)", func = FlyLib.toggleFlying, color = Color3.new(0.8, 0.4, 0.2)},
                {text = "Set Fly Speed to 50", func = function() FlyLib.setFlySpeed(50) end, color = Color3.new(0.3, 0.3, 0.3)},
                {text = "Set Fly Speed to 100", func = function() FlyLib.setFlySpeed(100) end, color = Color3.new(0.3, 0.3, 0.3)},
                {text = "Set Fly Speed to 200", func = function() FlyLib.setFlySpeed(200) end, color = Color3.new(0.3, 0.3, 0.3)},
                {text = "Disable Flying", func = FlyLib.disableFlying, color = Color3.new(0.8, 0.2, 0.2)}
            }
            
            for i, btnData in pairs(flyingBtns) do
                local btn = Instance.new("TextButton")
                btn.Name = "FlyingBtn" .. i
                btn.Size = UDim2.new(1, -10, 0, 30)
                btn.Position = UDim2.new(0, 5, 0, 5 + (i-1) * 35)
                btn.BackgroundColor3 = btnData.color
                btn.Text = btnData.text
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.TextScaled = true
                btn.Font = Enum.Font.Gotham
                btn.Parent = flyingSection
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 4)
                btnCorner.Parent = btn
                
                btn.MouseButton1Click:Connect(btnData.func)
            end
            
        elseif currentTab == "Settings" then
            -- Settings Section
            local settingsSection = Instance.new("Frame")
            settingsSection.Name = "SettingsSection"
            settingsSection.Size = UDim2.new(1, 0, 0, 250)
            settingsSection.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            settingsSection.BorderSizePixel = 0
            settingsSection.Parent = contentFrame
            
            local settingsCorner = Instance.new("UICorner")
            settingsCorner.CornerRadius = UDim.new(0, 6)
            settingsCorner.Parent = settingsSection
            
            local settingsLayout = Instance.new("UIListLayout")
            settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            settingsLayout.Padding = UDim.new(0, 5)
            settingsLayout.Parent = settingsSection
            
            -- Settings Buttons
            local settingsBtns = {
                {text = "Toggle God Mode", func = InvincibilityLib.toggleInvincibility, color = Color3.new(0.8, 0.2, 0.2)},
                {text = "Toggle Chunk Loading", func = ChunkLib.toggleChunkLoading, color = Color3.new(0.2, 0.6, 0.8)},
                {text = "Toggle AFK Protection", func = AFKLib.toggleAFKProtection, color = Color3.new(0.2, 0.4, 0.8)},
                {text = "Full Heal", func = function() InvincibilityLib.setHealth(Humanoid.MaxHealth) end, color = Color3.new(0.2, 0.8, 0.2)},
                {text = "Enable Regeneration", func = function() InvincibilityLib.enableRegeneration(5) end, color = Color3.new(0.3, 0.3, 0.3)},
                {text = "Set Speed to 100", func = function() InvincibilityLib.setSpeed(100) end, color = Color3.new(0.3, 0.3, 0.3)},
                {text = "Set Jump Power to 200", func = function() InvincibilityLib.setJumpPower(200) end, color = Color3.new(0.3, 0.3, 0.3)}
            }
            
            for i, btnData in pairs(settingsBtns) do
                local btn = Instance.new("TextButton")
                btn.Name = "SettingsBtn" .. i
                btn.Size = UDim2.new(1, -10, 0, 30)
                btn.Position = UDim2.new(0, 5, 0, 5 + (i-1) * 35)
                btn.BackgroundColor3 = btnData.color
                btn.Text = btnData.text
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.TextScaled = true
                btn.Font = Enum.Font.Gotham
                btn.Parent = settingsSection
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 4)
                btnCorner.Parent = btn
                
                btn.MouseButton1Click:Connect(btnData.func)
            end
        end
    end
    
    -- Initialize with first tab
    updateTabContent()
    
    return screenGui
end

-- Initialize the script
notify("Enhanced Script", "Modern GUI system loaded successfully!", 3)

-- Setup automatic invincibility
setupInvincibility()

-- Auto-enable essential features
task.wait(1)
InvincibilityLib.enableInvincibility()

-- Create Voidware-style GUI
local gui = createVoidwareGUI()

-- Export functions globally for easy access
_G.TeleportLib = TeleportLib
_G.SpawnLib = SpawnLib
_G.InvincibilityLib = InvincibilityLib
_G.ChunkLib = ChunkLib
_G.GemLib = GemLib
_G.AFKLib = AFKLib
_G.FlyLib = FlyLib

-- Quick access commands
_G.teleport = TeleportLib.teleportTo
_G.spawn = SpawnLib.spawnObject
_G.spawnAtMouse = SpawnLib.spawnAtMouse
_G.spawnVehicle = SpawnLib.spawnVehicle
_G.spawnHouse = SpawnLib.spawnHouse
_G.spawnTower = SpawnLib.spawnTower
_G.god = InvincibilityLib.enableInvincibility
_G.ungod = InvincibilityLib.disableInvincibility
_G.toggleGod = InvincibilityLib.toggleInvincibility
_G.heal = function() InvincibilityLib.setHealth(Humanoid.MaxHealth) end
_G.chunks = ChunkLib.enableChunkLoading
_G.nochunks = ChunkLib.disableChunkLoading
_G.toggleChunks = ChunkLib.toggleChunkLoading
_G.cultistGem = GemLib.spawnCultistGem
_G.forestFragment = GemLib.spawnForestFragment
_G.clearGems = GemLib.clearAllGems
_G.afk = AFKLib.enableAFKProtection
_G.noafk = AFKLib.disableAFKProtection
_G.toggleAFK = AFKLib.toggleAFKProtection

-- Flying commands (Private access)
_G.fly = FlyLib.enableFlying
_G.nofly = FlyLib.disableFlying
_G.toggleFly = FlyLib.toggleFlying
_G.flySpeed = FlyLib.setFlySpeed

notify("Voidware System Ready", "Private access granted! Use _G.fly(), _G.spawnAtMouse(), _G.teleport(), etc. | Voidware GUI loaded!", 5)