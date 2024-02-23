FROM eclipse-temurin:17-jdk

# Atualiza o linux e instala algumas aplicações
RUN apt-get update
RUN apt-get install -y tzdata locales
RUN apt-get install -y supervisor

# Ajusta o Timezone para Brasil
RUN ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
RUN echo "America/Sao_Paulo" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# Muda para o usuário root para realizar algumas operações. 
USER root

# Cria diretórios
RUN mkdir /logs
RUN mkdir /deploy
RUN mkdir /conf

# Copia o conteúdo dos diretórios locais para os diretórios do container
COPY conf /conf/
COPY deploy /deploy/

#Criando o usuário 'fenacap'
#RUN groupadd -r fenacap && useradd -r -g fenacap fenacap

RUN groupadd -r fenacap -g 1000 \
	&& useradd -u 1000 -r -g fenacap -m -d /opt/fenacap -s /sbin/nologin -c "Fenacap user" fenacap \
	&& chmod 755 /opt/fenacap

# Atribui Atribui a propriedade dos diretórios para o usuário e grupo 'fenacap'
RUN chown -R fenacap:fenacap /deploy
RUN chown -R fenacap:fenacap /logs
RUN chown -R fenacap:fenacap /conf

# Mude para o usuário 'fenacap'
USER fenacap:fenacap

# Diretório de trabalho
WORKDIR /deploy

# Expõe as portas das aplicações
EXPOSE 8081 8082 8083

# Ponto de entrada usando o Supervisord para coordenar a execução de múltiplos processos
CMD ["supervisord", "-c", "/conf/supervisor.conf"]