{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # C/C++ development
    gcc
    gdb
    cmake
    make
    pkg-config
    
    # Raylib ecosystem
    raylib
    raygui
    
    # VSCode și extensii utile
    vscode-with-extensions
    
    # Tools utile pentru development
    git
    clang-tools  # pentru clangd, clang-format
    valgrind     # memory debugging
    strace       # system call tracing
  ];
  
  # Script de setup care se rulează când intri în shell
  shellHook = ''
    # Culori pentru output
    GREEN='\033[0;32m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
    
    echo -e "🚀 ${GREEN}C++ Development Environment cu Raylib${NC}"
    echo -e "📁 Project directory: $(pwd)"
    
    # Creează directoarele necesare
    mkdir -p .vscode include src build
    
    # Setează environment variables pentru include paths
    export RAYLIB_PATH="${pkgs.raylib}"
    export RAYGUI_PATH="${pkgs.raygui}"
    export C_INCLUDE_PATH="$RAYLIB_PATH/include:$RAYGUI_PATH/include:$C_INCLUDE_PATH"
    export CPLUS_INCLUDE_PATH="$C_INCLUDE_PATH"
    export LIBRARY_PATH="$RAYLIB_PATH/lib:$LIBRARY_PATH"
    export PKG_CONFIG_PATH="$RAYLIB_PATH/lib/pkgconfig:$PKG_CONFIG_PATH"
    
    # Fix raygui headers local
    if [ ! -f "./include/raygui.h" ]; then
      echo -e "🔧 ${BLUE}Copying și fixing raygui headers...${NC}"
      cp $RAYGUI_PATH/include/raygui.h ./include/
      
      # Fix enum comparison warnings
      sed -i 's/property < DEFAULT_PROPS_COUNT/(int)property < (int)DEFAULT_PROPS_COUNT/g' ./include/raygui.h
      sed -i 's/property >= DEFAULT_PROPS_COUNT/(int)property >= (int)DEFAULT_PROPS_COUNT/g' ./include/raygui.h
      sed -i 's/property == DEFAULT_PROPS_COUNT/(int)property == (int)DEFAULT_PROPS_COUNT/g' ./include/raygui.h
      
      echo -e "✅ ${GREEN}raygui.h fixed!${NC}"
    fi
    
    # Generează c_cpp_properties.json
    if [ ! -f ".vscode/c_cpp_properties.json" ]; then
      echo -e "⚙️  ${BLUE}Creating VSCode C++ configuration...${NC}"
      cat > .vscode/c_cpp_properties.json << 'EOF'
{
    "configurations": [
        {
            "name": "Linux-Nix",
            "includePath": [
                "''${workspaceFolder}/**",
                "''${workspaceFolder}/include",
                "''${env:RAYLIB_PATH}/include",
                "''${env:C_INCLUDE_PATH}"
            ],
            "defines": [
                "PLATFORM_DESKTOP"
            ],
            "compilerPath": "''${env:CC:-gcc}",
            "cStandard": "c17",
            "cppStandard": "c++20",
            "intelliSenseMode": "linux-gcc-x64",
            "compilerArgs": [
                "-Wno-enum-compare",
                "-Wall",
                "-Wextra"
            ]
        }
    ],
    "version": 4
}
EOF
    fi
    
    # Generează settings.json pentru VSCode
    if [ ! -f ".vscode/settings.json" ]; then
      cat > .vscode/settings.json << 'EOF'
{
    "C_Cpp.errorSquiggles": "EnabledIfIncludesResolve",
    "C_Cpp.default.compilerArgs": [
        "-Wno-enum-compare"
    ],
    "C_Cpp.default.cppStandard": "c++20",
    "C_Cpp.default.cStandard": "c17",
    "files.associations": {
        "*.h": "c",
        "*.hpp": "cpp"
    },
    "problems.excludeFiles": [
        "**/nix/store/**"
    ],
    "C_Cpp.loggingLevel": "Warning"
}
EOF
    fi
    
    # Generează tasks.json pentru build
    if [ ! -f ".vscode/tasks.json" ]; then
      cat > .vscode/tasks.json << 'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "build-debug",
            "type": "shell",
            "command": "gcc",
            "args": [
                "-g",
                "-Wall",
                "-Wno-enum-compare",
                "-I./include",
                "-I''${env:RAYLIB_PATH}/include",
                "src/*.c",
                "src/*.cpp",
                "-L''${env:RAYLIB_PATH}/lib",
                "-lraylib",
                "-lGL",
                "-lm",
                "-lpthread",
                "-ldl",
                "-lrt",
                "-lX11",
                "-o",
                "build/game"
            ],
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "problemMatcher": ["$gcc"],
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            }
        },
        {
            "label": "build-release",
            "type": "shell",
            "command": "gcc",
            "args": [
                "-O2",
                "-DNDEBUG",
                "-Wall",
                "-Wno-enum-compare",
                "-I./include",
                "-I''${env:RAYLIB_PATH}/include",
                "src/*.c",
                "src/*.cpp",
                "-L''${env:RAYLIB_PATH}/lib",
                "-lraylib",
                "-lGL",
                "-lm",
                "-lpthread",
                "-ldl",
                "-lrt",
                "-lX11",
                "-o",
                "build/game"
            ],
            "group": "build",
            "problemMatcher": ["$gcc"]
        },
        {
            "label": "run",
            "type": "shell",
            "command": "./build/game",
            "group": "test",
            "dependsOn": "build-debug"
        }
    ]
}
EOF
    fi
    
    # Generează Makefile simplu
    if [ ! -f "Makefile" ]; then
      cat > Makefile << 'EOF'
