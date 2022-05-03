#ifndef _POLYGON_H
#define _POLYGON_H



typedef struct
{
    int x;
    int y;
    int z;
}*point_t;

typedef struct
{
    int x;
    int y;
    int z;
    char base;
}*vector_t;

typedef struct
{
    int a;
    int b;
    int c;
    int d;
}*plan_t;
//permet de creer un point
point_t create_point(int x,int y,int z);

//cree le vecteur à partir de points
vector_t points_to_vector(point_t a,point_t b);

//calcul le produit vectoriel
vector_t vector_product(vector_t A_v,vector_t B_v);

//calcul les 4 coefficient du plan 
plan_t build_plan(vector_t N_v, point_t o);

//permet de calculer le plan en avec suelement trois points, a partir des fonctions précédentes
plan_t get_plan(point_t a, point_t b, point_t c);

//permet de calculer la profondeur à partir du plan et de x et y
int get_z(plan_t p,int x,int y);

//permet de liberer  espace memoire du point
point_t delete_point(point_t a);

//permet de liberer l espace memoire du vector
vector_t delete_vector(vector_t V_v);

//permet de liberer l espace memoire du vector
plan_t delete_plan(plan_t p);

//affiche un point
void print_point(point_t a);

//affiche un vector
void print_vector(vector_t V_v);

//affiche un plan
void print_plan(plan_t p);

#endif