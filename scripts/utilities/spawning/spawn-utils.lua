-- Spawning Utility Script
-- Simple spawning functions for Roblox games

local Players = game:GetService("Players")
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

-- Spawn basic object
local function spawnObject(objectName, position, properties)
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
    
    object.Parent = workspace
    notify("Spawn", "Spawned " .. objectName, 2)
    return object
end

-- Spawn vehicle
local function spawnVehicle(vehicleType, position)
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
    
    vehicle.Parent = workspace
    notify("Spawn", "Spawned " .. vehicleType .. " vehicle", 2)
    return vehicle
end

-- Spawn NPC
local function spawnNPC(npcName, position)
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
    
    npc.Parent = workspace
    notify("Spawn", "Spawned NPC: " .. npcName, 2)
    return npc
end

-- Export functions
_G.spawn = spawnObject
_G.spawnVehicle = spawnVehicle
_G.spawnNPC = spawnNPC

notify("Spawning Utility", "Spawning utility loaded! Use _G.spawn(), _G.spawnVehicle(), _G.spawnNPC()", 5)
