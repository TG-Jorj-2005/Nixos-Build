{config,pkgs,lib, ...}:
{
pkgs.mkShell {
  name = "raylib-dev-env";
  
  buildInputs = with pkgs; [
    # Compilatoare și tools
    gcc
    gdb
    make
    cmake
    pkg-config
    
    # Raylib dependencies
    raylib
    raygui
    
    # Development tools
    git
    
    # VSCode (opțional - comentează dacă ai probleme)
    # vscode
  ];
  
  shellHook = ''
    echo "=== Raylib C++ Development Environment ==="
    echo "Project directory: $(pwd)"
    
    # Creează structura de directoare
    mkdir -p .vscode include src build
    
    # Environment variables
    export RAYLIB_INCLUDE="${pkgs.raylib}/include"
    export RAYLIB_LIB="${pkgs.raylib}/lib" 
    export RAYGUI_INCLUDE="${pkgs.raygui}/include"
    
    # Fix pentru raygui enum warnings
    if [ ! -f "./include/raygui.h" ]; then
      echo "Fixing raygui enum warnings..."
      cp "$RAYGUI_INCLUDE/raygui.h" ./include/
      
      # Aplică patch-urile pentru enum warnings
      sed -i 's/property < DEFAULT_PROPS_COUNT/(int)property < (int)DEFAULT_PROPS_COUNT/g' ./include/raygui.h
      sed -i 's/property >= DEFAULT_PROPS_COUNT/(int)property >= (int)DEFAULT_PROPS_COUNT/g' ./include/raygui.h
      sed -i 's/property == DEFAULT_PROPS_COUNT/(int)property == (int)DEFAULT_PROPS_COUNT/g' ./include/raygui.h
      
      echo "raygui.h fixed successfully!"
    fi
    
    # VSCode configuration
    if [ ! -f ".vscode/c_cpp_properties.json" ]; then
      echo "Creating VSCode configuration..."
      
cat > .vscode/c_cpp_properties.json << EOF
{
    "configurations": [
        {
            "name": "Linux",
            "includePath": [
                "\''${workspaceFolder}/**",
                "\''${workspaceFolder}/include",
                "$RAYLIB_INCLUDE"
            ],
            "defines": [],
            "compilerPath": "${pkgs.gcc}/bin/gcc",
            "cStandard": "c17",
            "cppStandard": "c++17",
            "intelliSenseMode": "linux-gcc-x64"
        }
    ],
    "version": 4
}
EOF

cat > .vscode/settings.json << EOF
{
    "C_Cpp.errorSquiggles": "Disabled",
    "problems.excludeFiles": [
        "**/nix/store/**"
    ]
}
EOF

cat > .vscode/tasks.json << EOF
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "build",
            "type": "shell",
            "command": "make",
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "presentation": {
                "echo": true,
                "reveal": "always"
            }
        },
        {
            "label": "run",
            "type": "shell", 
            "command": "make",
            "args": ["run"],
            "group": "test",
            "dependsOn": "build"
        }
    ]
}
EOF
    fi
    
    # Makefile simplu și funcțional
    if [ ! -f "Makefile" ]; then
cat > Makefile << 'EOF'
# Makefile pentru Raylib + Raygui
CC = gcc
CFLAGS = -Wall -Wextra -Wno-enum-compare -std=c17 -g
INCLUDES = -I./include -I$(RAYLIB_INCLUDE)
LIBS = -L$(RAYLIB_LIB) -lraylib -lGL -lm -lpthread -ldl -lrt -lX11

SRCDIR = src
BUILDDIR = build
SOURCES = $(wildcard $(SRCDIR)/*.c)
TARGET = $(BUILDDIR)/game

.PHONY: all build run clean template help

all: build

build: $(TARGET)

$(TARGET): $(SOURCES) | $(BUILDDIR)
	$(CC) $(CFLAGS) $(INCLUDES) $(SOURCES) $(LIBS) -o $(TARGET)

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

run: $(TARGET)
	cd $(BUILDDIR) && ./game

clean:
	rm -rf $(BUILDDIR)

template:
	@if [ ! -f "$(SRCDIR)/main.c" ]; then \
		echo "Creating template main.c..."; \
		cat > $(SRCDIR)/main.c << 'TEMPLATE_END'
#include <raylib.h>

// Important: Define RAYGUI_IMPLEMENTATION before including raygui.h
#define RAYGUI_IMPLEMENTATION
#include "raygui.h"

int main(void)
{
    // Initialization
    const int screenWidth = 800;
    const int screenHeight = 450;
    
    InitWindow(screenWidth, screenHeight, "Raylib + Raygui Template");
    SetTargetFPS(60);
    
    bool showMessageBox = false;
    
    // Main game loop
    while (!WindowShouldClose())
    {
        // Update
        // Add your update logic here
        
        // Draw
        BeginDrawing();
        
        ClearBackground(RAYWHITE);
        
        DrawText("Hello, Raylib + Raygui World!", 190, 100, 20, LIGHTGRAY);
        DrawText("Press the button below!", 240, 150, 16, GRAY);
        
        // Simple button
        if (GuiButton((Rectangle){ 300, 200, 120, 30 }, "Click Me!"))
        {
            showMessageBox = true;
        }
        
        // Simple checkbox
        static bool checkBoxChecked = false;
        GuiCheckBox((Rectangle){ 300, 250, 15, 15 }, "Enable something", &checkBoxChecked);
        
        // Simple slider
        static float sliderValue = 50.0f;
        GuiSlider((Rectangle){ 300, 290, 120, 20 }, "Min", "Max", &sliderValue, 0.0f, 100.0f);
        DrawText(TextFormat("Value: %.1f", sliderValue), 300, 320, 16, DARKGRAY);
        
        // Message box
        if (showMessageBox)
        {
            int result = GuiMessageBox((Rectangle){ 85, 70, 250, 100 }, 
                                     "#191#Message Box", 
                                     "Hi! This is a message box.", 
                                     "Nice;Cool");
            if (result >= 0) showMessageBox = false;
        }
        
        EndDrawing();
    }
    
    // De-Initialization
    CloseWindow();
    
    return 0;
}
TEMPLATE_END
		echo "Template created in $(SRCDIR)/main.c"; \
	else \
		echo "main.c already exists!"; \
	fi

help:
	@echo "Available commands:"
	@echo "  make build    - Compile the project"
	@echo "  make run      - Build and run the project"
	@echo "  make clean    - Remove build files"
	@echo "  make template - Create a template main.c file"
	@echo "  make help     - Show this help message"
EOF
    fi
    
    # Creează template dacă nu există fișiere în src/
    if [ ! -f "src/main.c" ]; then
      make template
    fi
    
    echo ""
    echo "=== Setup Complete! ==="
    echo "Available commands:"
    echo "  make run      - Build and run your project"
    echo "  make clean    - Clean build files"
    echo "  code .        - Open VSCode (if installed)"
    echo ""
    echo "Your project structure:"
    echo "  src/          - Source files (.c)"
    echo "  include/      - Fixed raygui.h header"
    echo "  build/        - Compiled binaries"
    echo "  .vscode/      - VSCode configuration"
    echo ""
  '';
}
