FROM ubuntu:18.04
RUN apt-get -y update && \
    apt-get -y install apache2 && \
    apt-get -y install mc && \
    rm -rf /var/lib/apt/lists/*
RUN mv /var/www/html/index.html /var/www/html/index_apache2.html

COPY ./index.html /var/www/html/index.html

CMD apachectl -DFOREGROUND

EXPOSE 80