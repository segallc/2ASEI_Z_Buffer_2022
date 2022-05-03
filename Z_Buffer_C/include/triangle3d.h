#ifndef _TRIANGLE3D_H_
#define _TRIANGLE3D_H_

#include "pixel.h"
#include "polygon.h"

int traceSegment_3D( pixel_t p, point_t a, point_t b, color_t col);

int fillTriangle_3D(pixel_t p ,color_t col);

int traceTriangle_3D(pixel_t p, point_t a, point_t b, point_t c, color_t col);

#endif