#include "pixel.h"

pixel_t create_pixels( int xsize, int ysize ){
    int i;

    pixel_t p = calloc( 1, sizeof( *p ) );

    if ( NULL == p ){
        return p;
    }

    p->c = calloc( xsize, sizeof( *(p->c) ) );
    p->z = calloc( xsize, sizeof( *(p->z) ) );

    if ( NULL == p->c || NULL == p->z ){
        return NULL;
    }
    for ( i = 0 ; i < xsize ; i++ ){
        p->c[i] = calloc( ysize, sizeof( *(p->c[i]) ) );
        p->z[i] = calloc( ysize, sizeof( *(p->z[i]) ) );
        if ( NULL == p->c[i] || NULL == p->z[i] ){
            return NULL;
        }
    }

    p->xsize = xsize;
    p->ysize = ysize;

    return p;
}

color_t create_color(int r,int g, int b){

    color_t col = calloc(1,sizeof(*col));
    if( col == NULL){
        printf("--------memory allocation error--------");
        return col;
    }

    col->b = b;
    col->g = g;
    col->r = r;

    return col;
}

void initialize_pixels( pixel_t p ){
    int x, y;

    for ( x = 0 ; x < p->xsize ; x++ ){
        for ( y = 0 ; y < p->ysize ; y++ ){
            p->c[x][y].a = 0;
            p->c[x][y].g = 0;
            p->c[x][y].r = 0;
            p->c[x][y].b = 0;
            p->z[x][y] = 1000;
        }
    }

    printf("Pixel matrix initialized.\n");
}
void draw_pixels( SDL_Renderer* r, pixel_t p){
    int x, y;

    SDL_RenderClear( r );

    for ( x = 0 ; x < p->xsize ; x++ ){
        for ( y = 0 ; y < p->ysize ; y++ ){
            SDL_SetRenderDrawColor( r, p->c[x][y].r, p->c[x][y].g, p->c[x][y].b, p->c[x][y].a);
            SDL_RenderDrawPoint( r, x, y );
        }
    }

    SDL_RenderPresent( r );
}

int update_pixels( pixel_t new, pixel_t current ){
    if ( new->xsize != current->xsize || new->ysize != current->ysize ){
        return 0;
    }
    else {
        int x, y;

        for ( x = 0 ; x < current->xsize ; x++ ){
            for ( y = 0 ; y < current->ysize ; y++ ){
                if ( new->z[x][y] < current->z[x][y] ){
                    current->c[x][y].b = new->c[x][y].b;
                    current->c[x][y].r = new->c[x][y].r;
                    current->c[x][y].g = new->c[x][y].g;
                    current->z[x][y] = new->z[x][y];
                }
            }
        }
        return 1;
    }
}