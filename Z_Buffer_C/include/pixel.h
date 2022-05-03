#ifndef _PIXEL_H_
#define _PIXEL_H_

#include "SDL2/SDL.h"

typedef struct
{
    SDL_Color  **c;
    int        **z;
    int        xsize;
    int        ysize;
}*pixel_t;


typedef struct
{
    int r;
    int g;
    int b;
}*color_t;

//Permet de créer la matrice de pixels xsize * ysize
pixel_t create_pixels( int xsize, int ysize );

color_t create_color(int r,int g, int b);

//Met la couleur de chaque pixel à 255 et la profondeur à 1000 pour l'instant
void initialize_pixels( pixel_t p );

//Affiche la matrice de pixel sur l'écran.
void draw_pixels( SDL_Renderer*, pixel_t );

//Prend en paramètre la matrice d'un nouveau polygone et de l'ancien affichage.
//Retourne 1 si réussi sinon 0
int  update_pixels( pixel_t new, pixel_t current );

#endif