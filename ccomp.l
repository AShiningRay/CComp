/* CComp C Scanner */
%{
    #include "ccomp.tab.h"
    int yytokno = 0; /* Stores the current token number on each line for debugging */

    int first_token = 1;
    char *tok_name = "LEXEME", *tok_class = "TOKEN CLASS";
    char *token_name[] =
    {
        "YYerror",                 /* error  */
        "YYUNDEF",                 /* "invalid token"  */
        "VOID",                    /* VOID  */
        "CHARACTER",               /* CHARACTER  */
        "PRINTF",                  /* PRINTF  */
        "SCANF",                   /* SCANF  */
        "INT16",                   /* INT16  */
        "UINT16",                  /* UINT16  */
        "INT32",                   /* INT32  */
        "UINT32",                  /* UINT32  */
        "INT64",                   /* INT64  */
        "UINT64",                  /* UINT64  */
        "FLOAT32",                 /* FLOAT32  */
        "FLOAT64",                 /* FLOAT64  */
        "FLOAT128",                /* FLOAT128  */
        "BOOL",                    /* BOOL  */
        "CHAR8",                   /* CHAR8  */
        "UCHAR8",                  /* UCHAR8  */
        "FILEP",                    /* FILEP  */
        "FOR",                     /* FOR  */
        "IF",                      /* IF  */
        "ELSE",                    /* ELSE  */
        "TRUE",                    /* TRUE  */
        "FALSE",                   /* FALSE  */
        "NUMBER",                  /* NUMBER  */
        "FLOAT_NUM",               /* FLOAT_NUM  */
        "ID",                      /* ID  */
        "LE",                      /* LE  */
        "GE",                      /* GE  */
        "EQ",                      /* EQ  */
        "NE",                      /* NE  */
        "GT",                      /* GT  */
        "LT",                      /* LT  */
        "AND",                     /* AND  */
        "OR",                      /* OR  */
        "STR",                     /* STR  */
        "ADD",                     /* ADD  */
        "MULTIPLY",                /* MULTIPLY  */
        "DIVIDE",                  /* DIVIDE  */
        "SUBTRACT",                /* SUBTRACT  */
        "UNARY",                   /* UNARY  */
        "INCLUDE",                 /* INCLUDE  */
        "RETURN",                  /* RETURN  */
        "LPAR",                    /* LPAR  */
        "RPAR",                    /* RPAR  */
        "LBRACK",                  /* LBRACK  */
        "RBRACK",                  /* RBRACK  */
        "LBRACE",                  /* LBRACE  */
        "RBRACE",                  /* RBRACE  */
        "ATTRIB",                  /* ATTRIB  */
        "STMTEND",                 /* STMTEND  */
        "COMMA",                   /* COMMA  */
        "BREAK",                   /* BREAK  */
        "CASE",                    /* CASE  */
        "CONST",                   /* CONST  */
        "CONTINUE",                /* CONTINUE  */
        "DEFAULT",                 /* DEFAULT  */
        "DO",                      /* DO  */
        "ENUM",                    /* ENUM  */
        "EXTERN",                  /* EXTERN  */
        "GOTO",                    /* GOTO  */
        "STATIC",                  /* STATIC  */
        "WHILE",                   /* WHILE  */
        "SIZEOF",                  /* SIZEOF  */
        "UNION",                   /* UNION  */
        "REGISTER",                /* REGISTER  */
        "SWITCH",                  /* SWITCH  */
        "TYPEDEF",                 /* TYPEDEF  */
        "VOLATILE",                /* VOLATILE  */
        "DEFINE",                  /* DEFINE */
        "STRUCT",                  /* STRUCT */
        "MAIN",                    /* MAIN */
        "BITAND",                  /* BITAND */
        "BITOR",                  /* BITOR */
        "NOTOKEN"                  /* NOTOKEN  */
    };
    char *separator = "----------------------------------------------------------------------------------";
    
    int printToken(int tok);
%}

/* yylineno creates a scanner that keeps track of the line number */
%option yylineno 

letter [a-zA-Z]
digit  [0-9]
unary  "++"|"--"

/*
 * Scanner ruleset, last rule is reserved for unrecognized tokens
 * "auto" { return AUTO; }, although part of the spec, shouldn't be used at all
 */
%%

