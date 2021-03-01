
%option nounput
%option noinput


%{
#include <stdio.h>
#include <assert.h>

#define MAX_NAME 100
%}

%X COMMENT LINECOMMENT INCLUDE

simbols [a-zA-Z0-9_ ]


%%

        char filename[ MAX_NAME+1 ];

\/\/                    BEGIN( LINECOMMENT );

<LINECOMMENT>\n         BEGIN( INITIAL );

<LINECOMMENT>.          ;

\/\*                    BEGIN( COMMENT );

<COMMENT>\*\/           BEGIN( INITIAL );

<COMMENT>.              ;

<COMMENT>\\\n           ;

<COMMENT>\n             {   printf("ERROR FORMAT COMENTARI");
                            BEGIN( INITIAL );
                        }
    
^"#include"[ \t]+          BEGIN( INCLUDE );

<INCLUDE>(\"|\<){simbols}+(\.{simbols}+)?(\"|\>)   { strcpy( filename, &yytext[1] );            /* treiem les comestes inicials */
                                                    filename[ yyleng-2 ] = '\0';               /* treiem les comestes finals */
                                                    yyin = fopen( filename, "r" );
                                                    assert( yyin != NULL );                     /* filename ok? */
                                                    yypush_buffer_state( yy_create_buffer( yyin, YY_BUF_SIZE ) );
                                                    BEGIN( INITIAL );
                                                    }

%%

int yywrap(){
    yypop_buffer_state();
    if ( !YY_CURRENT_BUFFER )
        return 1;
    else
        return 0;
}


int main( int argc, char *argv[] ) {
   yyin = fopen( argv[ 1 ], "r" );
   yylex();
   return 0;
}
