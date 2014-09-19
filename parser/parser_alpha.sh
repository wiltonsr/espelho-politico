#!/bin/bash
url_deputados=http://www.camara.gov.br/SitCamaraWS/Deputados.asmx/ObterDeputados
content=$(wget $url_deputados -q -O -)
deputados=($(echo $content | grep -oP '(?<=nome>)[^<]+'))

for i in ${!deputados[*]}
do
    echo "$i" "${deputados[$i]}"
done
