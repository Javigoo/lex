    /* Llenguatge de la l`ogica proposicional */


%option nounput
%option noinput


%{
#define SYMBOL 400
#define COMMENT 401
#define ID 403
#define ERROR 404
#define NEWLINE 402
%}

%%
\n return NEWLINE;

[ \t\r]+ 	;	/* Ignora blancs, tabuladors fora de string i Carriage Return*/

(\)|\() |
(!|^|v) |
(<->|->)             return SYMBOL;	/* symbols */

#.*				return COMMENT;		/* comentaris inici #, final new line */

[A-Z]	return ID;		/* identificadors */

. return ERROR;
%%

#include <stdio.h>

int main(){
  int val;
  int counter=1;
  int ignore=0;
  while ((val=yylex())!=0){
    if (val==NEWLINE){
        counter++;
        if (ignore==1){ 
            ignore=0;
        }
        printf("\n");
    }else{
        if (ignore==0){
            if (val==ERROR){
                printf("\nError en linea %d con token: %s\n", counter, yytext);
                ignore = 1;
            }else{
                printf("%s", yytext);
            }        
        }        
    }
  }
  printf("\n");
}

int yywrap(){
	return(1);
}