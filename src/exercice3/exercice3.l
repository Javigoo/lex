    /* Lleguatge de les expressions regulars */


%option nounput
%option noinput


%{
#define SYMBOL 400
#define COMMENT 401
#define NEWLINE 402
#define ID 403
#define ERROR 404
#define BUIDA 405
%}

%%
\n return NEWLINE;

[ \t\r]+ 	;	/* Ignora blancs, tabuladors fora de string i Carriage Return*/

(\)|\() |
(\?|\.|\+) |
(\||\*)             return SYMBOL;	/* symbols */

#.*				return COMMENT;		/* comentaris inici #, final new line */

(BUIDA|buida) return BUIDA;

(a|b|c|d)	return ID;		/* identificadors */

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