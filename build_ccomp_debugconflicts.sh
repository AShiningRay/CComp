#!/bin/bash

# Sets some shortcuts for terminal colors to improve text clarity
COLOR_N="\033[0m"
COLOR_R="\033[0;31m"
COLOR_G="\033[1;32m"
COLOR_B="\033[0;34m"
COLOR_C="\033[0;36m"
COLOR_Y="\033[1;33m"
COLOR_LP="\033[1;35m"

# Only shows up when the script first initializes
echo -e "${COLOR_G}!!Building compiler!!${COLOR_N}" 

BUILD()
{
	# Start building the parser source
	echo -e "\n\n${COLOR_Y}Building parser source...${COLOR_N}"	
	
	if bison -v -d ccomp.y -Wcounterexamples; then
		echo -e "${COLOR_C}\nParser source was built successfully! Moving on...${COLOR_N}"
		BUILT_LAST=$PROGTOBUILD # Saves the source's name, as it's now the last built
	else
		echo -e "${COLOR_R}\nFailed to build the Parser's source code.${COLOR_N}"
		BUILT_LAST=$PROGTOBUILD
		exit 1
	fi	

	echo -e "${COLOR_Y}\n\nBuilding Scanner (LEX) source...${COLOR_N}"	

	if lex ccomp.l; then
		echo -e "${COLOR_C}\nScanner source was built successfully! Moving on..${COLOR_N}"
		BUILT_LAST=$PROGTOBUILD # Saves the source's name, as it's now the last built
	else
		echo -e "${COLOR_R}\nFailed to build the Scanner's source code.${COLOR_N}"
		BUILT_LAST=$PROGTOBUILD
		exit 1
	fi	

	echo -e "${COLOR_Y}\n\nBuilding .tab.c file...${COLOR_N}"	

	if gcc ccomp.tab.c; then
		echo -e "${COLOR_C}\nAll files built successfully!${COLOR_N}"
		BUILT_LAST=$PROGTOBUILD # Saves the source's name, as it's now the last built
	else
		echo -e "${COLOR_R}\nFailed to build .tab.c.${COLOR_N}"
		BUILT_LAST=$PROGTOBUILD
		exit 1
	fi	

}

BUILD
