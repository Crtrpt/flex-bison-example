%option noyywrap
%option yylineno
%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "monkey.tab.h"

int lineNumber = 1;

void end_lexical_scan(void) {
   yy_delete_buffer(YY_CURRENT_BUFFER);
}

void set_input_string(const char* in) {
    yy_scan_string(in);
}

void yyerror(const char* msg) {
    printf("LINE:[%d]  ERROR:  %s \n",lineNumber,msg );
   
	exit(1);
}

%}


DIGIT    [0-9]
ID       [a-z][a-z0-9]*

%%

[ \t\r\n]+  {/* eat up whitespace */}

{DIGIT}+	            {yylval.ival = atoi(yytext); return T_INT;}
['"]{1,1}(.*)['"]{1,1}  {return T_STR;}         //字符串

"+"		                {return T_PLUS;}        //加
"-"		                {return T_MINUS;}       //减
"*"		                {return T_MULTIPLY;}    //乘
"/"		                {return T_DIVIDE;}      //除

"="                     {return T_ASSIGN;}       //赋值

"("		                {return T_LEFT;}
")"		                {return T_RIGHT;}

":"                     {return T_ANNOTATION;}  //注解
"var"                   {return T_VAR;}     //函数作用域
"const"                 {return T_CONST;}   //函数作用域 常量
"let"                   {return T_LET;}     //域作用域 变量

"func"                  {printf("定义一个变量名\n"); return T_DEF_FUNC;}

";"                     { return T_SEMICOLON; }

"{"		                {printf("创建作用域\n"); return T_SCOPE_START;} //作用域开始
"}"		                {printf("结束作用域\n"); return T_SCOPE_END;}   //作用域结束

{ID}                    {return T_VARNAME;}       //变量名

%%