-- Dual Loader System (VapeVoidware + FlashHub 99Nights ONLY)
repeat task.wait() until game:IsLoaded()

-- Load VapeVoidware
loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/loader.lua", true))()

-- Load FlashHub 99Nights
loadstring(game:HttpGet("https://raw.githubusercontent.com/scripture2025/FlashHub/refs/heads/main/99Nights"))()