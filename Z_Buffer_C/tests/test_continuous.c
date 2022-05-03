#include <stdio.h>

#include "polygon.h"
#include "pixel.h"
#include "triangle3d.h"

#include "SDL2/SDL.h"

int main(int argc, char const *argv[])
{
    printf("-------Programme en continu-------\n");
    char output[256];

    int xsize, ysize;
    xsize = ysize = 512;

    int x1, x2, x3, y1, y2, y3, z1, z2, z3, r, g, bl;

    pixel_t p = create_pixels( xsize, ysize );    
    initialize_pixels( p );
    pixel_t n = create_pixels( xsize, ysize );    
    initialize_pixels( n );

    printf("Initializing SDL...\n");

    if ( SDL_Init(SDL_INIT_EVERYTHING) != 0 ){
        fprintf(stderr, "Could not initialize SDL : (%s)\n", SDL_GetError());
        exit(EXIT_FAILURE);
    }
    else {
        printf("SDL Initialized.\n");

        SDL_Window* pWindow = SDL_CreateWindow( "Rendering points...", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, xsize, ysize, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE );
            
        SDL_Renderer* pRenderer = SDL_CreateRenderer( pWindow, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC );

            while ( 1 ){
                if ( scanf("%d %d %d %d %d %d %d %d %d %d %d %d", &x1, &y1, &z1, &x2, &y2, &z2, &x3, &y3, &z3, &r, &g, &bl ) == 12 ){

                point_t a = create_point( x1, y1, z1 );
                point_t b = create_point( x2, y2, z2 );
                point_t c = create_point( x3, y3, z3 );

                color_t col = create_color( r, g, bl );

                initialize_pixels( n );
                traceTriangle_3D( n, a, b, c, col );
                update_pixels( n, p );
                draw_pixels( pRenderer, p );  
                }
                if( scanf("%s",output) == 1){
                    return 0;
                }
            }
        }
    printf("---------------------------------------\n");
    exit(EXIT_SUCCESS);
}
