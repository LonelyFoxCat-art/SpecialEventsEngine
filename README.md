# Special Events Engine

## Project Overview  
The Special Events Engine is a game framework or engine developed using GameMaker Studio, offering a rich set of modular features for creating games with complex interactions and animation effects.

## Features  

### Core Systems  
- **Battle System**: Features a board-based combat mechanism with support for sophisticated battle logic and animated effects.  
- **Input Management System**: Provides flexible input detection and customizable input handling.  
- **Camera Control System**: Supports various camera effects, including screen shake, full-screen transitions, and more.

### Data Structures & Algorithms  
- **Queue System**: Full-featured queue data structure operations.  
- **Timer System**: Flexible time management and scheduling functionality.  
- **Math Library**: Extended mathematical utilities including vector operations, matrix transformations, trigonometric functions, etc.  
- **Geometric Algorithms**: Includes collision detection, shape rendering, spatial transformations, and other geometry-related functions.

### Animation & Visual Effects  
- **Advanced Animation System**: Supports Bezier curve animations and custom animation paths.  
- **Shader Effects**: Multiple visual effects such as mirror symmetry, hand-drawn style, blur, fog, and more.

### Game Mechanics  
- **Player System**: Manages character attributes such as attack, defense, HP, speed, and others.  
- **Buff/Debuff System**: Customizable status effect (buff/debuff) mechanics.  
- **Encounter System**: Supports both random and scripted encounter events.  
- **Localization**: Multi-language support with easy language switching.

## Directory Structure  
```
SpecialEventsEngine/
├── datafiles/          # Data files, including fonts and other assets
├── fonts/              # Font resources
├── notes/              # Project documentation and notes
├── objects/            # Game objects
│   ├── battle/         # Battle-related objects
│   ├── battle_board/   # Battle board objects
│   ├── battle_board_draw/ # Battle board rendering objects
│   ├── battle_soul/    # Battle soul objects
│   ├── main/           # Main game objects
│   ├── obj_player/     # Player character objects
│   └── ui_menu/        # UI menu objects
├── options/            # Platform-specific configuration options
├── rooms/              # Game rooms (scenes)
├── scripts/            # Script files
├── shaders/            # Shader files
└── sprites/            # Sprite assets
```

## Installation & Usage  
1. Import the project files into GameMaker Studio.  
2. Open the `SpecialEventsEngine.yyp` project file.  
3. Modify configurations and code as needed.  
4. Compile and run the project.

## Contributions  
Issues and Pull Requests are welcome to help improve this project.
