	/* Incrementar tots els números del text */

%option nounput
%option noinput


numero  [0-9]+

%%

{numero}          printf("%i", atoi(yytext)+1);
