%option noyywrap
%option yylineno
%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "calc.tab.h"

int lineNumber = 1;

void end_lexical_scan(void) {
   yy_delete_buffer(YY_CURRENT_BUFFER);
}


void set_input_string(const char* in) {
    yy_scan_string(in);
}


void yyerror(const char* msg) {
    printf("ERROR:  %s  LINE:%d",msg, lineNumber);
	exit(1);
}

%}

%%



[ \t]	; // ignore all whitespace
[0-9]+		{yylval.ival = atoi(yytext); return T_INT;}
\n		{return T_NEWLINE;}
"+"		{return T_PLUS;}
"-"		{return T_MINUS;}
"*"		{return T_MULTIPLY;}
"/"		{return T_DIVIDE;}
"("		{return T_LEFT;}
")"		{return T_RIGHT;}
"exit"		{return T_QUIT;}
"quit"		{return T_QUIT;}

%%
