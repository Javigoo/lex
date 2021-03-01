######################################################################
# 
#
#                   
#		Inclusio de fitxers amb flex 
#       
#                    Tere Alsinet
#
#                     Makefile
#
#		 
#  
######################################################################

# General defines
CC = gcc
LEX = flex
YACC = yacc
LIB = -lc
ELEX = inclusio.l
LFLAGS = -n 
CFLAGS = -ansi

######################################################################

inclusio : inclusio.c
	$(CC) -o inclusio $(CFLAGS) inclusio.c $(LIB)
 
inclusio.c : $(ELEX)	
	$(LEX) $(LFLAGS) $< 
	mv lex.yy.c $*.c

clean : 
	rm -f inclusio.c
