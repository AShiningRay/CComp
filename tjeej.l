/* TurboJeeJio C Scanner */
%{
    #include "tjeej.tab.h"
    int linecount=0; /* Stores the line number for debugging */
%}

/* yylineno creates a scanner that keeps track of the line number */
%option yylineno 

letter [a-zA-Z]
digit  [0-9]
unary "++"|"--"

/* Scanner ruleset */
%%

"printf"                    { return PRINTF; }
"scanf"                     { return SCANF; }
"int"                       { return INT; }
"float"                     { return FLOAT; }
"char"                      { return CHAR; }
"void"                      { return VOID; }
"return"                    { return RETURN; }
"for"	                    { return FOR; }
"if"	                    { return IF; }
"else"	                    { return ELSE; }
^"#include"[ ]*<.+\.h>      { return INCLUDE; }
"true"                      { return TRUE; }
"false"                     { return FALSE; }
{letter}({letter}|{digit})* { return ID; }
[-]?{digit}+                { return NUMBER; }
"<="                        { return LE; }
">="                        { return GE; }
"=="                        { return EQ; }
"!="                        { return NE; }
">"	                    	{ return GT; }
"<"	                    	{ return LT; }
"&&"	                    { return AND; }
"||"	                    { return OR; }
"+"                         { return ADD; }
"-"                         { return SUBTRACT; }
"/"                         { return DIVIDE; }
"*"                         { return MULTIPLY; }
.	                    	{ return *yytext; }
["].*["]                    { return STR; }
['].[']                     { return CHARACTER; }
[-]?{digit}+\.{digit}{1,9}  { return FLOAT_NUM; }
{unary}                     { return UNARY; }
[\n]                        { linecount++; }


%%

/* Scanner subroutines, only has yywrap for now, returning 1 
whenever the scanner has finished scanning a source file. */
int yywrap() {
    return 1;
}
