
# General defines
CC = gcc
LEX = flex 
LIB = -lc -ll
ELEX = string.l
LFLAGS = -n 
CFLAGS = -ansi 

######################################################################

string : string.c
	$(CC) -o string $(CFLAGS) string.c $(LIB)
 
string.c : $(ELEX)	
	$(LEX) $(LFLAGS) $< 
	mv lex.yy.c $*.c

clean : 
	rm -f string.c string

