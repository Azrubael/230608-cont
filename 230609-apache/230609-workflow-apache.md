2023-06-08  20:00
=================
    $ docker pull ubuntu:18.04
    $ docker images
REPOSITORY   TAG       IMAGE ID       CREATED      SIZE
ubuntu       18.04     f9a80a55f492   9 days ago   63.2MB
    $ docker run -it -p 4444:80 ubuntu:18.04
root@9ba8ce62a183:/# 

# Inside Ubuntu:18.04 container
    # apt-get update
    # apt-get upgrade
    # apt install vim -y
    # exit
            $ docker attach hardcore_brahmagupta
            
# Start Ubuntu 18.08 from image as a container with name 'azubuntu', in attached mode 
    $ docker run -it --name azubuntu -p 4444:80 ubuntu:18.04
    

2023-06-09  12:00
=================
    $ docker pull httpd
    $ docker images
REPOSITORY    TAG      IMAGE ID       CREATED      SIZE
httpd         latest   417af7dc28bc   2 days ago   138MB
    $ docker run -d --name az-apache -p 4444:80 httpd
afb48af3c41c6dc9c69a41162fa13b4e910700fa95826c0f9b10fc894436ed4e

# Verify the status of all Docker containers using the following command:
    $ docker ps -a
CONTAINER ID   IMAGE          COMMAND              CREATED          STATUS                     PORTS                  NAMES
afb48af3c41c   httpd          "httpd-foreground"   40 seconds ago   Up 39 seconds              0.0.0.0:4444->80/tcp   az-apache
a55c0d96b26e   ubuntu:18.04   "/bin/bash"          10 minutes ago   Exited (0) 6 minutes ago                          flamboyant_mccarthy

# Verify the status of the Apache container using the ID or its name.
    $ docker ps -a -f id=605238b70aad46ac80ef7a9013e5dbf376dbaad487130553c0a0db85c3847532
        or
    $ docker ps -a -f name=az-apache
    $ docker container stop az-apache
    $ docker ps -a -f name=az-apache
CONTAINER ID   IMAGE     COMMAND              CREATED         STATUS                     PORTS     NAMES
afb48af3c41c   httpd     "httpd-foreground"   9 minutes ago   Exited (0) 2 seconds ago 
# Start a container
    $ docker container start az-apache
az-apache
# delete all stopped containers without confirmation
    $ docker container prune -f
# delete an image
    $ docker rmi d1676199e605 -f
Untagged: httpd:latest
Untagged: httpd@sha256:1bb3f7669a85713906e695599d29c58ab40d4e6409907946609d92a428e95b49
Deleted: sha256:d1676199e60591c70e38ddfde2c6c3fc51452fafeeeab485f6713d715dacee3a
Deleted: sha256:0f029a74a17277810a0be7e26c254a4a9add89b53fab4108ea0180635bb9881b
Deleted: sha256:7905f489d9fab07f89e9aed2c4a8e812f55f211116224e15b38cff6160d496e1
Deleted: sha256:832e0eb9bc00791648c2a6c0dc887bb9d7638750f5e9e847c5dd82a437372b54
Deleted: sha256:ebad0c0eb6a40477a547bc116fbf660bb6e54e508521e0b598e87ad38cd7f90b
Deleted: sha256:8cbe4b54fa88d8fc0198ea0cc3a5432aea41573e6a0ee26eca8c79f9fbfa40e3


2023-06-09  12:45
=================
    Create a new container with a Dockerfile.
--------------
[1] $ vim index.html
<h1>Azrubael Test Page</h1>
<p>This is a simple page for the Apache deployment in Docker</p>

--------------
[2] $ vim Dockerfile
FROM httpd:latest
COPY index.html /usr/local/apache2/htdocs
EXPOSE 80

--------------
[3] $ docker build -t azapache .

--------------
[4] $ docker images
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
azapache     latest    94234c47075d   16 seconds ago   145MB
ubuntu       18.04     f9a80a55f492   10 days ago      63.2MB

--------------
[5] $ docker run -it --name azapache -p 4444:80 azapache:latest
# Для запуска в режиме переднего плана и для работы в Баш нужно было дополнить Dockerfile
    $ docker container prune -f
    $ docker images
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
azapache     latest    94234c47075d   16 seconds ago   145MB
ubuntu       18.04     f9a80a55f492   10 days ago      63.2MB
    $ docker rmi 94234c47075d -f

--------------
[6] $ vim Dockerfile
FROM httpd:latest
COPY index.html /usr/local/apache2/htdocs
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]

EXPOSE 80

--------------
[7] $ docker build -t azapache3 .
    $ docker run -it --name azapache -p 4444:80 azapache3:latest

--------------    
[8] $ docker builder prune --all

--------------
[9] $ vim Dockerfile
FROM httpd:latest
COPY index.html /usr/local/apache2/htdocs
# CMD ["httpd","-D","FOREGROUND"]

--------------
[10] $ docker build -t azapache4 .
    $ docker run -it --name azapache -p 4444:80 azapache4:latest

    $ docker run -it -d --name azapache5 -p 4444:80 azapache5:latest
f2c28ab6eeb6d723c185716601041616a628163ba1680a8c5950ae9721adb98d
------------------------------------------
    

# List of running containers
    $ docker container ls
CONTAINER ID   IMAGE          COMMAND       CREATED          STATUS         PORTS                  NAMES
e6e02fac5576   ubuntu:18.04   "/bin/bash"   13 minutes ago   Up 6 minutes   0.0.0.0:4444->80/tcp   hardcore_brahmagupta

Открывем брауза и смотрим на http://IP_SERVER:8080

Если что-то пошло не так - 
docker ps, смотрим id контейнера,

docker exec -it ID /bin/bash
попадаем  в контейнер, и там уже
tail -30 /var/log/httpd/error_log



# Attach Bash to a container
    $ $ docker container start az-apache

# Stop container
    $ docker container stop f5d0d444009a
az-apache



    $ docker build -t azbionic .
# Clear cash
    $ docker builder prune --all
    