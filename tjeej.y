/* TurboJeeJio C Parser */

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "lex.yy.c"

    int errorcount = 0, yylineno, yycolno, symbolnum = 0, symbolposfound;
    char symboltype[24];
    char symbolspec[16];

    /*
     * Struct representing the symbol table, 256 is the initial size and can
     * be increased later if required.
     */
    struct dataType
    {
        unsigned int line_num;
        char *id, *dataspec, *datatype, *type_to_symtab;
    } symbol_table[256];

    /* Function prototypes */
    void yyerror(const char *str);
    int yylex();
    int yywrap();
    void add_symbol(char);
    void insert_spec_on_table();
    void insert_type_on_table();
    int search_table(char*);
%}

/* Tokens currently supported by the scanner */
%token VOID CHARACTER PRINTF SCANF INT16 UINT16 INT32 UINT32 INT64 UINT64
FLOAT32 FLOAT64 FLOAT128 BOOL CHAR8 UCHAR8 FOR IF ELSE TRUE FALSE NUMBER
FLOAT_NUM ID LE GE EQ NE GT LT AND OR STR ADD MULTIPLY DIVIDE SUBTRACT UNARY
INCLUDE RETURN LPAR RPAR LBRACK RBRACK LBRACE RBRACE ATTRIB STMTEND COMMA
BREAK CASE CONST CONTINUE DEFAULT DO ENUM EXTERN GOTO STATIC WHILE SIZEOF
UNION REGISTER SWITCH TYPEDEF VOLATILE NOTOKEN


/* Grammar definitions for the language */
%%

    /* 
     * Defines the overall C program structure, usually composed of
     * headers, the main function and its body, then the return statement.
     */
    prog: headers main LPAR RPAR LBRACK body return RBRACK
    ;

    /*
     * Defines the way by which includes are parsed. having two 'headers'
     * concatenated allows us to parse multiple header lines.
     */
    headers: headers headers
    | INCLUDE { add_symbol('H'); }
    ;

    /* The currently supported datatypes are int, bool, float, char and void */
    datatype: BOOL { insert_type_on_table(); }
    | INT16        { insert_type_on_table(); }
    | UINT16       { insert_type_on_table(); }
    | INT32        { insert_type_on_table(); }
    | UINT32       { insert_type_on_table(); }
    | UINT64       { insert_type_on_table(); }
    | INT64        { insert_type_on_table(); }
    | FLOAT32      { insert_type_on_table(); }
    | FLOAT64      { insert_type_on_table(); }
    | FLOAT128     { insert_type_on_table(); }
    | CHAR8        { insert_type_on_table(); }
    | UCHAR8       { insert_type_on_table(); }
    | VOID         { insert_type_on_table(); }
    ;

    dataspec: CONST { insert_spec_on_table(0); }
    | EXTERN        { insert_spec_on_table(0); }
    | STATIC        { insert_spec_on_table(0); }
    | REGISTER      { insert_spec_on_table(0); }
    | VOLATILE      { insert_spec_on_table(0); }
    | { insert_spec_on_table(1); }
    ;

    /* For now, main doesn't support receiving any arguments */
    main: datatype ID { add_symbol('F'); }
    ;

    /*
     * For the body, we have a set of rules of tokens, statements, loops
     * and conditionals that allows us to create a slew of different programs.
     */
    body: FOR { add_symbol('K'); } LPAR stmt STMTEND cond STMTEND stmt RPAR LBRACK body RBRACK
    | IF { add_symbol('K'); } LPAR cond RPAR LBRACK body RBRACK else
    | stmt STMTEND 
    | body body
    | PRINTF { add_symbol('K'); } LPAR STR RPAR STMTEND
    | SCANF  { add_symbol('K'); } LPAR STR COMMA '&' ID RPAR STMTEND
    ;

    /*
     * A statement can be a datatype initialization, an attribution to an 
     * identifier, a relational operation between identifier and expression, etc.
     */
    stmt: dataspec datatype var_decl;
    | ID ATTRIB expr 
    | ID relop expr
    | ID UNARY 
    | UNARY ID
    ;

    /* A var declaration here is treated as an ID followed by an initialization. */
    var_decl: ID { add_symbol('V'); } init 
    | var_decl COMMA var_decl
    ;

    /* 
     * A condition expresses the result of a relational operator between
     * two values, and can return either true or false.
     */
    cond: value relop value 
    | cond logop cond
    | TRUE  { add_symbol('K'); }
    | FALSE { add_symbol('K'); }
    ;

    /*
     * This production is a continuation of the IF ... else rule in the "body:"
     * definition above, and allows for the use of if-else as well as a single if.
     */
    else: ELSE { add_symbol('K'); } LBRACK body RBRACK
    |
    ;

    /* Values can be a number, a float, a character and an identifier */
    value: NUMBER { add_symbol('C'); }
    | FLOAT_NUM   { add_symbol('C'); }
    | CHARACTER   { add_symbol('C'); }
    | cond
    | ID
    ;

    /*
     * As for the relational operators, we have the usual ones:
     * LT - Lower than
     * GT - Greater than
     * LE - Lower or equal to
     * GE - Greater or equal to
     * EQ - Equal to
     * NE - Not equal to 
     */
    relop: LT
    | GT
    | LE
    | GE
    | EQ
    | NE
    ;

    logop: AND
    | OR
    ;

    /*
     * In C, we don't actually need to initialize a variable when
     * declaring it, so the init definition can be produced into null.
     */
    init: ATTRIB value 
    |
    ;

    /* 
     * Expressions can have arithmetic inside them, but they can also not
     * have any arithmetic at all.
     */
    expr: expr arith expr
    | value
    ;

    /*
     * Arithmetic is initially comprised of addition, subtraction,
     * multiplication and division.
     */
    arith: ADD
    | SUBTRACT
    | MULTIPLY
    | DIVIDE
    ;

    /*
     * Return is yet another definition that can be produced into null
     * since we don't need to explicitly issue a return command in C's 
     * functions all the time.
     */
    return: RETURN { add_symbol('K'); } value STMTEND 
    |
    ;

