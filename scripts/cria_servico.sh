#!/bin/bash

COMANDO=$0
IMAGEM=spring-docker
SERVICO=spring-app
VERSAO=$1

function ajuda(){
	echo "Usage: $COMANDO versao:" >&1
	exit 4
}

if [ $# -lt 1 ]; then
	ajuda;
else

echo -e "Removendo o serviço ${SERVICO}"

id_servico=$(docker service ls -qf name=${SERVICO})

if [ -n "$id_servico" ]; then
	docker service rm ${SERVICO} 
	echo -e "Serviço ${SERVICO} removido com sucesso!"
else
	echo -e "O serviço ${SERVICO} não existe ou já foi removido!"
fi

docker service create \
--name ${SERVICO} \
--replicas 1  \
--restart-condition on-failure \
--update-parallelism 1 \
--reserve-memory 512m \
--limit-memory 1024m \
--with-registry-auth \
--host mail.cnseg.org.br:10.1.4.72 \
--publish mode=host,target=8080,published=8080,protocol=tcp \
--publish mode=host,target=8081,published=8081,protocol=tcp \
--mount type=bind,source=/Dockerfile/spring-docker/logs,target=/logs \
${IMAGEM}:${VERSAO}

fi 

exit 0
