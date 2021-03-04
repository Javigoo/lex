
	/* Seccio de DECLARACIONS */

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define STRING 1

unsigned char buf[200];
%}

%x string

%%

%{
	/* Seccio de REGLES */

unsigned char *s;
%}

\"                          {BEGIN string;
                            s = buf;}

<string>\\[0-7]{1,3}		 {*s = (unsigned char) strtol(yytext+1, (char **) 0, 8);
                            s++;}

<string>\\x[0-9a-fA-F]+		{*s = (unsigned char) strtol(yytext+2, (char **) 0, 16);
                            s++;}

<string>\\\"				{*s = '\"';
                            s++;}

<string>\\\\				{*s = '\\';
                            s++;}

<string>\\[rbfntv]			{*s = *(strchr("\rr\bb\ff\nn\tt\vv", yytext[1] ) - 1);
                            s++;}


		/* S'ignora el canvi de linia si va precedit del caracter \ */

<string>\\\n				{;}



		/* En un altre cas ERROR */
		

<string>\n              {fprintf(stderr,"String incorrecte\n");
                        BEGIN 0;}

<string>\"				{*s='\0';
                        BEGIN 0;
                        return STRING;}

        /* La resta de simbols s'emmagatzemen directament */

<string>.				{*s=yytext[0];
                         s++;}

.|\n					;

%%

/* Seccio PROCEDIMENTS AUXILIARS */

int main( ){
	while (yylex( ) == STRING)
		printf("String OK: %s \n", buf);
}

int yywrap(){
	return(1);
}
