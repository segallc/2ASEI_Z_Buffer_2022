#include <stdio.h>

#include "polygon.h"
#include "pixel.h"
#include "triangle3d.h"

#include "SDL2/SDL.h"

int main(int argc, char const *argv[])
{
    printf("-------Programme de vérification-------\n");

    if ( argc != 13 ){
        fprintf( stderr, "Les arguments doivent être passés sous la forme : ./test_verif x y z x y z x y z r g b\n");
        exit(EXIT_FAILURE);
    }
    else {
        char output[256];

        int xsize, ysize;
        xsize = ysize = 1000;

        point_t a = create_point( atoi(argv[1]), atoi(argv[2]), atoi(argv[3]) );
        point_t b = create_point( atoi(argv[4]), atoi(argv[5]), atoi(argv[6]) );
        point_t c = create_point( atoi(argv[7]), atoi(argv[8]), atoi(argv[9]) );

        color_t col = create_color( atoi(argv[10]), atoi(argv[11]), atoi(argv[12]) );

        pixel_t p = create_pixels( xsize, ysize );    
        initialize_pixels( p );

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
            
            traceTriangle_3D(p,a,b,c,col);
            draw_pixels( pRenderer, p );
            SDL_Delay( 2000 );

            printf("Enter q to exit.\n");
            while ( scanf("%s", output) == 0 );
        }

        printf("---------------------------------------\n");
        exit(EXIT_SUCCESS);
    }

}
