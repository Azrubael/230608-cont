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
# Experiments with Appache2 server without any other frameworks
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


------------------------------------------
    
# List of running containers
    $ docker container ls
CONTAINER ID   IMAGE          COMMAND       CREATED          STATUS         PORTS                  NAMES
e6e02fac5576   ubuntu:18.04   "/bin/bash"   13 minutes ago   Up 6 minutes   0.0.0.0:4444->80/tcp   hardcore_brahmagupta

# Attach Bash to a container
    $ docker container start az-apache

# Stop container
    $ docker container stop f5d0d444009a
az-apache



    $ docker build -t azbionic .
# Clear the cache
    $ docker builder prune --all
# Remove a useless image
    $ docker rmi azamazon:latest -f
Untagged: azamazon:latest
Deleted: sha256:3a43f22a44ed098349f188519d686d470f22fffee785021643f3149b100b4b6d
# Remove a useless container
    $ docker container rm c95482344a09
c95482344a09



2023-08-09  19:43
=================
    $ docker build -t azbionic8 .
    $ docker run -it --name azbionic8 -p 4444:8000 azbionic8:latest 