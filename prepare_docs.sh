#!/bin/bash

# list of ignored file extensions ???
# detect html_files dir

touch doc0_1.txt
touch doc0_2.txt

mkdir dir1_word
touch dir1_word/doc1_1.docx
touch dir1_word/doc1_2.docx

mkdir "dir1_word/dir2 word"
touch "dir1_word/dir2 word/doc2 2.docx"

mkdir wiki
touch wiki/index.html

mkdir wiki/index_files
touch wiki/index_files/blank.js
touch wiki/index_files/blank.css


