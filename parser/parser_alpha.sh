#!/bin/bash
url_deputados=http://www.camara.gov.br/SitCamaraWS/Deputados.asmx/ObterDeputados
filename='deputados.txt'
content=$(wget $url_deputados -q -O -)
echo $content | grep -oP '(?<=nome>)[^<]+' > $filename

while read p; do
    echo $p
done <$filename
