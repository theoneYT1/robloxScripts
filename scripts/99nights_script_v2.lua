-- Dual Loader System (VapeVoidware + 99daysloader ONLY)
repeat task.wait() until game:IsLoaded()

-- Load VapeVoidware
loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/loader.lua", true))()

-- Load 99daysloader
loadstring(game:HttpGet("https://raw.githubusercontent.com/wefwef127382/99daysloader.github.io/refs/heads/main/ringta.lua"))()