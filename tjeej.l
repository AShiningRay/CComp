/* TurboJeeJio C Scanner */
%{
    #include "tjeej.tab.h"
    extern int yycolno; /* Stores the column number for debugging */

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
    char *separator = "-----------------------------------------------------------------------------";
    
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

"printf"                                                                           { return printToken(PRINTF); }
"scanf"                                                                            { return printToken(SCANF); }
"char"|"signed char"                                                               { return printToken(CHAR8); }
"unsigned char"                                                                    { return printToken(UCHAR8); }
"int"|"signed int"|"signed"|"short"|"short int"|"signed short"|"signed short int"  { return printToken(INT16); }
"unsigned"|"unsigned int"|"unsigned short"|"unsigned short int"                    { return printToken(UINT16); }
"long int"|"signed long int"|"long"|"signed long"                                  { return printToken(INT32); }
"unsigned long"|"unsigned long int"                                                { return printToken(UINT32); }
"long long"|"signed long long"|"long long int"|"signed long long int"              { return printToken(INT64); }
"unsigned long long"|"unsigned long long int"                                      { return printToken(UINT64); }
"FILE"                                                                             { return printToken(FILEP); }
"float"                                                                            { return printToken(FLOAT32); }
"double"                                                                           { return printToken(FLOAT64); }
"long double"                                                                      { return printToken(FLOAT128); }
"bool"                                                                             { return printToken(BOOL); }
"void"                                                                             { return printToken(VOID); }
"return"                                                                           { return printToken(RETURN); }
"for"                                                                              { return printToken(FOR); }
"if"                                                                               { return printToken(IF); }
"else"                                                                             { return printToken(ELSE); }
"break"                                                                            { return printToken(BREAK); }
"case"                                                                             { return printToken(CASE); }
"const"                                                                            { return printToken(CONST); }
"continue"                                                                         { return printToken(CONTINUE); }
"default"                                                                          { return printToken(DEFAULT); }
"do"                                                                               { return printToken(DO); }
"enum"                                                                             { return printToken(ENUM); }
"extern"                                                                           { return printToken(EXTERN); }
"goto"                                                                             { return printToken(GOTO); }
"static"                                                                           { return printToken(STATIC); }
"while"                                                                            { return printToken(WHILE); }
"sizeof"                                                                           { return printToken(SIZEOF); }
"union"                                                                            { return printToken(UNION); }
"register"                                                                         { return printToken(REGISTER); }
"switch"                                                                           { return printToken(SWITCH); }
"typedef"                                                                          { return printToken(TYPEDEF); }
"struct"                                                                           { return printToken(STRUCT); }
"volatile"                                                                         { return printToken(VOLATILE); }
^"#include"[ ]*<.+\.h>                                                             { return printToken(INCLUDE); }
"#define"                                                                          { return printToken(DEFINE); }
"true"                                                                             { return printToken(TRUE); }
"false"                                                                            { return printToken(FALSE); }
"main"                                                                             { return printToken(MAIN); }
(_|{letter})({letter}|{digit}|_)*                                                  { return printToken(ID); }
[-]?{digit}+                                                                       { return printToken(NUMBER); }
{unary}                                                                            { return printToken(UNARY); }
"<="                                                                               { return printToken(LE); }
">="                                                                               { return printToken(GE); }
"=="                                                                               { return printToken(EQ); }
"!="                                                                               { return printToken(NE); }
">"                                                                                { return printToken(GT); }
"<"                                                                                { return printToken(LT); }
"&&"                                                                               { return printToken(AND); }
"||"                                                                               { return printToken(OR); }
"&"                                                                                { return printToken(BITAND); }
"|"                                                                                { return printToken(BITOR); }
"+"                                                                                { return printToken(ADD); }
"-"                                                                                { return printToken(SUBTRACT); }
"/"                                                                                { return printToken(DIVIDE); }
"*"                                                                                { return printToken(MULTIPLY); }
[-]?{digit}+\.{digit}{1,9}                                                         { return printToken(FLOAT_NUM); }
\/\/.*                                                                             { ; }
\/\*(.*\n)*.*\*\/                                                                  { ; }
[ \t]                                                                              { yycolno += 4; }
[ \b]                                                                              { yycolno -= 1; }
[ \n]                                                                              { yycolno = 1; }
["].*["]                                                                           { return printToken(STR); }
['].[']                                                                            { return printToken(CHARACTER); }
"("                                                                                { return printToken(LPAR); }
")"                                                                                { return printToken(RPAR); }
"{"                                                                                { return printToken(LBRACK); }
"}"                                                                                { return printToken(RBRACK); }
"["                                                                                { return printToken(LBRACE); }
"]"                                                                                { return printToken(RBRACE); }
"="                                                                                { return printToken(ATTRIB); }
";"                                                                                { return printToken(STMTEND); }
","                                                                                { return printToken(COMMA); }
.                                                                                  { return printf("Unrecognized token at line %d, column %d: '%s'\n", yylineno, yycolno, yytext); }

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
            printf("SCANNER-GENERATED TOKEN TABLE:\n| %-25s | %-12s |\n", tok_name, tok_class);
            printf("|%.42s|\n", separator);
            printf("| %-25s | %-12s |\n", yytext, *((token_name + 0) + (tok-256)) );
            first_token--;
        }
        else 
        { 
            /*
             * Our tokens start at 256 in the lexer table, so basically any token we have 
             * needs to have its index subtracted by this value in order to print the name 
             * accurately, as our token name array starts from 0 as all arrays should. 
             */
            printf("| %-25s | %-12s |\n", yytext, *((token_name + 0) + (tok-256)) );
        }
    }

    /* Sends the matched token to the Parser */
    return tok;
}
