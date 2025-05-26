%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyin;
extern int yylex();
extern int yylineno;
void yyerror(const char *s);

typedef struct Symbol {
    char *name;
    char *type;
    int line;
    struct Symbol *next;
} Symbol;

Symbol *symbolTable = NULL;

void addSymbol(char *name, char *type, int line) {
    Symbol *s = malloc(sizeof(Symbol));
    s->name = strdup(name);
    s->type = strdup(type);
    s->line = line;     // store the line number here
    s->next = symbolTable;
    symbolTable = s;
}


int isDeclared(char *name) {
    Symbol *s = symbolTable;
    while (s) {
        if (strcmp(s->name, name) == 0)
            return 1;
        s = s->next;
    }
    return 0;
}


void printSymbols() {
    printf("SYMBOL_TABLE_START\n");
    Symbol *s = symbolTable;
    while (s) {
        printf("{\"name\":\"%s\",\"type\":\"%s\",\"line\":%d}\n", s->name, s->type, s->line);
        s = s->next;
    }
    printf("SYMBOL_TABLE_END\n");
}



%}

%union {
    int num;
    float fnum;
    char* str;
}

%token <str> IDENTIFIER DATATYPE KEYWORD
%token <num> NUMBER
%token <fnum> FLOAT
%token SYMBOL

%token GE LE EQ  /* for >= <= == */

%left '+' '-'
%left '*' '/'
%nonassoc '<' '>' GE LE EQ  /* relational ops */

%type <str> datatype 
%%

program:
    program statement
    | /* empty */
    ;

statement:
    declaration_statement
    | assignment_statement
    | expression_statement
    | initialization_statement
    ;

declaration_statement:
    datatype IDENTIFIER SYMBOL   { 
        if (isDeclared($2)) {
            yyerror("Error: Redeclaration of variable ");
        } else {
            addSymbol($2, $1, yylineno);   // Pass yylineno here
            printf("Declared %s %s\n", $1, $2);
        }
    }
    ;

assignment_statement:
    IDENTIFIER '=' expression SYMBOL {
        if (!isDeclared($1)) {
            char errMsg[256];
            snprintf(errMsg, sizeof(errMsg), "Error: Undeclared variable %s", $1);
            yyerror(errMsg);

        } else {
            printf("Assigned to %s\n", $1);
        }
    }
    ;

expression_statement:
    expression SYMBOL {
        /* just evaluate and ignore */
    }
    ;
initialization_statement:
    datatype IDENTIFIER '=' expression SYMBOL { 
        if (isDeclared($2)) {
            char errMsg[256];
            snprintf(errMsg, sizeof(errMsg), "Error: Redeclaration of variable %s", $2);
            yyerror(errMsg);
        } else {
            addSymbol($2, $1, yylineno);   // Pass yylineno here
            printf("Declared %s %s\n", $1, $2);
        }
    }
    ;


datatype:
    DATATYPE { $$ = strdup($1); }
    ;

expression:
    NUMBER
    | FLOAT
    | IDENTIFIER
    | expression '+' expression
    | expression '-' expression
    | expression '*' expression
    | expression '/' expression
    | expression '>' expression
    | expression '<' expression
    | expression GE expression
    | expression LE expression
    | expression EQ expression
    | '(' expression ')'
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "ERROR: Parse error at line %d: %s\n", yylineno, s);
}


int main() {
    FILE *file = fopen("code.txt", "r");
    if (!file) {
        perror("Error opening code.txt");
        return 1;
    }

    yyin = file;  // Connect lexer to the file
    printf("Starting parser\n");
    yyparse();
    printSymbols();
    fclose(file);
    return 0;
}
