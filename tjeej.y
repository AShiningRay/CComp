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
    void insert_type_on_table(char *type);
    int search_table(char*);
%}

/* Tokens currently supported by the scanner */
%token VOID CHARACTER PRINTF SCANF INT16 UINT16 INT32 UINT32 INT64 UINT64
FLOAT32 FLOAT64 FLOAT128 BOOL CHAR8 UCHAR8 FOR IF ELSE TRUE FALSE NUMBER
FLOAT_NUM ID LE GE EQ NE GT LT AND OR STR ADD MULTIPLY DIVIDE SUBTRACT UNARY
INCLUDE RETURN LPAR RPAR LBRACK RBRACK LBRACE RBRACE ATTRIB STMTEND COMMA
BREAK CASE CONST CONTINUE DEFAULT DO ENUM EXTERN GOTO STATIC WHILE SIZEOF
UNION REGISTER SWITCH TYPEDEF VOLATILE DEFINE STRUCT MAIN NOTOKEN

/* Grammar definitions for the language */
%%

    /* 
     * Defines the overall C program structure, usually composed of
     * headers, the main function and its body, then the return statement.
     */
    prog: pre-main main
    ;


    /* 
     * Pre-main contains those excerpts of code that must be placed before 
     * main(), which is the case of headers, structs, etc. For 
     * simplification, headers are assumed to always be the first directives
     * before defines, structs and others in case they're present. Still,
     * better find a way of simplifying all those rules, as they're bound
     * to have shortcomings in the long term.
     */
    pre-main: headers
    | defines
    | typedefs
    | structs
    | headers structs
    | headers typedefs
    | headers defines
    | headers structs typedefs
    | headers structs defines
    | headers typedefs structs
    | headers typedefs defines
    | headers defines structs
    | headers defines typedefs 
    | headers structs typedefs defines
    | headers structs defines typedefs 
    | headers typedefs structs defines
    | headers defines structs typedefs 
    | headers typedefs defines structs
    | headers defines typedefs structs
    |
    ;


    /*
     * Defines the way by which includes are parsed. having two 'headers'
     * concatenated allows us to parse multiple header lines.
     */
    headers: INCLUDE { add_symbol('H'); } headers_add
    ;

    headers_add: headers
    |
    ;


    /* 
     * "define" directives are supported, although they don't amount to much
     * at a syntax analysis level yet. 
     */
    defines: define-key define-id define-val defines_add
    ;

    define-key: DEFINE { add_symbol('K'); }
    ;

    define-id: ID 
    ;

    define-val: value { add_symbol('C'); }
    ;

    defines_add: defines
    |
    ;


    /* 
     * Typedefs don't work as they should yet. Need to add some way of adding
     * new types and then checking them on later lines. 
     */
    typedefs: typedef-key datatype ID STMTEND typedefs_add
    ;

    typedef-key: TYPEDEF { add_symbol('K'); }
    ;

    typedefs_add: typedefs
    |
    ;


    /* For now, main doesn't support receiving any arguments */
    main: main-name LPAR main-params RPAR LBRACK body return RBRACK
    | main-name LPAR main-params RPAR LBRACK body RBRACK
    | main-name LPAR main-params RPAR LBRACK return RBRACK
    ;

    main-name: datatype MAIN { add_symbol('F'); }
    ;

    main-params: argc COMMA argv LBRACE RBRACE
    | 
    ;

    argc: datatype ID { add_symbol('V'); }
    ;

    argv: datatype MULTIPLY ID { add_symbol('V'); }
    ;

    /* 
     * Prototypes allow for additional functions to be written
     * below "main", making for cleaner and more readable code.
     * *TODO* */


    /*
     * Functions can be any major block of code that has an
     * entry point (i.e. can be called by main for example)
     * and can be used to isolate sections of code.
     * *TODO* */


    /* 
     * Structs are complex datatypes that can house multiple simpler
     * datatypes inside itself, and must contain either a tag before the 
     * brackets, an ID after them, or both.
     *
     * WARNING: For now, only the last parsed struct gets its keyword 
     * line number written into the parser's symbol table. 
     */
    structs: struct-key tag LBRACK struct-body RBRACK STMTEND structs-add
    | struct-key LBRACK struct-body RBRACK struct-initvar STMTEND structs-add
    | struct-key tag LBRACK struct-body RBRACK struct-initvar STMTEND structs-add
    ;

    struct-key: STRUCT { add_symbol('K'); }
    ;

    structs-add: structs
    |
    ;

    struct-body: stmt STMTEND struct-body-add
    ;

    struct-body-add: struct-body
    |
    ;


    /* Struct tag is a stub for now, since the tags can't simply be IDs. */
    tag: ID { add_symbol('T'); }
    ;

    struct-initvar: ID { insert_type_on_table("struct"); add_symbol('V'); } 
    ;


    /* The currently supported datatypes are int, bool, float, char and void */
    datatype: BOOL { insert_type_on_table("null"); }
    | INT16        { insert_type_on_table("null"); }
    | UINT16       { insert_type_on_table("null"); }
    | INT32        { insert_type_on_table("null"); }
    | UINT32       { insert_type_on_table("null"); }
    | UINT64       { insert_type_on_table("null"); }
    | INT64        { insert_type_on_table("null"); }
    | FLOAT32      { insert_type_on_table("null"); }
    | FLOAT64      { insert_type_on_table("null"); }
    | FLOAT128     { insert_type_on_table("null"); }
    | CHAR8        { insert_type_on_table("null"); }
    | UCHAR8       { insert_type_on_table("null"); }
    | VOID         { insert_type_on_table("null"); }
    ;


    /* Datatypes can be specified as STATIC, CONST, etc. */
    dataspec: CONST { insert_spec_on_table(0); }
    | EXTERN        { insert_spec_on_table(0); }
    | STATIC        { insert_spec_on_table(0); }
    | REGISTER      { insert_spec_on_table(0); }
    | VOLATILE      { insert_spec_on_table(0); }
    | { insert_spec_on_table(1); }
    ;


    /*
     * For the body, we have a set of rules of tokens, statements, loops
     * and conditionals that allows us to create a slew of different programs.
     */
    body: for-key LPAR stmt STMTEND cond STMTEND stmt RPAR LBRACK body-add RBRACK body-add
    | IF { add_symbol('K'); } LPAR cond RPAR LBRACK body-add RBRACK else body-add
    | stmt STMTEND body-add
    | printf-key printf-body body-add
    | scanf-key LPAR STR COMMA '&' ID RPAR STMTEND body-add
    ;

    for-key: FOR { add_symbol('K'); }
    ;

    printf-key: PRINTF { add_symbol('K'); }
    ;

    printf-body: LPAR STR RPAR STMTEND
    | LPAR STR printf-params RPAR STMTEND
    ;

    printf-params: COMMA declared-var printf-params-add
    | 
    ;

    printf-params-add: COMMA declared-var printf-params
    |
    ;

    scanf-key: SCANF { add_symbol('K'); }
    ;

    body-add: body
    |
    ;


    /*
     * A statement can be a datatype initialization, an attribution to an 
     * identifier, a relational operation between identifier and expression, etc.
     */
    stmt: dataspec datatype var-decl
    | dataspec struct-var-decl
    | declared-var ATTRIB expr
    | declared-var ATTRIB declared-var
    | declared-var relop expr
    | ID UNARY
    | UNARY ID
    ;

    declared-var: ID
    | ID LBRACE ID RBRACE
    | ID LBRACE NUMBER RBRACE
    ;


    /* A var declaration here is treated as an ID followed by an initialization. */
    var-decl: var-key init var-decl-add
    | var-key LBRACE RBRACE init var-decl-add
    | var-key LBRACE NUMBER RBRACE init var-decl-add
    ;

    var-key: ID { add_symbol('V'); }
    ;

    var-decl-add: COMMA var-decl
    |
    ;


    /* 
     * Structs can't be declared just as a normal var does, they have a different 
     * syntax.
     */
    struct-var-decl: struct-type struct-varname
    ;
    
    struct-type: STRUCT { insert_type_on_table("null"); } 
    ;
    
    struct-varname: tag ID { add_symbol('V'); } struct-varname-add
    ;

    struct-varname-add: COMMA var-decl
    |
    ;


    /* 
     * A condition expresses the result of a relational operator between
     * two values, and can return either true or false.
     */
    cond: cond-term 
    | cond-term logop cond
    ;

    cond-term: value relop value
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


    /* Logical operators are basically AND + OR for now */
    logop: AND
    | OR
    ;


    /*
     * In C, we don't actually need to initialize a variable when
     * declaring it, so the init definition can be produced into null.
     */
    init: ATTRIB expr
    | 
    ;


    /* 
     * Expressions can have arithmetic inside them, but they can also not
     * have any arithmetic at all.
     */
    expr: value arith expr-add
    | LPAR expr-add RPAR arith expr-add
    | LPAR value RPAR expr-add
    | value
    ;

    expr-add: expr
    |
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
    return: return-key value STMTEND 
    |
    ;

    return-key: RETURN { add_symbol('K'); }
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
        else if(symtype == 'T')
        {
            symbol_table[symbolnum].id=strdup(yytext);
            symbol_table[symbolnum].dataspec=strdup(symbolspec);   
            symbol_table[symbolnum].datatype=strdup(symboltype);
            symbol_table[symbolnum].line_num=yylineno;
            symbol_table[symbolnum].type_to_symtab=strdup("SCTAG");   
            symbolnum++;  
        }
    }
}

void insert_spec_on_table(unsigned int empty)
{
    if(!empty) { strcpy(symbolspec, yytext); }
    else { strcpy(symbolspec, "none"); }
}

void insert_type_on_table(char *type) 
{
    if(strcmp(type, "null") == 0){ strcpy(symboltype, yytext); }
    else { strcpy(symboltype, type); }
    
}

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
