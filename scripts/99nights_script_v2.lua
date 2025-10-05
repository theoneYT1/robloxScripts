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

-- Invincibility System (ULTRA EFFECTIVE - Fixed)
local InvincibilityLib = {}
local isInvincible = false
local originalHealth = 100
local protectionConnections = {}
local forceField = nil

local function setupInvincibility()
    if not Character or not Humanoid then return end
    
    originalHealth = Humanoid.MaxHealth
    
    -- Ultra-fast health protection
    local healthProtectionConnection
    healthProtectionConnection = RunService.Heartbeat:Connect(function()
        if isInvincible and Humanoid then
            Humanoid.MaxHealth = math.huge
            Humanoid.Health = math.huge
        end
    end)
    table.insert(protectionConnections, healthProtectionConnection)
    
    -- Additional health protection
    Humanoid.HealthChanged:Connect(function(health)
        if isInvincible and Humanoid then
            Humanoid.Health = math.huge
            Humanoid.MaxHealth = math.huge
        end
    end)
end

function InvincibilityLib.enableInvincibility()
    isInvincible = true
    
    -- Method 1: Set health to infinite
    if Humanoid then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
        Humanoid.WalkSpeed = 50
        Humanoid.JumpPower = 100
    end
    
    -- Method 2: Create ForceField
    if Character then
        forceField = Instance.new("ForceField")
        forceField.Parent = Character
    end
    
    -- Method 3: Ultra-fast protection loop
    spawn(function()
        while isInvincible do
            if Humanoid then
                Humanoid.Health = math.huge
                Humanoid.MaxHealth = math.huge
            end
            wait(0.01)
        end
    end)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Invincibility",
        Text = "ULTRA God mode activated!",
        Duration = 3
    })
end

function InvincibilityLib.disableInvincibility()
    isInvincible = false
    
    if Humanoid then
        Humanoid.MaxHealth = originalHealth
        Humanoid.Health = originalHealth
    end
    
    -- Remove ForceField
    if forceField then
        forceField:Destroy()
        forceField = nil
    end
    
    -- Remove all ForceFields
    for _, child in pairs(Character:GetChildren()) do
        if child:IsA("ForceField") then
            child:Destroy()
        end
    end
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Invincibility",
        Text = "God mode deactivated!",
        Duration = 3
    })
end

function InvincibilityLib.toggleInvincibility()
    if isInvincible then
        InvincibilityLib.disableInvincibility()
    else
        InvincibilityLib.enableInvincibility()
    end
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

-- Setup invincibility system
setupInvincibility()

-- Auto-enable all features
task.wait(1)
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

