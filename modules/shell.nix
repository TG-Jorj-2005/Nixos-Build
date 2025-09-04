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
    clang-tools
    valgrind
    strace
  ];
  
  shellHook = ''
    echo "🚀 C++ Development Environment cu Raylib"
    echo "📁 Project directory: $(pwd)"
    
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
      echo "🔧 Copying și fixing raygui headers..."
      cp $RAYGUI_PATH/include/raygui.h ./include/
      
      # Fix enum comparison warnings
      sed -i 's/property < DEFAULT_PROPS_COUNT/(int)property < (int)DEFAULT_PROPS_COUNT/g' ./include/raygui.h
      sed -i 's/property >= DEFAULT_PROPS_COUNT/(int)property >= (int)DEFAULT_PROPS_COUNT/g' ./include/raygui.h
      sed -i 's/property == DEFAULT_PROPS_COUNT/(int)property == (int)DEFAULT_PROPS_COUNT/g' ./include/raygui.h
      
      echo "✅ raygui.h fixed!"
    fi
    
    # Generează VSCode config doar dacă nu există
    if [ ! -f ".vscode/c_cpp_properties.json" ]; then
      echo "⚙️ Creating VSCode configuration..."
      cat > .vscode/c_cpp_properties.json << 'EOF'
{
    "configurations": [
        {
            "name": "Linux-Nix",
            "includePath": [
                "''${workspaceFolder}/**",
                "''${workspaceFolder}/include",
                "''${env:RAYLIB_PATH}/include"
            ],
            "defines": ["PLATFORM_DESKTOP"],
            "compilerPath": "gcc",
            "cStandard": "c17",
            "cppStandard": "c++20",
            "intelliSenseMode": "linux-gcc-x64",
            "compilerArgs": ["-Wno-enum-compare"]
        }
    ],
    "version": 4
}
EOF

      cat > .vscode/settings.json << 'EOF'
{
    "C_Cpp.errorSquiggles": "Disabled",
    "problems.excludeFiles": ["**/nix/store/**"]
}
EOF

      cat > .vscode/tasks.json << 'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "build",
            "type": "shell", 
            "command": "gcc",
            "args": [
                "-g", "-Wall", "-Wno-enum-compare",
                "-I./include", "-I''${env:RAYLIB_PATH}/include",
                "src/*.c", "src/*.cpp",
                "-L''${env:RAYLIB_PATH}/lib",
                "-lraylib", "-lGL", "-lm", "-lpthread", "-ldl", "-lrt", "-lX11",
                "-o", "build/game"
            ],
            "group": {"kind": "build", "isDefault": true}
        }
    ]
}
EOF
    fi
    
    # Creează Makefile simplu
    if [ ! -f "Makefile" ]; then
      cat > Makefile << 'EOF'
CC = gcc
CFLAGS = -Wall -Wno-enum-compare -g
INCLUDES = -I./include -I$(RAYLIB_PATH)/include
LIBS = -L$(RAYLIB_PATH)/lib -lraylib -lGL -lm -lpthread -ldl -lrt -lX11

SRCDIR = src
BUILDDIR = build
SOURCES = $(wildcard $(SRCDIR)/*.c) $(wildcard $(SRCDIR)/*.cpp)
TARGET = $(BUILDDIR)/game

$(TARGET): $(SOURCES) | $(BUILDDIR)
	$(CC) $(CFLAGS) $(INCLUDES) $(SOURCES) $(LIBS) -o $@

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

template:
	@if [ ! -f "$(SRCDIR)/main.c" ]; then \
		cat > $(SRCDIR)/main.c << 'TEMPLATE'
#include <raylib.h>
#define RAYGUI_IMPLEMENTATION  
#include "raygui.h"

int main(void) {
    InitWindow(800, 450, "Raylib + Raygui");
    SetTargetFPS(60);
    
    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RAYWHITE);
        DrawText("Hello World!", 190, 200, 20, LIGHTGRAY);
        if (GuiButton((Rectangle){300, 250, 100, 30}, "Click!")) {
            // Button action
        }
        EndDrawing();
    }
    
    CloseWindow();
    return 0;
}
TEMPLATE
	fi

run: $(TARGET)
	./$(TARGET)

clean:
	rm -rf $(BUILDDIR)

.PHONY: run clean template
EOF
    fi
    
    # Creează template dacă nu există
    if [ ! -f "src/main.c" ] && [ ! -f "src/main.cpp" ]; then
      make template
    fi
    
    echo "✅ Setup complet!"
    echo "Comenzi: make run | make clean | code ."
  '';
}
