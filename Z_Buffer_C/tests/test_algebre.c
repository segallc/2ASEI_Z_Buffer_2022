#include <stdio.h>
#include <stdlib.h>

#include "polygon.h"


int main(){

    printf("---------test des fonctions de polygon.c ------------\n");
    printf("\n\n");

    printf("creation de trois points... \n");
    point_t a = create_point(0,0,1);
    point_t b = create_point(4,2,3);
    point_t c = create_point(-3,1,1);
    printf("\n\n");
    printf("affichage des trois points \n");
    print_point(a);
    print_point(b);
    print_point(c);
    printf("\n\n");
    printf("calcul des vecteurs AB, AC et N...\n");

    vector_t AB_v = points_to_vector(a,b);
    vector_t AC_v = points_to_vector(a,c);

    vector_t N_v = vector_product(AB_v,AC_v);
    printf("\n\n");
    printf("vector AB :              ");
    print_vector(AB_v);
    printf("vector AC :              ");
    print_vector(AC_v);

    printf("vector normal au plan :  ");
    print_vector(N_v);


    printf("calcul du plan...\n");
    printf("\n\n");
    plan_t plan = get_plan(a,b,c);
    printf("l equation du plan est : ");
    print_plan(plan);

    printf("calcul de z en fonction de x et y...\n");
    int z = get_z(plan,1,1);
    printf("The value of z is %i \n",z);
    printf("\n\n");
    printf("\n\n");

    printf("liberation de l espace memoire...\n");
    delete_plan(plan);
    delete_vector(AB_v);
    delete_vector(AC_v);
    delete_vector(N_v);
    delete_point(a);
    delete_point(b);
    delete_point(c);
    
    printf("---------fin du programme---------\n");

    exit(EXIT_SUCCESS);
}