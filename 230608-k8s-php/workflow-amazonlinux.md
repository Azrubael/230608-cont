2023-06-08
------------------------------------------------------------
# Plan of work:

    1) Create a simple PHP aplication

    2) Create a Dockerfile with Apache+PHP+PHP_app deploy

    3) Create a Docker Image out of our Dockerfile

    4) Create a Repo on Docker Hub

    5) Upload our Docker Image on our Repo on Docker Hub

    6) Test our Docker Image on Docker Hub

------------------------------------------------------------
### [1] run Docker and run `runme1st.sh` file

    $ docker build -t azrubaelk8php .
# Download distributive of amazonlinux
    $ docker pull amazonlinux



### [2] check Docker images

    $ docker images

    REPOSITORY      TAG       IMAGE ID       CREATED          SIZE
    azrubaelk8php   latest    99e79dc6cf02   36 seconds ago   290MB


### Load new image on dockerhub

    [3] Open in a browser   https://hub.docker.com

    [4] Register on a site
    
    [5] Create a new repository
    
    [6] Rename our new image according to Docker Image name

    $ docker tag azrubaelk8php:latest azrubael/230608-k8s-php:latest

    $ docker images
    
    REPOSITORY                TAG       IMAGE ID       CREATED       SIZE
    azrubael/230608-k8s-php   latest    99e79dc6cf02   4 hours ago   290MB
    azrubaelk8php             latest    99e79dc6cf02   4 hours ago   290MB


    
### [7] Push a new image to created repository:

    $ docker push azrubael/230608-k8s-php:latest

    The push refers to repository [docker.io/azrubael/230608-k8s-php]
    2df06dc81735: Pushed 
    bc571f0d99db: Layer already exists 
    297d8dc115e1: Layer already exists 
    c6af046dcd67: Layer already exists 
    3897c9e16dec: Layer already exists 
    latest: digest: sha256:0805d5f634f3a6e02f0efec3d5f16325a9e1c9a413a9e10040cde5981eef769a size: 1372

### [8] Delete created Docker Image locally:   docker rmi <IMAGE ID> -f

    $ docker rmi 99e79dc6cf02 -f
    
    Untagged: azrubael/230608-k8s-php:latest
    Untagged: azrubael/230608-k8s-php@sha256:5913e4c9aece5b01d12455f28f75512051f0444370759fcce5e44d351281e102
    Untagged: azrubaelk8php:latest
    Deleted: sha256:99e79dc6cf0283b66d7a2da073e0fd4c06c1d9d564f4ecf41a7fe4737ea46182

    
### [9] Check local Docker Images

    $ docker images

REPOSITORY   TAG       IMAGE ID   CREATED   SIZE


### [10] Run a new Docker Image remorely from our repo:

    $ docker run -it -p 4444:80 azrubael/230608-k8s-php:latest
    
    
    
    
# очистка кеша
    $ docker builder prune --all
# удаление ненужного образа
    $ docker rmi azamazon:latest -f
Untagged: azamazon:latest
Deleted: sha256:3a43f22a44ed098349f188519d686d470f22fffee785021643f3149b100b4b6d
# удаление ненужного контейнера
    $ docker container rm c95482344a09
c95482344a09

    

# Вход в консоль    
    $ docker container ps
CONTAINER ID   IMAGE             COMMAND                  CREATED          STATUS          PORTS                  NAMES
ae98fb53cccb   azamazon:latest   "/usr/sbin/httpd -D …"   15 minutes ago   Up 11 minutes   0.0.0.0:4444->80/tcp   agitated_tharp
    $ docker exec -it ae98fb53cccb /bin/bash
bash-5.2# 


Открывем брауза и смотрим на http://IP_SERVER:8080
    Если что-то пошло не так - 
docker ps, смотрим id контейнера,
docker exec -it ID /bin/bash
    попадаем  в контейнер, и там уже
tail -30 /var/log/httpd/error_log
