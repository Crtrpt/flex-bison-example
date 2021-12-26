%option noyywrap
%option yylineno
%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "egg.tab.h"

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

%%

[\t]	;               // 忽略的空白字符
[0-9]+\.[0-9]+ 	        {yylval.fval = atof(yytext); return T_FLOAT;}
[0-9]+	                {yylval.ival = atoi(yytext); return T_INT;}
['"]{1,1}(.*)['"]{1,1}  {return T_STR;}         //字符串
[\n;]  	                {return T_NEWLINE;}     //新行
"+"		                {return T_PLUS;}        //加
"-"		                {return T_MINUS;}       //减
"*"		                {return T_MULTIPLY;}    //乘
"/"		                {return T_DIVIDE;}      //除

"("		                {return T_LEFT;}
")"		                {return T_RIGHT;}

"{"		                {return T_SCOPE_START;} //作用域开始
"}"		                {return T_SCOPE_END;}   //作用域结束


(\/\*)(.*)(\*\/)        {return T_MULTI_COMMENT;}  //多行注释
(\/\/)(.*)              {return T_COMMENT;}

"is"                    {return T_IS;}           //检测类型
"as"                    {return T_AS;}           //转换类型

":"                     {return T_ANNOTAION;}    //注解
"="                     {return T_ASSIGN;}       //赋值
"var"                   {return T_VAR;}          //函数作用域
"let"                   {return T_LET;}          //块作用域
"const"                 {return T_CONST;}        //常量
"dump"                  {return T_DUMP;}         //打印堆栈
[a-zA-Z][a-zA-Z0-9]*    {return T_VARNAME;}         //变量名

%%