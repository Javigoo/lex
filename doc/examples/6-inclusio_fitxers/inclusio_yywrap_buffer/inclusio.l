        /* EXEMPLE D'INCLUSIO FITXERS MODIFICANT yywrap() i gestionant la pila de buffers */


%option nounput
%option noinput


%{
#include <stdio.h>
#include <assert.h>
	

#define MAX_INCLUDE 10
#define MAX_NAME 100


YY_BUFFER_STATE stack[MAX_INCLUDE];

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
                                                     stack[top_stack]=YY_CURRENT_BUFFER;
                                                     top_stack++;
                                                     yyin=aux;
                                                     yy_switch_to_buffer(yy_create_buffer(yyin,YY_BUF_SIZE));
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
           yy_delete_buffer( YY_CURRENT_BUFFER );
           top_stack--;
           yy_switch_to_buffer( stack[top_stack] );
           return 0;
      }
}


int main( int argc, char *argv[] ) {
    yyin = fopen( argv[ 1 ], "r" );
    yylex();
    return 0;
}
