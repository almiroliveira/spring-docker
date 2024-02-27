FROM eclipse-temurin:17-jdk

# Muda para o usuário root para realizar algumas operações. 
USER root

# Cria diretórios
RUN mkdir /logs
RUN mkdir /back
RUN mkdir /conf

# Atualiza o linux
RUN apt-get update

# Instala e ajusta o Timezone para Brasil
RUN apt-get install -y tzdata locales
RUN ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
RUN echo "America/Sao_Paulo" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# Instala e configura o NGINX
RUN apt-get install -y nginx
COPY conf/front.conf /etc/nginx/sites-enabled/default
RUN 

# instala o Supervisord 
RUN apt-get install -y supervisor
COPY conf/supervisor.conf /conf/

# Copia o conteúdo dos diretórios locais para os diretórios do container
COPY back /back/
COPY front /usr/share/nginx/html/

# Cria um usuario e um grupo
#RUN groupadd -r fenacap -g 1000 \
#	&& useradd -u 1000 -r -g fenacap -m -d /opt/fenacap -s /sbin/nologin -c "Fenacap user" fenacap \
#	&& chmod 755 /opt/fenacap

# Atribui Atribui a propriedade dos diretórios para o usuário e grupo 'fenacap'
#RUN chown -R fenacap:fenacap /back
#RUN chown -R fenacap:fenacap /logs
#RUN chown -R fenacap:fenacap /conf

# Mude para o usuário 'fenacap'
#USER fenacap:fenacap

# Expõe as portas das aplicações
EXPOSE 8081 8082 4200

# Ponto de entrada usando o Supervisord para coordenar a execução de múltiplos processos
# CMD ["supervisord", "-c", "/conf/supervisor.conf"]

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]