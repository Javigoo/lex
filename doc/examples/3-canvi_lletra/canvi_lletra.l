	/* Canviar la lletra inicial de tots els identificadors */

%option nounput
%option noinput

%{

#include <stdlib.h>
#include <time.h>
#include <ctype.h>

void modify_first_character();

%}


identificador  [a-zA-Z]+

%%

{identificador}     {
                        modify_first_character();
                        printf("%s", yytext);
}

%%

void modify_first_character() {
    char c = yytext[0];

        if(isupper(yytext[0])) {
            c = rand() % ('Z' - 'A' + 1) + 'A';
            if (c==yytext[0]) c = '*';
        } else {
            c = rand() % ('z' - 'a' + 1) + 'a';
            if (c==yytext[0]) c = '*';
        }
    yytext[0] = c;
}


int main()
{
    srand (time(NULL));
    yylex();
    return 0;
}
