#!/bin/bash

RED='\033[0;31m' # Red
NC='\033[0m' # No Color
Yellow='\033[0;33m' # Yellow

echo -e "${RED}Testing Malloc, Calloc and Realloc file${NC}" 
echo
sudo ./a.out<test_sources/malloc_test.c
echo
echo -e "${Yellow}---------------------${NC}"
echo
echo -e "${RED}Testing array file${NC}"
echo
sudo ./a.out<test_sources/array_test.c