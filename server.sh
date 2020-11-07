#!/bin/bash
SERVIDORZINHO_BASE_URL="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)/"
SERVIDORZINHO_WWW_URL="${SERVIDORZINHO_BASE_URL}www"
SERVIDORZINHO_TEMPLATES_URL="${SERVIDORZINHO_BASE_URL}templates"
DEFAULT_INDEX="index.sh"
# template file function
function Servidorzinho.serve_template {
  eval "
cat << EOF 
$(<${SERVIDORZINHO_WWW_URL}${1})
EOF"
  #catcontent=$(<${SERVIDORZINHO_WWW_URL}/templates/a.html)
  #eval "echo -e \"$catcontent\"";
}
# server info signature
function Servidorzinho.get_server_info {
  echo "$res_http_vs Servidorzinho  $req_method"
}
#leio a chamada http
# @params {HTTP REQUEST}
function Servidorzinho.read_request {
  read request
  read -r req_method req_uri res_http_vs <<<"$request"
  while true; do
    read header
    [ "$header" == $'\r' ] && break || myheader+=("$header");
  done
  Servidorzinho.serve_file 
  unset request req_method req_uri res_http_vs header 
}
# trato o query string serializada pra enviar como array
# @params @query_string_serialized
function Servidorzinho.get_query_string {
  local query_string=""
  local query_string_serialized=${1#*\?}
  IFS='&'
  set -- $query_string_serialized
  IFS="&" read -a fields <<< "$query_string_serialized"
  for (( i=0 ; i < ${#fields[@]} ; i++ )) ; do
    query_string="$query_string [${fields[i]%=*}]=\"${fields[i]#*=}\""
  done
  echo "${query_string}"
  unset query_string query_string_serialized fields 
}
# trato o mime type pela extensao do arquivo
# @params @file @extension
function Servidorzinho.get_mime_type {
  declare -A custom_mime_types
  local custom_mime_types=([css]="text/css" [js]="application/x-javascript" [sh]="text/html" [api]="application/json" );
  local mime_type=${custom_mime_types[${2}]};
  [ -z "${mime_type}" ] && mime_type=`file -bi $1`;
  echo "${mime_type}";
  unset mime_type custom_mime_types
}
# obtenho a extensao
# @params @file
function Servidorzinho.get_extension {
  echo "${1##*.}" | tr -d '[:space:]'
}
# trato a url separando do query sring e caso esteja no diretorio raiz
# @params @url
function Servidorzinho.get_url {
  local url_without_querystring="${1%%\?*}"
  [ "/" = "${url_without_querystring}" ] && echo "/${DEFAULT_INDEX}" || echo "${url_without_querystring}";
  unset url_without_querystring
}
# crio um output  para ser enviado para a requisicao http <>
# @params @file @mimetype @extension @query_string
function Servidorzinho.output {
  declare -A query && eval "query=(${4})";
  echo -e "HTTP/1.1 ${5}\r"
  echo -e "Content-Type: $2\r"
  for i in "${myheader[@]}"; do
    echo -e "Servidorzinho-$i: $i\r"
  done
  echo -e "Date: $(date '+%a, %d %b %Y %H:%M:%S %Z')\r"
  echo -e "Server: Vinicius-Servidor :P\r"
  echo -e "\r"
  [ "${3}" = "sh" ] || [ "${3}" = "api" ] || [ "${3}" = "json" ] && ( source $1 || echo 'Erro durante a execucao!') || cat "$1"
  echo -e "\r"
  unset query
}
# trato a chamada para filtrar o resultado a um determinado output
# @params none
function Servidorzinho.serve_file {
  local url=$(Servidorzinho.get_url "$req_uri")
  local www_file="${SERVIDORZINHO_WWW_URL}${url}"
  local querystring=$(Servidorzinho.get_query_string "$req_uri");
  local extension=$(Servidorzinho.get_extension "$www_file");
  local mimetype=$(Servidorzinho.get_mime_type "$www_file" "$extension");
  if [ -f "$www_file" ]; then
    Servidorzinho.output "$www_file" "$mimetype" "$extension" "${querystring}" "200 OK";
  elif [ -d "$www_file" ]; then
    Servidorzinho.output "$SERVIDORZINHO_TEMPLATES_URL/directory-listing.sh" "text/html" "sh" "[file]='$www_file' [dir]='$url'" "200 OK";
  else
    Servidorzinho.output "$SERVIDORZINHO_TEMPLATES_URL/404.sh" "text/html" "sh" "[file]='$www_file'" "404 Not Found";
  fi
  unset url www_file query_string extension mimetype 
}
# leio a requisicao
Servidorzinho.read_request

