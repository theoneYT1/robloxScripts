# Roblox Scripts Collection

A comprehensive collection of Roblox Lua scripts for various games and utilities.

## 📁 Project Structure

```
robloxScripts/
├── scripts/
│   ├── game-specific/
│   │   ├── 99-nights/
│   │   │   └── main-script.lua
│   │   └── voidware/
│   │       └── loader.lua
│   ├── utilities/
│   │   ├── spawning/
│   │   ├── teleportation/
│   │   └── invincibility/
│   └── examples/
├── docs/
│   └── documentation.md
└── README.md
```

## 🎮 Supported Games

### 99 Nights in the Forest
- **Main Script**: Enhanced spawning, teleportation & invincibility script
- **Features**:
  - Advanced invincibility system with health protection
  - Chunk loading system for better performance
  - Gem spawning (Cultist Gems & Forest Fragments)
  - AFK protection with movement simulation
  - Teleportation utilities
  - GUI interface for easy control

### Voidware Loader
- **Supported Games**:
  - Bedwars (ID: 2619619496)
  - Ink Game (ID: 7008097940)
  - Forsaken (ID: 6331902150)
  - 99 Nights In The Forest (ID: 7326934954)

## 🚀 Features

### Main Script Features
- **Invincibility System**: Complete god mode with health protection
- **Chunk Loading**: Automatic chunk loading for better game performance
- **Gem Spawning**: Spawn Cultist Gems and Forest Fragments
- **AFK Protection**: Anti-idle system with movement simulation
- **Teleportation**: Advanced teleportation with smooth transitions
- **Spawning System**: Spawn objects, vehicles, NPCs, and structures
- **GUI Interface**: User-friendly interface for all features

### Quick Commands
```lua
-- Invincibility
_G.god()           -- Enable god mode
_G.ungod()         -- Disable god mode
_G.toggleGod()     -- Toggle god mode
_G.heal()          -- Full heal
_G.regen()         -- Enable regeneration

-- Teleportation
_G.teleport(pos)   -- Teleport to position
_G.randomTeleport() -- Random teleport

-- Spawning
_G.spawn()         -- Spawn object
_G.spawnVehicle()  -- Spawn vehicle
_G.spawnNPC()      -- Spawn NPC

-- Chunk Loading
_G.chunks()        -- Enable chunk loading
_G.nochunks()      -- Disable chunk loading
_G.loadAllChunks() -- Load all chunks

-- Gem Spawning
_G.cultistGem()    -- Spawn cultist gem
_G.forestFragment() -- Spawn forest fragment
_G.spawnGems()     -- Spawn multiple gems

-- AFK Protection
_G.afk()           -- Enable AFK protection
_G.noafk()         -- Disable AFK protection
_G.aggressiveAFK() -- Aggressive AFK protection
```

## 📖 Usage

### For 99 Nights in the Forest
1. Load the main script (`scripts/game-specific/99-nights/main-script.lua`)
2. Use the GUI interface or console commands
3. All features are automatically enabled on script start

### For Voidware Loader
1. Load the voidware loader (`scripts/game-specific/voidware/loader.lua`)
2. The script will automatically detect the game and load appropriate features
3. Supported games will show a notification with the loaded features

## 🛠️ Installation

1. Copy the desired script from the repository
2. Load it in your Roblox executor
3. Follow the on-screen instructions

## ⚠️ Disclaimer

These scripts are for educational purposes only. Use at your own risk. The authors are not responsible for any consequences of using these scripts.

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

If you encounter any issues or have questions:
- Create an issue in this repository
- Check the documentation in the `docs/` folder

## 🔄 Updates

This repository is actively maintained. Check back regularly for updates and new features.

---

**Note**: Always ensure you have permission to use scripts in the games you're playing. Respect the game's terms of service and community guidelines.