"printf"                                                                           { yytokno += 1; return printToken(PRINTF); }
"scanf"                                                                            { yytokno += 1; return printToken(SCANF); }
"char"|"signed char"                                                               { yytokno += 1; return printToken(CHAR8); }
"unsigned char"                                                                    { yytokno += 1; return printToken(UCHAR8); }
"int"|"signed int"|"signed"|"short"|"short int"|"signed short"|"signed short int"  { yytokno += 1; return printToken(INT16); }
"unsigned"|"unsigned int"|"unsigned short"|"unsigned short int"                    { yytokno += 1; return printToken(UINT16); }
"long int"|"signed long int"|"long"|"signed long"                                  { yytokno += 1; return printToken(INT32); }
"unsigned long"|"unsigned long int"                                                { yytokno += 1; return printToken(UINT32); }
"long long"|"signed long long"|"long long int"|"signed long long int"              { yytokno += 1; return printToken(INT64); }
"unsigned long long"|"unsigned long long int"                                      { yytokno += 1; return printToken(UINT64); }
"FILE"                                                                             { yytokno += 1; return printToken(FILEP); }
"float"                                                                            { yytokno += 1; return printToken(FLOAT32); }
"double"                                                                           { yytokno += 1; return printToken(FLOAT64); }
"long double"                                                                      { yytokno += 1; return printToken(FLOAT128); }
"bool"                                                                             { yytokno += 1; return printToken(BOOL); }
"void"                                                                             { yytokno += 1; return printToken(VOID); }
"return"                                                                           { yytokno += 1; return printToken(RETURN); }
"for"                                                                              { yytokno += 1; return printToken(FOR); }
"if"                                                                               { yytokno += 1; return printToken(IF); }
"else"                                                                             { yytokno += 1; return printToken(ELSE); }
"break"                                                                            { yytokno += 1; return printToken(BREAK); }
"case"                                                                             { yytokno += 1; return printToken(CASE); }
"const"                                                                            { yytokno += 1; return printToken(CONST); }
"continue"                                                                         { yytokno += 1; return printToken(CONTINUE); }
"default"                                                                          { yytokno += 1; return printToken(DEFAULT); }
"do"                                                                               { yytokno += 1; return printToken(DO); }
"enum"                                                                             { yytokno += 1; return printToken(ENUM); }
"extern"                                                                           { yytokno += 1; return printToken(EXTERN); }
"goto"                                                                             { yytokno += 1; return printToken(GOTO); }
"static"                                                                           { yytokno += 1; return printToken(STATIC); }
"while"                                                                            { yytokno += 1; return printToken(WHILE); }
"sizeof"                                                                           { yytokno += 1; return printToken(SIZEOF); }
"union"                                                                            { yytokno += 1; return printToken(UNION); }
"register"                                                                         { yytokno += 1; return printToken(REGISTER); }
"switch"                                                                           { yytokno += 1; return printToken(SWITCH); }
"typedef"                                                                          { yytokno += 1; return printToken(TYPEDEF); }
"struct"                                                                           { yytokno += 1; return printToken(STRUCT); }
"volatile"                                                                         { yytokno += 1; return printToken(VOLATILE); }
^"#include"[ ]*<.+\.h>                                                             { yytokno += 1; return printToken(INCLUDE); }
"#define"                                                                          { yytokno += 1; return printToken(DEFINE); }
"true"                                                                             { yytokno += 1; return printToken(TRUE); }
"false"                                                                            { yytokno += 1; return printToken(FALSE); }
"main"                                                                             { yytokno += 1; return printToken(MAIN); }
(_|{letter})({letter}|{digit}|_)*                                                  { yytokno += 1; return printToken(ID); }
[-]?{digit}+                                                                       { yytokno += 1; return printToken(NUMBER); }
{unary}                                                                            { yytokno += 1; return printToken(UNARY); }
"<="                                                                               { yytokno += 1; return printToken(LE); }
">="                                                                               { yytokno += 1; return printToken(GE); }
"=="                                                                               { yytokno += 1; return printToken(EQ); }
"!="                                                                               { yytokno += 1; return printToken(NE); }
">"                                                                                { yytokno += 1; return printToken(GT); }
"<"                                                                                { yytokno += 1; return printToken(LT); }
"&&"                                                                               { yytokno += 1; return printToken(AND); }
"||"                                                                               { yytokno += 1; return printToken(OR); }
"&"                                                                                { yytokno += 1; return printToken(BITAND); }
"|"                                                                                { yytokno += 1; return printToken(BITOR); }
"+"                                                                                { yytokno += 1; return printToken(ADD); }
"-"                                                                                { yytokno += 1; return printToken(SUBTRACT); }
"/"                                                                                { yytokno += 1; return printToken(DIVIDE); }
"*"                                                                                { yytokno += 1; return printToken(MULTIPLY); }
[-]?{digit}+\.{digit}{1,9}                                                         { yytokno += 1; return printToken(FLOAT_NUM); }
\/\/.*                                                                             { ; }
\/\*(.*\n)*.*\*\/                                                                  { ; }
[ \t]                                                                              { ; }
[ \b]                                                                              { ; }
[ \n]                                                                              { yytokno  = 0; }
["].*["]                                                                           { yytokno += 1; return printToken(STR); }
['].[']                                                                            { yytokno += 1; return printToken(CHARACTER); }
"("                                                                                { yytokno += 1; return printToken(LPAR); }
")"                                                                                { yytokno += 1; return printToken(RPAR); }
"{"                                                                                { yytokno += 1; return printToken(LBRACK); }
"}"                                                                                { yytokno += 1; return printToken(RBRACK); }
"["                                                                                { yytokno += 1; return printToken(LBRACE); }
"]"                                                                                { yytokno += 1; return printToken(RBRACE); }
"="                                                                                { yytokno += 1; return printToken(ATTRIB); }
";"                                                                                { yytokno += 1; return printToken(STMTEND); }
","                                                                                { yytokno += 1; return printToken(COMMA); }
.                                                                                  { return printf("Unrecognized token at line %d, token %d: '%s'\n", yylineno, yytokno, yytext); }

%%

/* Scanner subroutines, only has yywrap for now, returning 1
 * whenever the scanner has finished scanning a source file.
 */
int yywrap() { return 1; }

int printToken(int tok) {
    if(tok != 0) /* Tok 0 is EOF, we don't need to print this one */
    {
        if(first_token) 
        {
            printf("SCANNER-GENERATED TOKEN TABLE:\n| %-65s | %-12s |\n", tok_name, tok_class);
            printf("|%.102s|\n", separator);
            printf("| %-65s | %-12s |\n", yytext, *((token_name + 0) + (tok-256)) );
            first_token--;
        }
        else 
        { 
            /*
             * Our tokens start at 256 in the lexer table, so basically any token we have 
             * needs to have its index subtracted by this value in order to print the name 
             * accurately, as our token name array starts from 0 as all arrays should. 
             */
            printf("| %-65s | %-12s |\n", yytext, *((token_name + 0) + (tok-256)) );
        }
    }

    /* Sends the matched token to the Parser */
    return tok;
}
