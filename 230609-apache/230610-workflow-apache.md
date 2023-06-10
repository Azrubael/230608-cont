2023-06-10  09:00
=================

    $ docker builder prune --all

    $ vim Dockerfile
---------------------------
FROM ubuntu:18.04
RUN apt-get -y update && \
    apt-get -y install apache2 && \
    apt-get -y install mc && \
    rm -rf /var/lib/apt/lists/*

CMD apachectl -DFOREGROUND

EXPOSE 80
---------------------------

    $ docker build -t azbuntu18-apache2 .
    $ docker images                           
REPOSITORY       TAG       IMAGE ID       CREATED          SIZE                                     
azbuntuapache2   latest    afd6db3bd7ea   31 seconds ago   174MB
azbionic8        latest    7906b65c86a7   2 hours ago      257MB
ubuntu           18.04     f9a80a55f492   10 days ago      63.2MB
    $ docker run -d --name azbuntu18apache2 -p 4444:80 azbuntuapache2:latest
21c314bf13bc0c4bdba8e718413fc6ea2f01bf42ad6b5ec36b1db4c1dafc3003
    $ docker container ls -as
CONTAINER ID   IMAGE                   COMMAND                  CREATED              STATUS                   PORTS                  NAMES              SIZE
21c314bf13bc   azbuntuapache2:latest   "/bin/sh -c 'apachec…"   About a minute ago   Up About a minute        0.0.0.0:4444->80/tcp   azbuntu18apache2   464B (virtual 174MB)
5f31a9ae1ab8   azbionic8:latest        "/bin/bash"              2 hours ago          Exited (0) 2 hours ago                          azbionic8          12.7MB (virtual 270MB)
    $ docker exec -it 21c314bf13bc /bin/bash
root@21c314bf13bc:/# 

    http://localhost:4444/
/* Все работает ок: и апач и коммандер */  

    $ docker container stop 21c314bf13bc
21c314bf13bc
    $ docker container ls -as
CONTAINER ID   IMAGE                   COMMAND                  CREATED          STATUS                        PORTS     NAMES              SIZE
21c314bf13bc   azbuntuapache2:latest   "/bin/sh -c 'apachec…"   19 minutes ago   Exited (137) 22 seconds ago             azbuntu18apache2   16.8kB (virtual 174MB)
5f31a9ae1ab8   azbionic8:latest        "/bin/bash"              2 hours ago      Exited (0) 2 hours ago                  azbionic8          12.7MB (virtual 270MB)

# Удаление ненужного образа, контейнера и очистка кеша
    $ docker container rm 21c314bf13bc -f
    $ docker rmi azbuntuapache2:latest -f
    $ docker builder prune --all
        
    $ vim Dockerfile
---------------------------
FROM ubuntu:18.04
RUN apt-get -y update && \
    apt-get -y install apache2 && \
    apt-get -y install mc && \
    rm -rf /var/lib/apt/lists/*
RUN mv /var/www/html/index.html /var/www/html/index_apache2.html


COPY ./index.html /var/www/html/index.html

CMD apachectl -DFOREGROUND

EXPOSE 80
---------------------------


# Сохранение образа на ДокерХаб
    $ docker tag azbuntu18-apache2:latest azrubael/first-steps:latest
    $ docker images
REPOSITORY             TAG       IMAGE ID       CREATED          SIZE
azrubael/first-steps   latest    391ef1427bc0   16 minutes ago   174MB
azbuntu18-apache2      latest    391ef1427bc0   16 minutes ago   174MB
ubuntu                 18.04     f9a80a55f492   10 days ago      63.2MB
    $ docker push azrubael/first-steps:latest
The push refers to repository [docker.io/azrubael/first-steps]
90d3d72105c7: Pushed 
441e7fe425be: Pushed 
01c76ad8aaf6: Pushed 
548a79621a42: Mounted from library/ubuntu 
latest: digest: sha256:7567903e5713c3c4a9ab37f47cfa70ac18abe5b1fc3e23960a2f7074042e525c size: 1156

