#!/bin/bash
declare -A content
content=([title]='Support' [htmltitle]="Suporte" [subtitle]="Suporte" [close]="Fechar" [main]="/templates/suporte.html")
Servidorzinho.serve_template '/templates/shared/base.html'
unset content

