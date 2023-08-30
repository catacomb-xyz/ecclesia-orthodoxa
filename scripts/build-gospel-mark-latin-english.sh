#!/bin/bash

set -x

SCRIPT_DIR=$(dirname "$0")

LA_DIR=$SCRIPT_DIR/../biblia-vulgata/novum-testamentum/02-marcus/
EN_DIR=$SCRIPT_DIR/../biblia-vulgata/novum-testamentum/02-marcus/english
TMP_DIR=$SCRIPT_DIR/.tmp

rm -rfv $TMP_DIR
mkdir -v $TMP_DIR

# verse numbers
for F in $LA_DIR/*.txt
do
  NAME=$(basename --suffix=".txt" "$F").tex
  echo $TMP_DIR/$NAME
  nl -w1 -s'}\hspace{1ex}' $F > $TMP_DIR/$NAME
  sed -i 's/^/\\noindent\\textsuperscript{/' $TMP_DIR/$NAME
done

# chapter title
for F in $TMP_DIR/*.tex
do
  NAME=$(basename --suffix=".tex" "$F")
  NUM=$((10#$NAME))
  STR="\\\section{Marcus $NUM}"
  sed -i "1s/^/$STR\n/" $F
done

# line breaks
for F in $TMP_DIR/*.tex
do
  sed -i -e 's/$/\n/' $F
done

echo """
\documentclass{article}

\title{Evangelum} % Sets article title
\author{St. Marcus} % Sets authors name
\date{\today} % Sets date for date compiled

\usepackage{indentfirst}

\usepackage{titlesec}

\titleformat{\chapter}
  {\normalfont\LARGE\bfseries\centering}{\thechapter}{1em}{}
\titlespacing*{\chapter}{0pt}{-40pt}{30pt}

\titleformat{\section}
  {\bfseries\centering}{\thesection}{1em}{}

\setcounter{secnumdepth}{0}

\usepackage[
  papersize={8.75in,11.25in},
  layout=letterpaper,
  layouthoffset=0.125in,
  layoutvoffset=0.125in,
  right=0.75in,
  left=0.75in,
  top=1.0in,
  bottom=1.0in
]{geometry}

\begin{document} % All begin commands must be paired with an end command somewhere
  \maketitle % creates title using information in preamble (title, author, date)
  \newpage
""" >> $TMP_DIR/00.tex

echo """
\end{document}
""" >> $TMP_DIR/99.tex

cat $TMP_DIR/*.tex > $TMP_DIR/evangelum_marcum.tex

xelatex -halt-on-error -output-directory $TMP_DIR $TMP_DIR/evangelum_marcum.tex

cp $TMP_DIR/*.pdf $SCRIPT_DIR
