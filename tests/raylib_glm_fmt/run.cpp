#include "raylib.h"
#include <glm/glm.hpp>
#include <fmt/core.h>
#include <vector>
#include <cstdio>
#include <cstdlib>

int main()
{
    // Initialization
    //--------------------------------------------------------------------------------------
    constexpr int screenWidth = 800;
    constexpr int screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib_glm_fmt_cunta_test");

    SetTargetFPS(60);               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------
    

    std::vector<glm::vec2> shape{{-1.f,1.f},{0.f,-1.f},{1.f,1.f}}; 
    glm::vec2 current(0.f, 0.f);

    int framesToShow = 600;
    int stepsByFrame = 20;
    int dotsPrinted = 0;

    // Main game loop
    while (framesToShow > 0 && !WindowShouldClose())    // Detect window close button or ESC key
    {
        // Update 
	    framesToShow--;
        for(int i = 0; i < stepsByFrame; i++) {
	        current = (current + shape[rand()%shape.size()]) * 0.5f;
            DrawPixel((int)(current.x * screenWidth), (int)(current.y * screenHeight), WHITE);
            dotsPrinted++;
        }

        // Draw
        //----------------------------------------------------------------------------------
        BeginDrawing();
        DrawRectangle(0, 0, 200, 40, BLACK);
        DrawText(fmt::format("Printed {} dots.", dotsPrinted).c_str(), 0, 0, 20, BLUE);
        EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    CloseWindow();        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    return 0;
}
