%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

extern int yylex();
extern int yyparse();

void yy_scan_string(const char* in);
void set_input_string(const char* in);
void end_lexical_scan(void);

void yyerror(const char* msg);
%}

%defines

%union {
	int   ival;
}

%token<ival> T_INT
%token T_PLUS T_MINUS T_MULTIPLY T_DIVIDE T_LEFT T_RIGHT
%token T_VARNAME
%token T_DUMP

%token T_SEMICOLON
%token T_STR
%token T_SCOPE_START;
%token T_SCOPE_END;
%token T_ASSIGN;
%token T_ANNOTATION;

%token T_DEF_FUNC;

%token T_VAR;
%token T_LET;
%token T_CONST;

%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVIDE

%type<ival> expression

%start program

%%
program:
    statement program
    | T_SEMICOLON
    | func_def
    | statement
;

func_def:
    T_DEF_FUNC T_VARNAME T_LEFT  T_RIGHT func_ret func_body
;
func_ret:
    anotation
func_body:
    T_SCOPE_START statement  T_SCOPE_END        {printf("定义一个函数\n");}
//语句
statement: 
    scope  
    | expression  T_SEMICOLON                 
    | T_DUMP expression                         {printf("打印表达式\n");}
    | T_VAR T_VARNAME  anotation  T_ASSIGN  statement       {printf("定义函数变量\n");}
    | T_CONST T_VARNAME anotation  T_ASSIGN  statement     {printf("定义函数常量\n");}
    | T_LET T_VARNAME anotation    T_ASSIGN  statement       {printf("定义作用域变量\n");}
;

anotation:
    T_ANNOTATION T_VARNAME 
scope:
    T_SCOPE_START statement  T_SCOPE_END
    
//表达式
expression:
      T_VARNAME                             { printf("定义一个变量\n"); }  
      | T_STR                               { printf("字符串\n"); }
      | T_INT				                { $$ = $1;   }
	  | expression T_PLUS expression	    { $$ = $1 + $3; }
	  | expression T_MINUS expression	    { $$ = $1 - $3; }
	  | expression T_MULTIPLY expression	{ $$ = $1 * $3; }
      | expression T_DIVIDE expression      { $$= $1/$3; }
	  | T_LEFT expression T_RIGHT		    { $$ = $2; }
;

%%

int main() {

    FILE *fp = fopen("./test.m", "r");
    fseek(fp, 0L, SEEK_END);
    int sz = ftell(fp);
    printf("源码文件大小:%d \n",sz);
    char* mptr = (char*) calloc(sz, 2);
    fseek(fp, 0L, 0);
    fread(mptr,sz,1,fp);    

    set_input_string(mptr);
    int rv=yyparse();
    end_lexical_scan();
    free(mptr);
    return 0;
}




