%{
#include <stdio.h>

// Declare yyin so we can redirect input
extern FILE *yyin;

// We'll print in value:type format for easy parsing
%}

%%

"int"                   { printf("%s:KEYWORD\n", yytext); }
"float"                 { printf("%s:KEYWORD\n", yytext); }
"char"                  { printf("%s:KEYWORD\n", yytext); }
"if"                    { printf("%s:KEYWORD\n", yytext); }
"else"                  { printf("%s:KEYWORD\n", yytext); }
"while"                 { printf("%s:KEYWORD\n", yytext); }

[0-9]+"."[0-9]+         { printf("%s:FLOAT\n", yytext); }
[0-9]+                  { printf("%s:NUMBER\n", yytext); }

[a-zA-Z_][a-zA-Z0-9_]*  { printf("%s:IDENTIFIER\n", yytext); }

">"|"="|"<"|"<="|">="   { printf("%s:OPERATOR\n", yytext); }
"=="                    {printf("%s:DOUBLE OPERATOR\n",yytext);}
"*"|"+"|"-"|"/"         { printf("%s:OPERATOR\n", yytext); }

";"|","|"("|")"|"{"|"}" { printf("%s:SYMBOL\n", yytext); }

[ \t\n]                 { /* ignore whitespace */ }

.                       { printf("%s:UNKNOWN\n", yytext); }

%%

int yywrap() {
    return 1;
}

int main() {
    yyin = fopen("code.txt", "r");
    if (!yyin) {
        perror("Failed to open code.txt");
        return 1;
    }

    yylex();

    fclose(yyin);
    return 0;
}
