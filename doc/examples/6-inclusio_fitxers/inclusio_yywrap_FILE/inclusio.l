        /* EXEMPLE D'INCLUSIO FITXERS MODIFICANT yywrap() i gestionant una pila d'ID lògics de FILE */

        /* ERROR: problema no actualitza el buffer intern utilitzat per flex !!! */

        /* SOLUCIO: EMPILAR ELS BUFFERS */


%option nounput
%option noinput


%{
#include <stdio.h>
#include <assert.h>
	

#define MAX_INCLUDE 10
#define MAX_NAME 100


FILE *stack[MAX_INCLUDE];

int top_stack=0;

int yywrap();

%}

%x INCLUDE

simbols [a-zA-Z0-9_ ]

%%

        char filename[ MAX_NAME+1 ];
        FILE *aux;

        /* Utilitzem la paraula #include a inici de linia per canviar de fitxer */

^"#include"[ \t]*          BEGIN( INCLUDE );

<INCLUDE>(\"|\<){simbols}+(\.{simbols}+)?(\"|\>)   { assert( top_stack < MAX_INCLUDE );        /* Nombre includes concatenats  ok? */
                                                     strcpy( filename, &yytext[1] );            /* treiem les comestes inicials */
                                                     filename[ yyleng-2 ] = '\0';               /* treiem les comestes finals */
                                                     aux = fopen( filename, "r" );
                                                     assert( aux != NULL );                     /* filename ok? */
                                                     stack[top_stack]=yyin;
                                                     top_stack++;
                                                     yyin=aux;
                                                     BEGIN( INITIAL );
                                                    }
<INCLUDE>.|\n                                   {  printf("ERROR INCLUDE: %c",yytext[0]);   /* ERROR al processar la instrucció */
                                                    BEGIN( INITIAL );
                                                }

.|\n            ECHO;

%%

extern FILE *yyin;


int yywrap(){
    if (top_stack == 0){
          return 1;
    }else{
           fclose(yyin);
           top_stack--;
           yyin=stack[top_stack];
           return 0;
      }
}


int main( int argc, char *argv[] ) {
    yyin = fopen( argv[ 1 ], "r" );
    yylex();
    return 0;
}
