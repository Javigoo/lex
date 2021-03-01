	/* Identificar string simple C */

%option nounput
%option noinput

%x inside_quotes

%%

\"                  BEGIN(inside_quotes);

.|\n   {}

<inside_quotes>\\\"   ECHO;

<inside_quotes>\"    {
                    printf("\n");
                    BEGIN(INITIAL);
}

<inside_quotes>.   ECHO;
