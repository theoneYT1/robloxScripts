-- Enhanced Voidware Game Loader Script
-- This script loads game-specific cheat scripts for supported Roblox games
-- Now includes advanced spawning and teleportation features

repeat task.wait() until game:IsLoaded()

-- Enhanced notification system
local function sendNotification(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 5
    })
end

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
    sendNotification("Voidware | Loader", "Unsupported game :c", 15)
    return
else
    sendNotification("Voidware | Loader", "Loading for "..tostring(data.title).."...", 15)
    
    local res
    if shared.VoidDev and data.dev ~= nil and pcall(function() return isfile(data.dev) end) then
        res = loadstring(readfile(data.dev))
    else
        res = loadstring(game:HttpGet(data.script, true))
    end
    
    if type(res) ~= "function" then
        sendNotification("Voidware Loading Error", tostring(res), 15)
        task.delay(0.5, function()
            if shared.VoidDev then return end
            sendNotification("Voidware Loading Error", "Please report this issue to erchodev#0 \n or in discord.gg/voidware", 15)
        end)
    else
        local suc, err = pcall(res)
        if not suc then
            sendNotification("Voidware Main Error", tostring(err), 15)
            task.delay(0.5, function()
                if shared.VoidDev then return end
                sendNotification("Voidware Main Error", "Please report this issue to erchodev#0 \n or in discord.gg/voidware", 15)
            end)
        else
            -- Load additional spawning and teleportation features
            task.wait(1)
            loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/spawn_teleport.lua", true))()
            sendNotification("Voidware Enhanced", "Spawn & Teleport features loaded!", 3)
        end
    end
end
