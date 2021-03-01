	/* Analitzador lexic llenguatge reduit */


%option nounput
%option noinput


%{
#define NUMBER 400
#define COMMENT 401
#define STRING 402
#define ID 403
%}

%%

[ \t\n]+			;	/* Ignora blancs i tabuladors fora de string */
					/* També ignora new line */

[0-9]+	|

[0-9]*\.[0-9]+		return NUMBER;	/* contant entera o real */

#.*				return COMMENT;		/* comentaris inici #, final new line */

\"[^\"\n]*\"			return STRING;		/* string */

[a-zA-Z][a-zA-Z0-9]*	return ID;		/* identificadors */

.				return yytext[0];		/* resta agafem el codi ASCII */

%%

#include <stdio.h>

int main(){
  int val;

  while ((val=yylex())!=0)
	printf("El token identificat te codi %d\n",val);
}

int yywrap(){
	return(1);
}
