#include <stdio.h>
#include <ctype.h>

#define NUMBER 400
#define COMMENT 401
#define STRING 402
#define ID 403

int lexer();

int main(){
  int val;
  
  while ((val=lexer())!=0)
	printf("El token identificat te codi %d\n",val);
}

int lexer(){
  int c;
  while ((c=getchar())==' ' || c=='\t' || c=='\n') ;
  if (c==EOF)
	return 0;
  if (c=='.' ||isdigit(c)){     // constant numerica
	while ((c=getchar())!=EOF && isdigit(c));
	if (c=='.')
		while ((c=getchar())!=EOF && isdigit(c));
	ungetc(c,stdin);    // gestió buffer
	return NUMBER;
  }
  if (c=='#'){      // comentari
	while ((c=getchar())!=EOF && c!='\n');
	ungetc(c,stdin);
	return COMMENT;
  }
  if (c=='\"'){     // literal
	while ((c=getchar())!=EOF && c!='\"' && c!='\n');
	if (c!='\"')
		ungetc(c,stdin);
	return STRING;
  }
  if (isalpha(c)){
      while ((c=getchar())!=EOF && isalnum(c));
      ungetc(c,stdin);
      return ID;
  }
  return c; // resta de simbols
} // lexer( )
