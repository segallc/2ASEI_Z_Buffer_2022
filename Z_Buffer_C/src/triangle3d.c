#include "pixel.h"
#include "polygon.h"
#include "triangle3d.h"

int traceSegment_3D( pixel_t p, point_t a, point_t b, color_t col ){
    int dx = abs(a->x-b->x);
    int dy = abs(a->y-b->y);
    int dz = abs(a->z-b->z);

    int xs;
    int ys;
    int zs;

    int p1;
    int p2;


    int x1 = a->x;
    int x2 = b->x;
    int y1 = a->y;
    int y2 = b->y;
    int z1 = a->z;
    int z2 = b->z;


    if(a->x < b->x) xs = 1;
    else xs = -1;

    if(a->y < b->y) ys = 1;
    else ys = -1;

    if(a->z < b->z) zs = 1;
    else zs = -1;


    if(dx >= dy && dx >= dz){

        p1 = 2 * dy - dx;
        p2 = 2 * dz - dx;


        while( x1 != x2){
            x1 += xs;
            if( p1 >= 0 ){
                y1 += ys;
                p1 -= 2 * dx;
            }

            if( p2 >= 0 ){
            z1 += zs;
            p2 -= 2 * dx;
            }
            p1 += 2 * dy;
            p2 += 2 * dz;
            //ajouter le point
            if(col->r != 0) p->c[x1][y1].r = col->r - z1%255;
            if(col->g != 0) p->c[x1][y1].g = col->g - z1%255;
            if(col->b != 0) p->c[x1][y1].b = col->b - z1%255; 

            p->z[x1][y1] = z1;
        }

        
    }

    else if(dy >= dx && dy >= dz){

        p1 = 2 * dx - dy;
        p2 = 2 * dz - dy;


        while( y1 != y2){
            y1 += ys;
            if( p1 >= 0 ){
                x1 += xs;
                p1 -= 2 * dy;
            }

            if( p2 >= 0 ){
                z1 += zs;
                p2 -= 2 * dy;
            }
            p1 += 2 * dx;
            p2 += 2 * dz;
            //ajouter le point
            if(col->r != 0) p->c[x1][y1].r = col->r - z1%255;
            if(col->g != 0) p->c[x1][y1].g = col->g - z1%255;
            if(col->b != 0) p->c[x1][y1].b = col->b - z1%255; 

            p->z[x1][y1] = z1;
        }
    }

    else {

        p1 = 2 * dy - dz;
        p2 = 2 * dx - dz;


        while( z1 != z2 ){
            z1 += zs;
            if( p1 >= 0 ){
                y1 += ys;
                p1 -= 2 * dz;
            }

            if( p2 >= 0 ){
                x1 += xs;
                p2 -= 2 * dz;
            }
            p1 += 2 * dy;
            p2 += 2 * dx;
            if(col->r != 0) p->c[x1][y1].r = col->r - z1%255;
            if(col->g != 0) p->c[x1][y1].g = col->g - z1%255;
            if(col->b != 0) p->c[x1][y1].b = col->b - z1%255;

            p->z[x1][y1] = z1;
        }
    }

}




int fillTriangle_3D(pixel_t p, color_t col){
    int x,y,xmem;
    point_t a = create_point(0,0,0);
    point_t b = create_point(0,0,0);

    for( y = 0 ; y < p->ysize ; y++ ){
        for ( x = 0 ; x < p->xsize ; x++ ){
            if ( p->c[x][y].r != 0 || p->c[x][y].b != 0 || p->c[x][y].g != 0){
                xmem = x;
                while ( p->c[x][y].r != 0 || p->c[x][y].b != 0 || p->c[x][y].g != 0  ){
                    x++;
                }
                while( x < p->xsize && p->c[x][y].r == 0 && p->c[x][y].g == 0 && p->c[x][y].b == 0){
                    x++;
                    //printf("y : %d x : %d && xmem : %d\n", y, x, xmem);
                }
                if ( x != p->xsize ){
                    a->x = xmem;
                    a->y = y;
                    a->z = p->z[xmem][y];
                    b->x = x;
                    b->y = y;
                    b->z = p->z[x][y];
                    traceSegment_3D( p, a, b,col);
                    x = p->xsize;
                }

            }
        }
    }
}

int traceTriangle_3D(pixel_t p, point_t a, point_t b, point_t c, color_t col){

    traceSegment_3D(p,a,b,col);
    traceSegment_3D(p,a,c,col);
    traceSegment_3D(p,b,c,col);
    fillTriangle_3D(p,col);
}