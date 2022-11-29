/* TurboJeeJio C Scanner */
%{
    #include "tjeej.tab.h"
    int linecount=0; /* Stores the line number for debugging */
    extern int yycolno;
%}

/* yylineno creates a scanner that keeps track of the line number */
%option yylineno 

letter [a-zA-Z]
digit  [0-9]
unary  "++"|"--"

/* Scanner ruleset, last rule is reserved for unrecognized tokens */
/* "auto" { return AUTO; }, although part of the spec, shouldn't be used at all */
%%

"printf"                                                                           { return PRINTF; }
"scanf"                                                                            { return SCANF; }
"char"|"signed char"                                                               { return CHAR8; }
"unsigned char"                                                                    { return UCHAR8; }
"int"|"signed int"|"signed"|"short"|"short int"|"signed short"|"signed short int"  { return INT16; }
"unsigned"|"unsigned int"|"unsigned short"|"unsigned short int"                    { return UINT16; }
"long int"|"signed long int"|"long"|"signed long"                                  { return INT32; }
"unsigned long"|"unsigned long int"                                                { return UINT32; }
"long long"|"signed long long"|"long long int"|"signed long long int"              { return INT64; }
"unsigned long long"|"unsigned long long int"                                      { return UINT64; }
"float"                                                                            { return FLOAT32; }
"double"                                                                           { return FLOAT64; }
"long double"                                                                      { return FLOAT128; }
"bool"                                                                             { return BOOL; }
"void"                                                                             { return VOID; }
"return"                                                                           { return RETURN; }
"for"                                                                              { return FOR; }
"if"                                                                               { return IF; }
"else"                                                                             { return ELSE; }
"break"                                                                            { return BREAK; }
"case"                                                                             { return CASE; }
"const"                                                                            { return CONST; }
"continue"                                                                         { return CONTINUE; }
"default"                                                                          { return DEFAULT; }
"do"                                                                               { return DO; }
"enum"                                                                             { return ENUM; }
"extern"                                                                           { return EXTERN; }
"goto"                                                                             { return GOTO; }
"static"                                                                           { return STATIC; }
"while"                                                                            { return WHILE; }
"sizeof"                                                                           { return SIZEOF; }
"union"                                                                            { return UNION; }
"register"                                                                         { return REGISTER; }
"switch"                                                                           { return SWITCH; }
"typedef"                                                                          { return TYPEDEF; }
"volatile"                                                                         { return VOLATILE; }
^"#include"[ ]*<.+\.h>                                                             { return INCLUDE; }
"true"                                                                             { return TRUE; }
"false"                                                                            { return FALSE; }
(_|{letter})({letter}|{digit}|_)*                                                  { return ID; }
[-]?{digit}+                                                                       { return NUMBER; }
{unary}                                                                            { return UNARY; }
"<="                                                                               { return LE; }
">="                                                                               { return GE; }
"=="                                                                               { return EQ; }
"!="                                                                               { return NE; }
">"                                                                                { return GT; }
"<"                                                                                { return LT; }
"&&"                                                                               { return AND; }
"||"                                                                               { return OR; }
"+"                                                                                { return ADD; }
"-"                                                                                { return SUBTRACT; }
"/"                                                                                { return DIVIDE; }
"*"                                                                                { return MULTIPLY; }
[-]?{digit}+\.{digit}{1,9}                                                         { return FLOAT_NUM; }
\/\/.*                                                                             { ; }
\/\*(.*\n)*.*\*\/                                                                  { ; }
[ \t]*                                                                             { yycolno += 4; }
[\n]                                                                               { linecount++; yycolno = 1; }
["].*["]                                                                           { return STR; }
['].[']                                                                            { return CHARACTER; }
"("                                                                                { return LPAR; }
")"                                                                                { return RPAR; }
"{"                                                                                { return LBRACK; }
"}"                                                                                { return RBRACK; }
"["                                                                                { return LBRACE; }
"]"                                                                                { return RBRACE; }
"="                                                                                { return ATTRIB; }
";"                                                                                { return STMTEND; }
","                                                                                { return COMMA; }
.                                                                                  { return printf("Unrecognized token at line %d, column %d: '%s'\n", yylineno, yycolno, yytext); }

%%


/* Scanner subroutines, only has yywrap for now, returning 1 
whenever the scanner has finished scanning a source file. */
int yywrap()
{
    return 1;
}
