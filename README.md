# CComp
CComp - A simple C Compiler using Lex and Bison


## Building the compiler

To build the compiler, just execute `./build_ccomp.sh` and it will build CComp as long as you have bison and lex installed.

If you want to check for possible parser conflicts and ambiguities, run `./build_ccomp_debugconflicts.sh` instead, since that one will print a few examples for conflicts found within the parser.

To test the compiler on the C sources provided by this repository, run `./a.out<test_sources/testfile.c`.

There's also a `test_scripts.sh` file that loads up and automatically tests every single file inside the `test_sources` folder. Running this one is as simple as running `./test_scripts.sh`. 
 
 In case of changing the .sh file for some reason, use `chmod +x test_scripts.sh` to make the file executable again.