%%

int main()
{
    unsigned int i=0;

    yyparse();

    char *sname = "SYMBOL NAME", *sspec = "SYMBOL SPECIFIER", *stype = "SYMBOL TYPE", *sttbl = "TYPE ON TABLE", *lnum = "LINE NUM";
    char *separator = "----------------------------------------------------------------------------------------------------------------------------------------------------------------";
    printf("\n\nPARSER-GENERATED SYMBOL TABLE:");
    printf("\n| %-35s | %-16s | %-24s | %-13s | %-8s |", sname, sspec, stype, sttbl, lnum);
    printf("\n|%.110s|", separator);

    for(i=0; i<symbolnum; i++) { printf("\n| %-35s | %-16s | %-24s | %-13s | %-8d |", symbol_table[i].id, symbol_table[i].dataspec, symbol_table[i].datatype, symbol_table[i].type_to_symtab, symbol_table[i].line_num); }
    printf("\n|%.110s|", separator);

    for(i=0;i<symbolnum;i++)
    {
        free(symbol_table[i].id);
        free(symbol_table[i].type_to_symtab);
    }
    printf("\n\n");

    if(errorcount == 0) { printf("\nProgram parsed successfully with no syntax errors!\n"); }
    else { printf("\nError parsing the program...\n"); }
}

void yyerror(const char* msg)
{
    errorcount++;
    printf ("Parse error at line %d, column %d: %s\n", yylineno, yycolno, msg);
}


/* Symbol table functions */
void add_symbol(char symtype)
{
    symbolposfound=search_table(yytext);
    if(!symbolposfound)
    {
        if(symtype == 'H')
        {
            symbol_table[symbolnum].id=strdup(yytext);        
            symbol_table[symbolnum].dataspec=strdup("");   
            symbol_table[symbolnum].datatype=strdup(symboltype);     
            symbol_table[symbolnum].line_num=yylineno;    
            symbol_table[symbolnum].type_to_symtab=strdup("HEADR");
            symbolnum++;  
        }  
        else if(symtype == 'K')
        {
            symbol_table[symbolnum].id=strdup(yytext);
            symbol_table[symbolnum].dataspec=strdup("");   
            symbol_table[symbolnum].datatype=strdup("none");
            symbol_table[symbolnum].line_num=yylineno;
            symbol_table[symbolnum].type_to_symtab=strdup("KEYWD");   
            symbolnum++;  
        }  
        else if(symtype == 'V')
        {
            symbol_table[symbolnum].id=strdup(yytext);
            symbol_table[symbolnum].dataspec=strdup(symbolspec);  
            symbol_table[symbolnum].datatype=strdup(symboltype);
            symbol_table[symbolnum].line_num=yylineno;
            if(strcmp(symbolspec, "const") != 0) { symbol_table[symbolnum].type_to_symtab=strdup("VARBL"); }
            else { symbol_table[symbolnum].type_to_symtab=strdup("CONST"); }
            symbolnum++;  
        }
        else if(symtype == 'C')
        {
            symbol_table[symbolnum].id=strdup(yytext);
            symbol_table[symbolnum].dataspec=strdup(symbolspec);   
            symbol_table[symbolnum].datatype=strdup("const");
            symbol_table[symbolnum].line_num=yylineno;
            symbol_table[symbolnum].type_to_symtab=strdup("CONST");   
            symbolnum++;  
        }  
        else if(symtype == 'F')
        {
            symbol_table[symbolnum].id=strdup(yytext);
            symbol_table[symbolnum].dataspec=strdup(symbolspec);   
            symbol_table[symbolnum].datatype=strdup(symboltype);
            symbol_table[symbolnum].line_num=yylineno;
            symbol_table[symbolnum].type_to_symtab=strdup("FUNCT");   
            symbolnum++;  
        }
    }
}

void insert_spec_on_table(unsigned int empty)
{
    if(!empty) { strcpy(symbolspec, yytext); }
    else { strcpy(symbolspec, "none"); }
}

void insert_type_on_table() { strcpy(symboltype, yytext); }

int search_table(char *type)
{ 
    int i; 
    for(i=symbolnum-1; i>=0; i--) 
    {
        if(strcmp(symbol_table[i].id, type)==0) 
        {   
            return -1;
            break;  
        }
    } 
    return 0;
}
