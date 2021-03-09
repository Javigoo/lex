
%option nounput
%option noinput


%{
#include <stdio.h>
#include <assert.h>

#define MAX_NAME 100

typedef struct dict_t_struct {
    char *key;
    void *value;
    struct dict_t_struct *next;
} dict_t;

void addItem(dict_t **, char *, void *);
void *getItem(dict_t *, char *);

dict_t **dict;

%}

%X COMMENT INCLUDE DEFINE

simbols [a-zA-Z0-9_ ]


%%

    char filename[ MAX_NAME+1 ];        

^"#include"[ \t]+          BEGIN( INCLUDE );

<INCLUDE>(\"|\<){simbols}+(\.{simbols}+)?(\"|\>)   {
                                                    strcpy( filename, &yytext[1] );            /* treiem les comestes inicials */
                                                    filename[ yyleng-2 ] = '\0';               /* treiem les comestes finals */
                                                    yyin = fopen( filename, "r" );
                                                    assert( yyin != NULL );                     /* filename ok? */
                                                    yypush_buffer_state( yy_create_buffer( yyin, YY_BUF_SIZE ) );
                                                    BEGIN( INITIAL );
                                                    }

^"#define"[ \t]+          BEGIN( DEFINE  );

<DEFINE>[A-Z]+\ .*\n                                {
                                                    char *key = strtok(yytext, " ");
                                                    char *value = strtok(NULL, " ");
                                                    printf("DEBUG -> %s=%s\n", key, value);

                                                    addItem(dict, key, value);
                                                    BEGIN( INITIAL );
                                                    }

[A-Z]+                                              {
                                                    char *match = yytext;
                                                    if(getItem(*dict, match) != NULL){
                                                        printf("%s",getItem(*dict, match));
                                                    }else{
                                                        yymore();
                                                    }
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
   dict = malloc(sizeof(dict_t));
   yyin = fopen( argv[ 1 ], "r" );
   yylex();
   return 0;
}

void addItem(dict_t **dict, char *key, void *value) {
    dict_t *d = malloc(sizeof(struct dict_t_struct));
    d->key = malloc(strlen(key)+1);
    strcpy(d->key, key);
    d->value = value;
    d->next = *dict;
    *dict = d;
}

void *getItem(dict_t *dict, char *key) {
    dict_t *ptr;
    for (ptr = dict; ptr != NULL; ptr = ptr->next) {
        if (strcmp(ptr->key, key) == 0) {
            return ptr->value;
        }
    }
    
    return NULL;
}