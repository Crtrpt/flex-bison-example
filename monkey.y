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

%union {
	int ival;
    float fval;
}

%token<ival> T_INT
%token<fval> T_FLOAT
%token       T_STR
%token T_PLUS T_MINUS T_MULTIPLY T_DIVIDE T_LEFT T_RIGHT
%token T_NEWLINE
%token T_VAR T_LET T_CONST T_VARNAME T_ASSIGN 
%token T_COMMENT
%token T_MULTI_COMMENT
%token T_DUMP
%token T_AS 
%token T_IS
%token T_SCOPE_START T_SCOPE_END
%token T_ANNOTAION
%token T_TYPE

%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVIDE

%type<ival> expression

%start monkey


%%
monkey:
    | monkey statement
    | T_COMMENT       {printf("单行1注释\n");}
    | T_MULTI_COMMENT {printf("多行注释");}
    | T_NEWLINE
;



statement: 
 T_AS         {printf("转换");}
    | T_IS          {printf("检测");}
    | T_VAR         {printf("定义\n");}
    | T_SCOPE_START {printf("作用域开始");}
    | T_SCOPE_END   {printf("作用域结束");}
    | expression
    | T_DUMP expression                         { printf("\n----\n %d  \n----\n",$2); }
    | T_SCOPE_START statement T_SCOPE_END       {printf("作用域");}

    | T_CONST T_VARNAME T_ASSIGN expression     {printf("定义常量\n");} 
    | T_VAR T_VARNAME T_ASSIGN expression       {printf("定义变量\n");} 
    | T_LET T_VARNAME T_ASSIGN expression       {printf("定义范围内变量\n");} 
;
    
expression:
      T_VARNAME                             { printf("变量名称\n"); }  
      | T_STR                               { printf("字符串\n"); }
      | T_FLOAT                             { printf("浮点数\n"); }
      | T_INT				                { $$ = $1;   }
	  | expression T_PLUS expression	    { $$ = $1 + $3; }
	  | expression T_MINUS expression	    { $$ = $1 - $3; }
	  | expression T_MULTIPLY expression	{ $$ = $1 * $3; }
      | expression T_DIVIDE expression      { $$= $1/$3; }
	  | T_LEFT expression T_RIGHT		    { $$ = $2; }
;

%%

int main() {

    FILE *fp = fopen("./test.yy", "r");
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




