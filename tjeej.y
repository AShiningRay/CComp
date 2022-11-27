%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "lex.yy.c"

    int errorcount = 0;
    int yylineno;
    
    void yyerror(const char *str);
    int yylex();
    int yywrap();
%}

/* Tokens currently supported by the scanner */
%token VOID CHARACTER PRINTF SCANF INT FLOAT CHAR FOR IF ELSE 
TRUE FALSE NUMBER FLOAT_NUM ID LE GE EQ NE GT LT AND OR STR 
ADD MULTIPLY DIVIDE SUBTRACT UNARY INCLUDE RETURN

/* Grammar definitions for the language */
%%

/* Defines the overall C program structure, usually composed of 
headers, the main function and its body, then the return statement */
prog: headers main '(' ')' '{' body return '}'
;

/* Defines the way by which includes are parsed. having two 'headers'
concatenated allows us to parse multiple header lines */
headers: headers headers
| INCLUDE
;

/* The currently supported datatypes are int, float, char and void */
datatype: INT 
| FLOAT 
| CHAR
| VOID
;

/* For now, main doesn't support receiving any arguments */
main: datatype ID
;

/* For the body, we have a set of rules of tokens, statements, loops
and conditionals that allows us to create a slew of different programs*/
body: FOR '(' stmt ';' cond ';' stmt ')' '{' body '}'
| IF '(' cond ')' '{' body '}' else
| stmt ';' 
| body body
| PRINTF '(' STR ')' ';'
| SCANF '(' STR ',' '&' ID ')' ';'
;

/* A statement can be a datatype initialization, an attribution to an 
identifier, a relationa operation between identifier and expression, etc. */
stmt: datatype ID init 
| ID '=' expr 
| ID relop expr
| ID UNARY 
| UNARY ID;

/* A condition expresses the result of a relational operator between
two values, and can return either true or false */
cond: value relop value 
| TRUE 
| FALSE
;

/* This production is a continuation of the IF ... else rule in the "body:"
definition above, and allows for the use of if-else as well as a single if. */
else: ELSE '{' body '}'
|
;

/* Values can be a number, a float, a character and an identifier */
value: NUMBER
| FLOAT_NUM
| CHARACTER
| ID
;

/* As for the relational operators, we have the usual ones:
LT - Lower than
GT - Greater than
LE - Lower or equal to
GE - Greater or equal to
EQ - Equal to
NE - Not equal to */
relop: LT
| GT
| LE
| GE
| EQ
| NE
;

/* In C, we don't actually need to initialize a variable when 
declaring it, so the init definition can be produced into null */
init: '=' value 
|
;

/* Expressions can have arithmetic inside them, but they can also not
have any arithmetic at all */
expr: expr arith expr
| value
;

/* Arithmetic is initially comprised of addition, subtraction,
multiplication and division */
arith: ADD
| SUBTRACT
| MULTIPLY
| DIVIDE
;

/* Return is yet another definition that can be produced into null
since we don't need to explicitly issue a return command in C's 
functions all the time. */
return: RETURN value ';' 
|
;

%%

int main() {
    yyparse();
}

void yyerror(const char* msg) {
    errorcount++;
    printf ("Parse error at line %d: %s\n", yylineno, msg);
}