# Makefile pentru proiecte Raylib
CC = gcc
CFLAGS = -Wall -Wno-enum-compare -std=c17
CPPFLAGS = -I./include -I$(RAYLIB_PATH)/include
LDFLAGS = -L$(RAYLIB_PATH)/lib
LDLIBS = -lraylib -lGL -lm -lpthread -ldl -lrt -lX11

# Directoare
SRCDIR = src
BUILDDIR = build
SOURCES = $(wildcard $(SRCDIR)/*.c) $(wildcard $(SRCDIR)/*.cpp)
TARGET = $(BUILDDIR)/game

# Build debug
debug: CFLAGS += -g -DDEBUG
debug: $(TARGET)

# Build release  
release: CFLAGS += -O2 -DNDEBUG
release: $(TARGET)

$(TARGET): $(SOURCES) | $(BUILDDIR)
	$(CC) $(CFLAGS) $(CPPFLAGS) $(SOURCES) $(LDFLAGS) $(LDLIBS) -o $@

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

# Template pentru main.c
template:
	@if [ ! -f "$(SRCDIR)/main.c" ]; then \
		echo "Creating template main.c..."; \
		cat > $(SRCDIR)/main.c << 'TEMPLATE'
#include <raylib.h>
#define RAYGUI_IMPLEMENTATION
#include "raygui.h"

int main(void) {
    const int screenWidth = 800;
    const int screenHeight = 450;
    
    InitWindow(screenWidth, screenHeight, "Raylib + Raygui Template");
    SetTargetFPS(60);
    
    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RAYWHITE);
        
        DrawText("Hello, Raylib + Raygui!", 190, 200, 20, LIGHTGRAY);
        
        if (GuiButton((Rectangle){300, 250, 100, 30}, "Click Me!")) {
            // Button clicked
        }
        
        EndDrawing();
    }
    
    CloseWindow();
    return 0;
}
TEMPLATE
	fi

run: debug
	./$(TARGET)

clean:
	rm -rf $(BUILDDIR)

.PHONY: debug release run clean template
EOF
    fi
    
    # Creează template dacă nu există fișiere sursă
    if [ ! -f "src/main.c" ] && [ ! -f "src/main.cpp" ]; then
      make template
    fi
    
    echo -e "✅ ''${GREEN}Setup complet!''${NC}"
    echo -e "📝 Comenzi disponibile:"
    echo -e "  ''${BLUE}make debug''${NC}   - Build debug"
    echo -e "  ''${BLUE}make release''${NC} - Build release" 
    echo -e "  ''${BLUE}make run''${NC}     - Build și run"
    echo -e "  ''${BLUE}make clean''${NC}   - Șterge build files"
    echo -e "  ''${BLUE}code .''${NC}       - Deschide VSCode"
    echo ""
    echo -e "🔗 Include paths configurate:"
    echo -e "  Raylib: $RAYLIB_PATH/include"
    echo -e "  Raygui: ./include (fixed version)"
  '';
  
  # Variabile de environment permanente
  shellAttributes = {
    CC = "gcc";
    CXX = "g++";
  };
}
