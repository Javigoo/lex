
/* 	Escolliu un llenguatge i, per a aquest llenguatge, implementeu una especificacio lex que calculi el nombre */
/* 	de paraules reservades, identificadors, constants (enteres, reals, de caracter, de cadena -string- ....), */
/* 	operadors (aritmetics, logics, relacionals, d’assignacio ....), sımbols delimiters (’(’, ’)’, ’[’, ’]’, ’’, ’’, ’,’, ’;’ ...), */
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
#define SEPARATOR 405
#define COMMENT 406
#define OTHER 407

/* Contadores */
int keywords = 0;
int identifiers = 0;
int constants = 0;			/* enteres, reals, de caracter, de cadena -string- */
int operators = 0;			/* aritmetics, logics, relacionals, d’assignacio */
int delimiters = 0;		/* (’(’, ’)’, ’[’, ’]’, ’’, ’’, ’,’, ’;’ ...) */
int separators = 0;		/* blancs, tabuladors, new line */
int comments = 0;
int others = 0;			

void identify_token(int);
void get_statistics();
float get_percentage(int, int);
const char* escape_separator_characters(int);

%}

keywords		(False|await|else|import|pass|None|break|except|in|raise|True|class|finally|is|return|and|continue|for|lambda|try|as|def|from|nonlocal|while|assert|del|global|not|with|async|elif|if|or|yield)
identifiers		(\+|-|\*|\/|%|\/\/|\*\*|<|>|==|!=|>=|<=|&|\||~|\^|>>|<<|=|\+=|-=|\*=|\/=|%=|\/\/=|\*\*=|&=|\|=|\^=|>>=|<<=|is|is\snot|in|not\sin)
constants		[a-zA-Z_][a-zA-Z0-9_]*
operators		\"[^\"\n]*\"|[0-9]+|[0-9]*\.[0-9]+
delimiters		(\(|\)|\[|\]|,|:)
separators		(\ |\t|\n)
comments		#.*
others			.

%%

{keywords}		return KEYWORD;

{identifiers}	return OPERATOR;

{constants}		return ID;

{operators}		return CONSTANT;

{delimiters}	return DELIMITATOR;

{separators}	return SEPARATOR;

{comments}		return COMMENT;

{others}		return OTHER;

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
			printf("KEYWORD:\t%s\n",yytext);
			keywords++;
			break;
		case ID:
			printf("ID:\t\t%s\n",yytext);
			identifiers++;
			break;
		case CONSTANT:
			printf("CONSTANT:\t%s\n",yytext);
			constants++;
			break;
		case OPERATOR:
			printf("OPERATOR:\t%s\n",yytext);
			operators++;
			break;
		case DELIMITATOR:
			printf("DELIMITATOR:\t%s\n",yytext);
			delimiters++;
			break;
		case SEPARATOR:
			printf("SEPARATOR:\t%s\n", escape_separator_characters(yytext[0]));
			separators++;
			break;
		case COMMENT:
			printf("COMMENT:\t%s\n",yytext);
			comments++;
			break;
		case OTHER:
			printf("OTHER:\t%s\n",yytext);
			others++;
			break;
		default:
			printf("ERROR:\t%s\n",yytext);
	}
}

void get_statistics(){
	int total= keywords + identifiers + constants + operators + delimiters + separators + comments + others;
	printf("\n");
	printf("Palabras reservadas: %.2f%%\n", get_percentage(keywords,total));
	printf("Identificadores: %.2f%%\n", get_percentage(identifiers,total));
	printf("Constantes: %.2f%%\n", get_percentage(constants,total));
	printf("Operadores: %.2f%%\n", get_percentage(operators,total));
	printf("Delimitadores: %.2f%%\n", get_percentage(delimiters,total));
	printf("Separadores: %.2f%%\n", get_percentage(separators,total));
	printf("Comentarios: %.2f%%\n", get_percentage(comments,total));
	printf("Otros: %.2f%%\n", get_percentage(others,total));
}

float get_percentage(int amount, int total){
	return (amount/ (float) total)*100;
}

const char* escape_separator_characters(int ascii_character){
	switch(ascii_character) {
		case 32:
			return "\\s";
		case 9:
			return "\\t";
		case 10:
			return "\\n";
		break;
	}
	return "Unrecognized separator character";
}