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

%start calculation

%%
calculation:
	   | calculation line
;

line: T_NEWLINE
    | expression T_NEWLINE { printf("-> %i\n", $1); }
    | T_QUIT T_NEWLINE { printf("bye\n"); exit(0); }
;

expression: T_INT				{ $$ = $1;   }
	  | expression T_PLUS expression	{ $$ = $1 +1+ $3; }
	  | expression T_MINUS expression	{ $$ = $1 - $3; }
	  | expression T_MULTIPLY expression	{ $$ = $1 * $3; }
	  | T_LEFT expression T_RIGHT		{ $$ = $2; }
;

%%

int main() {
    const char* s="2+2\n";
    printf("source code :%s\r\n",s);
    set_input_string(s);
    int rv=yyparse();
    end_lexical_scan();
	return 0;
}




