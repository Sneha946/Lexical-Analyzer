%{
#include <stdio.h>
#include <string.h>
#include "parser.tab.h"   // From Bison
extern YYSTYPE yylval;
extern int yylineno;
%}

%option yylineno

%%

"int"     { printf("Line %d: %s:DATATYPE\n", yylineno, yytext); yylval.str = strdup(yytext); return DATATYPE; }
"float"   { printf("Line %d: %s:DATATYPE\n", yylineno, yytext); yylval.str = strdup(yytext); return DATATYPE; }
"char"    { printf("Line %d: %s:DATATYPE\n", yylineno, yytext); yylval.str = strdup(yytext); return DATATYPE; }


"if"      { printf("Line %d: %s:KEYWORD\n", yylineno, yytext); return KEYWORD; }
"else"    { printf("Line %d: %s:KEYWORD\n", yylineno, yytext); return KEYWORD; }
"while"   { printf("Line %d: %s:KEYWORD\n", yylineno, yytext); return KEYWORD; }
"print"   { printf("Line %d: %s:KEYWORD\n", yylineno, yytext); return KEYWORD; }


[0-9]+\.[0-9]+   { printf("Line %d: %s:FLOAT\n", yylineno, yytext); yylval.fnum = atof(yytext); return FLOAT; }
[0-9]+           { printf("Line %d: %s:NUMBER\n", yylineno, yytext); yylval.num = atoi(yytext); return NUMBER; }

[a-zA-Z_][a-zA-Z0-9_]* { printf("Line %d: %s:IDENTIFIER\n", yylineno, yytext); yylval.str = strdup(yytext); return IDENTIFIER; }

"=="        { printf("Line %d: %s:SYMBOL\n", yylineno, yytext); return EQ; }
">="        { printf("Line %d: %s:SYMBOL\n", yylineno, yytext); return GE; }
"<="        { printf("Line %d: %s:SYMBOL\n", yylineno, yytext); return LE; }
">"         { printf("Line %d: %s:SYMBOL\n", yylineno, yytext); return '>'; }
"<"         { printf("Line %d: %s:SYMBOL\n", yylineno, yytext); return '<'; }
"="         { printf("Line %d: %s:SYMBOL\n", yylineno, yytext); return '='; }
";"         { printf("Line %d: %s:SYMBOL\n", yylineno, yytext); return SYMBOL; }
","         { printf("Line %d: %s:SYMBOL\n", yylineno, yytext); return SYMBOL; }
"("         { printf("Line %d: %s:SYMBOL\n", yylineno, yytext); return SYMBOL; }
")"         { printf("Line %d: %s:SYMBOL\n", yylineno, yytext); return SYMBOL; }
"{"         { printf("Line %d: %s:SYMBOL\n", yylineno, yytext); return SYMBOL; }
"}"         { printf("Line %d: %s:SYMBOL\n", yylineno, yytext); return SYMBOL; }
"+"         { printf("Line %d: %s:SYMBOL\n", yylineno, yytext); return '+'; }
"-"         { printf("Line %d: %s:SYMBOL\n", yylineno, yytext); return '-'; }
"*"         { printf("Line %d: %s:SYMBOL\n", yylineno, yytext); return '*'; }
"/"         { printf("Line %d: %s:SYMBOL\n", yylineno, yytext); return '/'; }


[ \t\r]+    { /* ignore */ }
\n          { /*yylineno++;*/ }


.           { printf("Line %d: %s:UNKNOWN\n", yylineno, yytext); }

%%

int yywrap() {
    return 1;
}
