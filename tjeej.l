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

/* Scanner ruleset */
%%

"printf"                            { return PRINTF; }
"scanf"                             { return SCANF; }
"int"                               { return INT; }
"bool"                              { return BOOL; }
"float"                             { return FLOAT; }
"char"                              { return CHAR; }
"void"                              { return VOID; }
"return"                            { return RETURN; }
"for"	                            { return FOR; }
"if"	                            { return IF; }
"else"	                            { return ELSE; }
^"#include"[ ]*<.+\.h>              { return INCLUDE; }
"true"                              { return TRUE; }
"false"                             { return FALSE; }
(_|{letter})({letter}|{digit}|_)*   { return ID; }
[-]?{digit}+                        { return NUMBER; }
{unary}                             { return UNARY; }
"<="                                { return LE; }
">="                                { return GE; }
"=="                                { return EQ; }
"!="                                { return NE; }
">"	                    	        { return GT; }
"<"	                    	        { return LT; }
"&&"	                            { return AND; }
"||"	                            { return OR; }
"+"                                 { return ADD; }
"-"                                 { return SUBTRACT; }
"/"                                 { return DIVIDE; }
"*"                                 { return MULTIPLY; }
[-]?{digit}+\.{digit}{1,9}          { return FLOAT_NUM; }
\/\/.*                              { ; }
\/\*(.*\n)*.*\*\/                   { ; } 
[ \t]*                              { yycolno += 4; }
[\n]                                { linecount++; yycolno = 1; }
["].*["]                            { return STR; }
['].[']                             { return CHARACTER; }
.	                    	        { return *yytext; }

%%

/* .	                    	{ return printf("Unrecognized token: '%s' at line '%d'\n", yytext, linecount); } */

/* Scanner subroutines, only has yywrap for now, returning 1 
whenever the scanner has finished scanning a source file. */
int yywrap()
{
    return 1;
}
