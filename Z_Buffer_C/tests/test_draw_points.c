#include <stdio.h>
#include <stdlib.h>

#include <SDL2/SDL.h>

#include "pixel.h"

int main(int argc, char const *argv[])
{
    int x, y, running = 1;

    int xsize = 1000;
    int ysize = 1000;

    pixel_t p = create_pixels( xsize, ysize );
    pixel_t n = create_pixels( xsize, ysize );
    
    printf("Initializing SDL...\n");

    if ( SDL_Init(SDL_INIT_EVERYTHING) != 0 ){
        fprintf(stderr, "Could not initialize SDL : (%s)\n", SDL_GetError());
        exit(EXIT_FAILURE);
    }
    else {
        printf("SDL Initialized.\n");

        SDL_Window* pWindow = SDL_CreateWindow( "Rendering points...", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, xsize, ysize, SDL_WINDOW_SHOWN );
        
        SDL_Renderer* pRenderer = SDL_CreateRenderer( pWindow, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC );

        SDL_Event event;
        
        initialize_pixels( p );
        draw_pixels( pRenderer, p );
        SDL_Delay(2000);
        for ( x = 0 ; x < xsize ; x++ ){
            for ( y = 0 ; y < ysize ; y++ ){
                if ( (100 < x && x < 500) && (100 < y && y < 500 ) ){
                    p->c[x][y].r = 255;
                    p->z[x][y] = 900;
                }
                if ( (250 < x && x < 750) && ( 250 < y && y < 750 ) ){
                    n->c[x][y].g = 255;
                    n->c[x][y].r = 0;
                    n->c[x][y].b = 0;
                    n->z[x][y] = 100;
                }
            }
        }
        //draw_pixels( pRenderer, p );
        //SDL_Delay(2000);
        update_pixels( n, p );
        draw_pixels( pRenderer, p );
        SDL_Delay(5000);
        SDL_DestroyRenderer( pRenderer );
        SDL_DestroyWindow( pWindow );
    }

    printf("Quiting SDL...\n");

    SDL_Quit();

    return 0;
}
