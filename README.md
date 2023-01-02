# TurboJeeJio
TurboJeeJio - A simple C Compiler using Lex and Bison


## Building the compiler

To build the compiler, just execute `./build_tjeej.sh` and it will build TurboJeejio as long as you have bison and lex installed.

If you want to check for possible parser conflicts and ambiguities, run `./build_tjeej_debugconflicts.sh` instead, since that one will print a few examples for conflicts found within the parser.

To test the compiler on the C sources provided by this repository, run `./a.out<test_sources/testfile.c>`.
