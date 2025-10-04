-- Basic Example Script
-- Simple example showing how to use the utility scripts

-- Load utility scripts (in a real scenario, these would be loaded from files)
-- loadstring(game:HttpGet("path/to/god-mode.lua"))()
-- loadstring(game:HttpGet("path/to/teleport-utils.lua"))()
-- loadstring(game:HttpGet("path/to/spawn-utils.lua"))()

-- Example usage:
print("=== Basic Example Script ===")
print("This script demonstrates basic usage of the utility functions")
print("")

-- Example 1: Enable god mode
print("1. Enabling god mode...")
-- _G.god() -- Uncomment to actually enable

-- Example 2: Teleport to a position
print("2. Teleporting to position (0, 50, 0)...")
-- _G.teleport(Vector3.new(0, 50, 0)) -- Uncomment to actually teleport

-- Example 3: Spawn an object
print("3. Spawning a test object...")
-- _G.spawn("Test Object", Vector3.new(0, 10, 0)) -- Uncomment to actually spawn

-- Example 4: Spawn a vehicle
print("4. Spawning a car...")
-- _G.spawnVehicle("Car", Vector3.new(10, 5, 0)) -- Uncomment to actually spawn

-- Example 5: Spawn an NPC
print("5. Spawning an NPC...")
-- _G.spawnNPC("Friendly NPC", Vector3.new(-10, 5, 0)) -- Uncomment to actually spawn

print("")
print("=== Example completed ===")
print("Uncomment the lines above to actually execute the functions")
