#include "pixel.h"
#include "polygon.h"
#include "triangle3d.h"

int main(int argc, char const *argv[])
{
    int xsize = 512;
    int ysize = 512;
    char output[512];

    pixel_t p = create_pixels( xsize, ysize);
    pixel_t n = create_pixels( xsize, ysize );

    point_t a = create_point(  1, 1, 0);
    point_t b = create_point( 100, 100, 119 );
    point_t c = create_point( 200, 1,  0 );

    point_t d = create_point( 1, 1, 0 );
    point_t e = create_point( 100, 400,  118);
    point_t f = create_point( 1, 300, 0 );

    point_t g = create_point( 100, 1, 0 );
    point_t h = create_point( 250  , 250, 119 );
    point_t i = create_point( 100, 300, 0 );

    point_t j = create_point(  1, 500, 0);
    point_t k = create_point( 250, 250, 119);
    point_t l = create_point( 500, 500,  0 );

    color_t col1 = create_color(120,120,120);
    color_t col2 = create_color(120,120, 120);
    color_t col3 = create_color(120,120,120);
    color_t col4 = create_color( 120, 120, 120 );

    initialize_pixels( p );
    initialize_pixels( n );

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
            
            draw_pixels( pRenderer, p );



            traceTriangle_3D(n,a,b,c,col1);
            update_pixels( n, p );
            initialize_pixels( n );
            draw_pixels( pRenderer, p );
            SDL_Delay( 2000 );

            traceTriangle_3D(n,e,f,d,col2);
            update_pixels( n, p );
            initialize_pixels( n );
            draw_pixels( pRenderer, p );
            SDL_Delay( 2000 );

            traceTriangle_3D(n,g,h,i,col3);
            update_pixels( n, p );
            initialize_pixels( n );
            draw_pixels( pRenderer, p );
            SDL_Delay( 2000 );

            traceTriangle_3D(n,j,k,l,col4);
            update_pixels( n, p );
            draw_pixels( pRenderer, p );


            printf("Enter q to exit.\n");
            while ( scanf("%s", output) == 0 );
        }
    return 0;
}



