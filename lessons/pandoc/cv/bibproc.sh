#!/bin/bash
for file in $1/*.aux; do
    TEXMFOUTPUT="build:" bibtex $1/`basename $file .aux`
done
