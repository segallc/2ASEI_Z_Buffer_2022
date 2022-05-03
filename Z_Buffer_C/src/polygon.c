#include <stdlib.h>
#include <stdio.h>

#include "polygon.h"

point_t create_point(int x,int y,int z){
    point_t a = calloc(1,sizeof(*a));

    if( a == NULL){
        printf("--------memory allocation error--------");
        return a;
    }
    a->x = x;
    a->y = y;
    a->z = z;
    return a;
}

vector_t vector_product(vector_t A_v,vector_t B_v){

    vector_t V_v = calloc( 1, sizeof( *V_v ) );
    if(NULL == V_v ){
        return V_v;
    }
    V_v->x = A_v->y * B_v->z - A_v->z * B_v->y;
    V_v->y = A_v->z * B_v->x - A_v->x * B_v->z;
    V_v->z = A_v->x * B_v->y - A_v->y * B_v->x;
    V_v->base = 0;
    
    return V_v;
}

vector_t points_to_vector(point_t a,point_t b){

    vector_t V_v = calloc( 1, sizeof( *V_v ) );
    if(V_v == NULL){
        return V_v;
    }

    V_v->x = b->x - a->x;
    V_v->y = b->y - a->y;
    V_v->z = b->z - a->z;

    V_v->base = 0;

    return V_v;
}

plan_t build_plan(vector_t N_v, point_t o){
    plan_t plan = calloc(1,sizeof(*plan));
    if(plan == NULL){
        return plan;
    }
    plan->a = N_v->x;
    plan->b = N_v->y;
    plan->c = N_v->z;

    plan->d = -(N_v->x*o->x + N_v->y*o->y + N_v->z*o->z);

    return plan;
}


plan_t get_plan(point_t a, point_t b, point_t c){

    vector_t AB_v = points_to_vector(a,b);
    vector_t AC_v = points_to_vector(a,c);

    vector_t N_v = vector_product(AB_v,AC_v);

    plan_t p = build_plan(N_v,a);
    delete_vector(AB_v);
    delete_vector(AC_v);
    delete_vector(N_v);
    return p;
}


int get_z(plan_t p,int x,int y){
    if( p->c == 0){
        printf("faut gerer l'erreur ici");
        return 0;
    }
    else {
        //retourne le calcul de z
        return -(p->a*x+p->b*y+p->d)/p->c;

    }

}


point_t delete_point(point_t a){

    free(a);
    return a;
}

vector_t delete_vector(vector_t V_v){

    free(V_v);
    return V_v;
}

plan_t delete_plan(plan_t p){

    free(p);
    return p;
}

void print_point(point_t a){

    printf("( %i , %i , %i ) \n",a->x,a->y,a->z);
}

void print_vector(vector_t V_v){

    printf("( %i , %i , %i ) base : %c \n",V_v->x,V_v->y,V_v->z,V_v->base);
}

void print_plan(plan_t p){

    printf(" %ix + %iy + %iz + %i = 0 \n",p->a,p->b,p->c,p->d);
}

