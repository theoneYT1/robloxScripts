# Roblox Scripts Documentation

## Overview

This repository contains a collection of Roblox Lua scripts for various games and utilities. The scripts are organized into different categories based on their functionality.

## Script Categories

### 1. Game-Specific Scripts

#### 99 Nights in the Forest
- **Location**: `scripts/game-specific/99-nights/`
- **Main Script**: `main-script.lua` - Comprehensive script with spawning, teleportation, invincibility, and more
- **Features**:
  - Advanced invincibility system
  - Chunk loading for performance
  - Gem spawning (Cultist Gems & Forest Fragments)
  - AFK protection
  - GUI interface

#### Voidware Loader
- **Location**: `scripts/game-specific/voidware/`
- **Loader Script**: `loader.lua` - Auto-detects games and loads appropriate scripts
- **Supported Games**:
  - Bedwars (ID: 2619619496)
  - Ink Game (ID: 7008097940)
  - Forsaken (ID: 6331902150)
  - 99 Nights In The Forest (ID: 7326934954)

### 2. Utility Scripts

#### Invincibility Utilities
- **Location**: `scripts/utilities/invincibility/`
- **Scripts**:
  - `god-mode.lua` - Simple god mode script

#### Teleportation Utilities
- **Location**: `scripts/utilities/teleportation/`
- **Scripts**:
  - `teleport-utils.lua` - Basic teleportation functions

#### Spawning Utilities
- **Location**: `scripts/utilities/spawning/`
- **Scripts**:
  - `spawn-utils.lua` - Object, vehicle, and NPC spawning functions

### 3. Example Scripts
- **Location**: `scripts/examples/`
- **Scripts**:
  - `basic-example.lua` - Example showing how to use utility functions

## Usage Instructions

### Loading Scripts

1. **Individual Scripts**: Load any script directly in your Roblox executor
2. **Game-Specific**: Use the appropriate game-specific script for your game
3. **Utilities**: Load utility scripts for specific functionality
4. **Examples**: Use example scripts as templates for your own scripts

### Common Functions

#### God Mode Functions
```lua
_G.god()        -- Enable god mode
_G.ungod()      -- Disable god mode
_G.toggleGod()  -- Toggle god mode
```

#### Teleportation Functions
```lua
_G.teleport(position)           -- Teleport to position
_G.teleportToPlayer(name)       -- Teleport to player
_G.smoothTeleport(pos, time)    -- Smooth teleportation
_G.randomTeleport()             -- Random teleportation
```

#### Spawning Functions
```lua
_G.spawn(name, pos, props)      -- Spawn object
_G.spawnVehicle(type, pos)      -- Spawn vehicle
_G.spawnNPC(name, pos)          -- Spawn NPC
```

## Advanced Features

### 99 Nights Main Script Features

#### Invincibility System
- Complete health protection
- Forcefield generation
- Fall damage prevention
- Auto-heal when low health
- Regeneration system

#### Chunk Loading
- Automatic chunk loading around players
- Performance optimization
- Configurable chunk size
- Force load specific areas

#### Gem Spawning
- Cultist Gem spawning with animations
- Forest Fragment spawning
- Pattern-based spawning (circle, line, grid)
- Gem detection and teleportation

#### AFK Protection
- Movement simulation
- Mouse movement simulation
- Keyboard input simulation
- Character activity simulation
- Aggressive AFK mode

#### GUI Interface
- User-friendly interface
- Toggle buttons for all features
- Status indicators
- Quick access to all functions

## Troubleshooting

### Common Issues

1. **Script Not Loading**
   - Ensure you're using a compatible executor
   - Check for syntax errors in the script
   - Verify the script is for the correct game

2. **Features Not Working**
   - Check if the game is supported
   - Ensure all dependencies are loaded
   - Try reloading the script

3. **Performance Issues**
   - Disable chunk loading if not needed
   - Reduce the number of spawned objects
   - Use the cleanup functions

### Error Messages

- **"Unsupported game"**: The game you're playing is not supported by the loader
- **"Player not found"**: The target player is not in the game or hasn't loaded
- **"Object not found"**: The target object doesn't exist in the workspace

## Contributing

### Adding New Scripts

1. Create a new file in the appropriate directory
2. Follow the existing code structure
3. Add proper documentation
4. Test the script thoroughly
5. Submit a pull request

### Code Standards

- Use clear, descriptive variable names
- Add comments for complex functions
- Include error handling
- Follow Lua best practices
- Add notification feedback for user actions

## License

This project is open source and available under the MIT License. See the LICENSE file for details.

## Support

For support and questions:
- Create an issue in this repository
- Check the documentation
- Review the example scripts
- Test with the basic example first

## Updates

This repository is actively maintained. Check back regularly for:
- New game support
- Bug fixes
- Performance improvements
- New features and utilities
