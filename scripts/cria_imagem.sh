#!/bin/bash 
COMANDO=$0
IMAGEM=spring-docker
SERVICO=spring-app
VERSAO=$1

function ajuda(){
        echo "Usage: $COMANDO {versao do produto} " >&1
        exit 4
}

if [ $# -lt 1 ]; then
        ajuda;
else
       
    docker image build --no-cache -t $IMAGEM:$VERSAO ..
       
fi
exit 0

