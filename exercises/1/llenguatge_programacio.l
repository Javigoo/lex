
/* 	Escolliu un llenguatge i, per a aquest llenguatge, implementeu una especificacio lex que calculi el nombre */
/* 	de paraules reservades, identificadors, constants (enteres, reals, de caracter, de cadena -string- ....), */
/* 	operadors (aritmetics, logics, relacionals, d’assignacio ....), sımbols delimitadors (’(’, ’)’, ’[’, ’]’, ’’, ’’, ’,’, ’;’ ...), */
/* 	sımbols de separacio (blancs, tabuladors, new line ...) i comentaris que apareixen en un programa escrit en el llenguatge. */
/* 	Podeu ignorar qualsevol altre component. Per a cada categoria de components del llenguatge, indiqueu la proporcio que */
/* 	representa respecte del total analitzat. El nom del fitxer d’entrada sera proporcionat per l’usuari des de lınia de comanda. */
/* 	La sortida s’escriura directament a la sortida estandard. */

%option nounput
%option noinput


%{

#define KEYWORD 400
#define ID 401
#define CONSTANT 402
#define OPERATOR 403
#define DELIMITATOR 404
#define SEPARATION 405
#define COMMENT 406
#define OTHER 407

/* Contadores */
int keywords = 0;
int identifiers = 0;
int constants = 0;			/* enteres, reals, de caracter, de cadena -string- */
int operators = 0;			/* aritmetics, logics, relacionals, d’assignacio */
int delimitadors = 0;		/* (’(’, ’)’, ’[’, ’]’, ’’, ’’, ’,’, ’;’ ...) */
int separations = 0;		/* blancs, tabuladors, new line */
int comments = 0;
int others = 0;			

void identify_token(int);
void get_statistics();
float get_percentage(int, int);

%}


%%

#.*						return COMMENT;

.						return OTHER;

%%


#include <stdio.h>

int main(){
  	int token;

	while ((token=yylex())!=0){
		identify_token(token);
	}

	get_statistics();
}

int yywrap(){
	return(1);
}

void identify_token(int token){
	switch(token){
		case KEYWORD:
			printf("El token \"%s\" es una palabra reservada\n",yytext);
			keywords++;
			break;
		case ID:
			printf("El token \"%s\" es un identificador\n",yytext);
			identifiers++;
			break;
		case CONSTANT:
			printf("El token \"%s\" es una constante\n",yytext);
			constants++;
			break;
		case OPERATOR:
			printf("El token \"%s\" es un operador\n",yytext);
			operators++;
			break;
		case DELIMITATOR:
			printf("El token \"%s\" es un delimitador\n",yytext);
			delimitadors++;
			break;
		case SEPARATION:
			printf("El token \"%s\" es un separador\n",yytext);
			separations++;
			break;
		case COMMENT:
			printf("El token \"%s\" es un comentario\n",yytext);
			comments++;
			break;
		case OTHER:
			printf("El token \"%s\" forma parte de una categoria ignorada\n",yytext);
			others++;
			break;
		default:
			printf("ERROR: \"%s\"",yytext);
	}
}

void get_statistics(){
	int total= keywords + identifiers + constants + operators + delimitadors + separations + comments + others;
	printf("\n");
	printf("Palabras reservadas: %.2f%%\n", get_percentage(keywords,total));
	printf("Identificadores: %.2f%%\n", get_percentage(identifiers,total));
	printf("Constantes: %.2f%%\n", get_percentage(constants,total));
	printf("Operadores: %.2f%%\n", get_percentage(operators,total));
	printf("Delimitadores: %.2f%%\n", get_percentage(delimitadors,total));
	printf("Separadores: %.2f%%\n", get_percentage(separations,total));
	printf("Comentarios: %.2f%%\n", get_percentage(comments,total));
	printf("Otros: %.2f%%\n", get_percentage(others,total));
}

float get_percentage(int amount, int total){
	return (amount/ (float) total)*100;
}