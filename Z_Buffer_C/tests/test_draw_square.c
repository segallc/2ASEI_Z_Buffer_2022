#include <stdio.h>
#include <stdlib.h>

#include <SDL2/SDL.h>

#include "pixel.h"
#include "polygon.h"

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
        //dans cette partie on code le carré

        //creation dees points :

         point_t a = create_point(0,0,1);
         point_t b = create_point(4,2,3);
         point_t c = create_point(-3,1,1);
         plan_t plan = get_plan(a,b,c);

        for ( x = 0 ; x < xsize ; x++ ){
            for ( y = 0 ; y < ysize ; y++ ){
                if ( (200 < x && x < 600 )&& ( 200 < y && y < 600 ) ){
                    n->c[x][y].g = 255;
                    n->z[x][y] = get_z(plan,x,y);
                }
                else {
                    n->z[x][y] = 1200;
                }
            }
        }
        delete_point(a);
        delete_point(b);
        delete_point(c);
        

        draw_pixels( pRenderer, p );
        SDL_Delay(2000);
        update_pixels( n, p );
        draw_pixels( pRenderer, p );
        SDL_Delay(5000);

        plan->d = plan->d + 100;
        initialize_pixels( n );
        for ( x = 0 ; x < xsize ; x++ ){
            for ( y = 0 ; y < ysize ; y++ ){
                if ( ( 300 < x && x < 700) && ( 300 < y && y < 700 ) ){
                    n->c[x][y].r = 255;
                    n->z[x][y] = get_z(plan,x,y);
                }
                else {
                    n->z[x][y] = 1200;
                }
            }
        }

        update_pixels( n, p );
        draw_pixels( pRenderer, p );
        SDL_Delay(5000);

        plan->d = plan->d - 200;
        initialize_pixels( n );

        for ( x = 0 ; x < xsize ; x++ ){
            for ( y = 0 ; y < ysize ; y++ ){
                if ( ( 400 < x && x < 800) && ( 400 < y && y < 800 ) ){
                    n->c[x][y].b = 255;
                    n->z[x][y] = 999;//get_z(plan,x,y);
                }
                else {
                    n->z[x][y] = 1200;
                }
            }
        }

        update_pixels( n, p );
        draw_pixels( pRenderer, p );
        SDL_Delay(5000);

        delete_plan(plan);

        SDL_DestroyRenderer( pRenderer );
        SDL_DestroyWindow( pWindow );
    }

    printf("Quiting SDL...\n");

    SDL_Quit();

    return 0;
}
