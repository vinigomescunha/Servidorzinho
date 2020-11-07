#!/bin/bash
declare -A content
content=([title]='Home' [htmltitle]="Inicial" [subtitle]="Status do Sistema" [close]="Fechar" [main]="/templates/index.html")
Servidorzinho.serve_template '/templates/shared/base.html'
unset content

