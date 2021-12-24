%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

extern int yylex();
extern int yyparse();

void yy_scan_string(const char* in);
void set_input_string(const char* in);
void end_lexical_scan(void);

void yyerror(const char* msg);
%}

%union {
	int ival;
}

%token<ival> T_INT
%token T_PLUS T_MINUS T_MULTIPLY T_DIVIDE T_LEFT T_RIGHT
%token T_NEWLINE T_QUIT

%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVIDE

%type<ival> expression

%start egg

%%
egg:
    | egg line
;

line: T_NEWLINE
    | expression T_NEWLINE { printf("-> %i\n", $1); }
    | T_QUIT T_NEWLINE { printf("bye\n"); exit(0); }
;

expression: T_INT				{ $$ = $1;   }
	  | expression T_PLUS expression	{ $$ = $1 + $3; }
	  | expression T_MINUS expression	{ $$ = $1 - $3; }
	  | expression T_MULTIPLY expression	{ $$ = $1 * $3; }
	  | T_LEFT expression T_RIGHT		{ $$ = $2; }
;

%%

int main() {

    FILE *fp = fopen("./test.yy", "r");
    FILE *fp1 = fopen("file.txt", "w+");
    fseek(fp, 0L, SEEK_END);
    int sz = ftell(fp);
    printf("file size:%d \nchar size: %d \n",sz,sizeof (char));
    char* mptr = (char*) calloc(sz, 2);
    fseek(fp, 0L, 0);
    fread(mptr,sz,1,fp);
    printf("=============start\n");
    printf("%s\n",mptr);
    printf("=============end");

    fwrite(mptr, sz, 1, fp1);
    free(mptr);

    //mptr="\r\n3+3\n4+3\n";
    set_input_string(mptr);
    int rv=yyparse();
    end_lexical_scan();
    return 0;
}




