#!/bin/bash

RED='\033[0;31m' # Red
NC='\033[0m' # No Color
Yellow='\033[0;33m' # Yellow

search_dir=test_sources
for entry in "$search_dir"/*
do
  echo -e "${RED} TESTING $entry ${NC}"
  echo 
  ./a.out<$entry
  echo
  echo -e "${Yellow}---------------------${NC}"
  echo
done