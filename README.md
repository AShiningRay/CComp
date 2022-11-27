# TurboJeeJio
TurboJeeJio - A simple C Compiler using LEX and YACC


## Building the compiler

To build the compiler, use the following commands:

` yacc -v -d tjeej.y && lex tjeej.l && gcc y.tab.c && ./a.out<test_sources/testnum.c `
