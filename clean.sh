#! /bin/bash

rm -rf dist
find . -name INDEX -or -name tmp.raw -or -name \*.zip -exec rm {} \;
