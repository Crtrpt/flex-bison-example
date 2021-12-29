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

%token T_STR
%token T_SCOPE_START;
%token T_SCOPE_END;
%token T_ASSIGN;
%token T_ANNOTATION;

%token T_VAR;
%token T_LET;
%token T_CONST;

%token T_TERMINAL;
%token T_OPTIONAL;

%token T_RET;

%token T_COMMENT;

%token T_DEF_FUNC;

%token T_COMMA;
%token T_SEMICOLON;


%token T_BREAK;
%token T_CONTINUE;


%token T_IF;
%token T_ELSE;
%token T_ELSEIF;

%token T_SWITCH;
%token T_CASE;
%token T_DEFAULT;

%token T_WHILE;
%token T_DO;
%token T_FOR;

%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVIDE

%type<ival> expression

%start program

%%
//程序
program:
    | program statement 
    | statement
;

//函数
func_def:
    T_DEF_FUNC T_VARNAME T_LEFT func_param T_RIGHT  optional scope {} 
;

func_param:
    |func_param T_VARNAME                           { printf("定义参数\n");}  
    |func_param T_VARNAME T_COMMA                   { printf("定义参数\n");}  
    |func_param T_VARNAME optional                  { printf("定义参数\n");}  
    |func_param T_VARNAME optional  T_COMMA         { printf("定义参数\n");} 
;
//语句
statement: 
    | statement scope                       { printf("返回语句\n");}  
    | statement T_RET expression            { printf("返回语句\n");}   
    | statement expression                  { printf("表达式语句\n"); }  
    | statement T_DUMP expression           { printf("解析语句\n"); }  
    | statement def_var                     
    | statement T_COMMENT                   { printf("单行注释语句\n"); }     
    | statement func_def                    { printf("定义函数语句\n");}   
    | statement condition                   { printf("定义函数语句\n");}  
    | statement loop     
    | statement T_BREAK                     { printf("跳出循环语句\n");}        
    | statement T_CONTINUE                  { printf("提前继续循环语句\n");}                                   
;

//条件语句
condition:
    T_IF  expression   scope                                           
    | T_IF  expression   scope T_ELSE  scope                            { printf("else语句\n"); } 
    | T_IF  expression   scope condition_elseif                                      { printf("单个elseif\n"); }  
    | T_IF  expression   scope condition_elseif   T_ELSE  scope                      { printf("多个elseif\n"); }                                      
;                       

condition_elseif:
    | condition_elseif T_ELSEIF  expression  scope                          { printf("elseif\n"); }                      
;

//循环语句

loop:
    T_WHILE T_LEFT expression T_RIGHT scope                        { printf("定义while循环语句\n");} 
    | T_FOR T_LEFT expression T_SEMICOLON expression T_SEMICOLON expression T_RIGHT scope    { printf("定义for循环语句\n");} 
;
//定义常量或者变量
def_var:
    def_anotation T_VARNAME T_ASSIGN expression;
//带注解定义
    | def_anotation T_VARNAME  optional T_ASSIGN expression       { printf("强类型定义 语句\n"); } 
;


optional:
    T_ANNOTATION T_VARNAME
    | T_OPTIONAL T_VARNAME
;
def_anotation:
//作用域内定义
    T_LET
//函数内定义
    | T_VAR
    | T_CONST

//作用域
scope:
    T_SCOPE_START statement  T_SCOPE_END
;   
//表达式
expression:
      T_VARNAME                             { printf("定义一个变量\n"); }  
      | T_STR                               { printf("字符串\n"); }
      | T_INT				                { printf("定义一个变量 %d \n",$1); $$ = $1;   }
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




