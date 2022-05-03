#Pour les fichiers d'entete
INCDIR=./include
#Pour les fichiers executables
BINDIR=./bin
#Pour les fichiers binaires (.o)
OBJDIR=./obj
#Pour les fichiers de tests
TESTS=./tests
#Pour les fichiers sources .c
SRCDIR=./src

#Le nom du compilateur
CC=gcc

#Les options du compilateur : compilation (-c) et debug (-g). On peut ajouter -O3 pour optimiser quand le code est juste
CFLAGS=-c -g -I ../include -Iinclude

#Les options de l'editeur de liens : -lm pour la bibliothèque mathématique. Voir les Makefile de TP pour ajouter la SDL si besoin
LDFLAGS= -Wall -Wextra -lSDL2

EXEDIR=main test_draw_points test_algebre test_draw_square test_3d_triangle test_continuous test_verif

all: $(EXEDIR)

main : $(OBJDIR)/main.o
	$(CC) -o $@ $^ $(LDFLAGS)

test_verif : $(OBJDIR)/test_verif.o $(OBJDIR)/triangle3d.o $(OBJDIR)/pixel.o $(OBJDIR)/polygon.o
	$(CC) -o $@ $^ $(LDFLAGS)

test_continuous : $(OBJDIR)/test_continuous.o $(OBJDIR)/triangle3d.o $(OBJDIR)/pixel.o $(OBJDIR)/polygon.o
	$(CC) -o $@ $^ $(LDFLAGS)

test_3d_triangle : $(OBJDIR)/test_3d_triangle.o $(OBJDIR)/triangle3d.o $(OBJDIR)/pixel.o $(OBJDIR)/polygon.o
	$(CC) -o $@ $^ $(LDFLAGS)

test_draw_points : $(OBJDIR)/test_draw_points.o $(OBJDIR)/pixel.o
	$(CC) -o $@ $^ $(LDFLAGS)

test_algebre : $(OBJDIR)/test_algebre.o $(OBJDIR)/polygon.o
	$(CC) -o $@ $^ $(LDFLAGS)

test_draw_square : $(OBJDIR)/test_draw_square.o $(OBJDIR)/pixel.o $(OBJDIR)/polygon.o 
	$(CC) -o $@ $^ $(LDFLAGS)

# pour construire les fichiers binaires .o
$(OBJDIR)/%.o : $(TESTS)/%.c
	$(CC) $(CFLAGS) $^ -o $@

$(OBJDIR)/%.o : $(SRCDIR)/%.c
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -rf $(OBJDIR)/* $(BINDIR)/* $(EXEDIR) *.dSYM
