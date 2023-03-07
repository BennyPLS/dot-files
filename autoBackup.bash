#!/usr/bin/env bash

dotFilesPath="/Personal/dot-files/"

rm ${dotFilesPath}fish/ -r
cp ~/.config/fish/ ${dotFilesPath} -r --verbose