-- Enhanced GUI System with Invincibility Tab
local function createEnhancedGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "EnhancedVoidwareGUI"
    screenGui.Parent = LocalPlayer.PlayerGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Title Bar
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
    title.Text = "Enhanced Voidware System"
    title.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = titleBar
    
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
    
    local tabs = {"Invincibility", "AFK", "Chunks", "Settings"}
    local currentTab = "Invincibility"
    
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
    
    -- Update tab content function
    function updateTabContent()
        -- Clear existing content
        for _, child in pairs(contentFrame:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        if currentTab == "Invincibility" then
            -- Invincibility Tab
            local invincibilitySection = Instance.new("Frame")
            invincibilitySection.Name = "InvincibilitySection"
            invincibilitySection.Size = UDim2.new(1, -10, 0, 200)
            invincibilitySection.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
            invincibilitySection.Parent = contentFrame
            
            local invincibilityCorner = Instance.new("UICorner")
            invincibilityCorner.CornerRadius = UDim.new(0, 8)
            invincibilityCorner.Parent = invincibilitySection
            
            local invincibilityTitle = Instance.new("TextLabel")
            invincibilityTitle.Name = "InvincibilityTitle"
            invincibilityTitle.Size = UDim2.new(1, 0, 0, 30)
            invincibilityTitle.Position = UDim2.new(0, 0, 0, 0)
            invincibilityTitle.BackgroundTransparency = 1
            invincibilityTitle.Text = "Invincibility Controls"
            invincibilityTitle.TextColor3 = Color3.new(1, 1, 1)
            invincibilityTitle.TextScaled = true
            invincibilityTitle.Font = Enum.Font.GothamBold
            invincibilityTitle.Parent = invincibilitySection
            
            -- Toggle Button
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Name = "ToggleBtn"
            toggleBtn.Size = UDim2.new(1, -20, 0, 40)
            toggleBtn.Position = UDim2.new(0, 10, 0, 40)
            toggleBtn.BackgroundColor3 = isInvincible and Color3.new(0.2, 0.8, 0.2) or Color3.new(0.8, 0.2, 0.2)
            toggleBtn.Text = isInvincible and "Disable Invincibility" or "Enable Invincibility"
            toggleBtn.TextColor3 = Color3.new(1, 1, 1)
            toggleBtn.TextScaled = true
            toggleBtn.Font = Enum.Font.Gotham
            toggleBtn.Parent = invincibilitySection
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 6)
            toggleCorner.Parent = toggleBtn
            
            toggleBtn.MouseButton1Click:Connect(function()
                InvincibilityLib.toggleInvincibility()
                -- Update button appearance
                toggleBtn.BackgroundColor3 = isInvincible and Color3.new(0.2, 0.8, 0.2) or Color3.new(0.8, 0.2, 0.2)
                toggleBtn.Text = isInvincible and "Disable Invincibility" or "Enable Invincibility"
                -- Update status label
                statusLabel.Text = "Status: " .. (isInvincible and "ENABLED" or "DISABLED")
                statusLabel.TextColor3 = isInvincible and Color3.new(0.2, 0.8, 0.2) or Color3.new(0.8, 0.2, 0.2)
            end)
            
            -- Status Label
            local statusLabel = Instance.new("TextLabel")
            statusLabel.Name = "StatusLabel"
            statusLabel.Size = UDim2.new(1, -20, 0, 30)
            statusLabel.Position = UDim2.new(0, 10, 0, 90)
            statusLabel.BackgroundTransparency = 1
            statusLabel.Text = "Status: " .. (isInvincible and "ENABLED" or "DISABLED")
            statusLabel.TextColor3 = isInvincible and Color3.new(0.2, 0.8, 0.2) or Color3.new(0.8, 0.2, 0.2)
            statusLabel.TextScaled = true
            statusLabel.Font = Enum.Font.Gotham
            statusLabel.Parent = invincibilitySection
            
        elseif currentTab == "AFK" then
            -- AFK Tab
            local afkSection = Instance.new("Frame")
            afkSection.Name = "AFKSection"
            afkSection.Size = UDim2.new(1, -10, 0, 150)
            afkSection.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
            afkSection.Parent = contentFrame
            
            local afkCorner = Instance.new("UICorner")
            afkCorner.CornerRadius = UDim.new(0, 8)
            afkCorner.Parent = afkSection
            
            local afkTitle = Instance.new("TextLabel")
            afkTitle.Name = "AFKTitle"
            afkTitle.Size = UDim2.new(1, 0, 0, 30)
            afkTitle.Position = UDim2.new(0, 0, 0, 0)
            afkTitle.BackgroundTransparency = 1
            afkTitle.Text = "AFK Protection: " .. (isAFKEnabled and "ENABLED" or "DISABLED")
            afkTitle.TextColor3 = isAFKEnabled and Color3.new(0.2, 0.8, 0.2) or Color3.new(0.8, 0.2, 0.2)
            afkTitle.TextScaled = true
            afkTitle.Font = Enum.Font.GothamBold
            afkTitle.Parent = afkSection
            
        elseif currentTab == "Chunks" then
            -- Chunks Tab
            local chunksSection = Instance.new("Frame")
            chunksSection.Name = "ChunksSection"
            chunksSection.Size = UDim2.new(1, -10, 0, 150)
            chunksSection.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
            chunksSection.Parent = contentFrame
            
            local chunksCorner = Instance.new("UICorner")
            chunksCorner.CornerRadius = UDim.new(0, 8)
            chunksCorner.Parent = chunksSection
            
            local chunksTitle = Instance.new("TextLabel")
            chunksTitle.Name = "ChunksTitle"
            chunksTitle.Size = UDim2.new(1, 0, 0, 30)
            chunksTitle.Position = UDim2.new(0, 0, 0, 0)
            chunksTitle.BackgroundTransparency = 1
            chunksTitle.Text = "Chunk Loading: " .. (isChunkLoadingEnabled and "ENABLED" or "DISABLED")
            chunksTitle.TextColor3 = isChunkLoadingEnabled and Color3.new(0.2, 0.8, 0.2) or Color3.new(0.8, 0.2, 0.2)
            chunksTitle.TextScaled = true
            chunksTitle.Font = Enum.Font.GothamBold
            chunksTitle.Parent = chunksSection
            
        elseif currentTab == "Settings" then
            -- Settings Tab
            local settingsSection = Instance.new("Frame")
            settingsSection.Name = "SettingsSection"
            settingsSection.Size = UDim2.new(1, -10, 0, 200)
            settingsSection.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
            settingsSection.Parent = contentFrame
            
            local settingsCorner = Instance.new("UICorner")
            settingsCorner.CornerRadius = UDim.new(0, 8)
            settingsCorner.Parent = settingsSection
            
            local settingsTitle = Instance.new("TextLabel")
            settingsTitle.Name = "SettingsTitle"
            settingsTitle.Size = UDim2.new(1, 0, 0, 30)
            settingsTitle.Position = UDim2.new(0, 0, 0, 0)
            settingsTitle.BackgroundTransparency = 1
            settingsTitle.Text = "Script Settings"
            settingsTitle.TextColor3 = Color3.new(1, 1, 1)
            settingsTitle.TextScaled = true
            settingsTitle.Font = Enum.Font.GothamBold
            settingsTitle.Parent = settingsSection
            
            local infoLabel = Instance.new("TextLabel")
            infoLabel.Name = "InfoLabel"
            infoLabel.Size = UDim2.new(1, -20, 0, 100)
            infoLabel.Position = UDim2.new(0, 10, 0, 40)
            infoLabel.BackgroundTransparency = 1
            infoLabel.Text = "Enhanced Voidware System\n\nFeatures:\n• Invincibility Toggle\n• AFK Protection\n• Chunk Loading\n• Auto-Enabled Features"
            infoLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
            infoLabel.TextScaled = true
            infoLabel.Font = Enum.Font.Gotham
            infoLabel.Parent = settingsSection
        end
    end
    
    -- Initialize with first tab
    updateTabContent()
    
    return screenGui
end

-- Create the enhanced GUI
task.wait(2)
local gui = createEnhancedGUI()