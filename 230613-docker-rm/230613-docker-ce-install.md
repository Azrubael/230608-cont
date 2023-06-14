# 2023-06-13  14:25
===================


[1] - Installing Docker Community Edition
=========================================
    $ sudo apt update
Install a few prerequisite packages which let apt use packages over HTTPS:
    $ sudo apt install apt-transport-https ca-certificates curl software-properties-common
Add the GPG key for the official Docker repository to your system:
    $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
Add the Docker repository to APT sources:
    $ echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
Update your existing list of packages again for the addition to be recognized:
    $ sudo apt update
Make sure you are about to install from the Docker repo instead of the default Ubuntu repo:
    $ apt-cache policy docker-ce
# Notice that docker-ce is not installed, but the candidate for installation is from the Docker repository for Ubuntu 22.04 (jammy).
# Finally, install Docker:
    $ sudo apt install docker-ce
Docker should now be installed, the daemon started, and the process enabled to start on boot. Check that it’s running:
    $ sudo systemctl status docker
    
● docker.service - Docker Application Container Engine
     Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2023-06-13 14:29:47 EEST; 36s ago
TriggeredBy: ● docker.socket
       Docs: https://docs.docker.com
   Main PID: 6222 (dockerd)
      Tasks: 11
     Memory: 34.7M
        CPU: 336ms
     CGroup: /system.slice/docker.service
             └─6222 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

Jun 13 14:29:47 uh-K53SD systemd[1]: Starting Docker Application Container Engine...
Jun 13 14:29:47 uh-K53SD dockerd[6222]: time="2023-06-13T14:29:47.308605908+03:00" level=info msg=">
Jun 13 14:29:47 uh-K53SD dockerd[6222]: time="2023-06-13T14:29:47.309573588+03:00" level=info msg=">
Jun 13 14:29:47 uh-K53SD dockerd[6222]: time="2023-06-13T14:29:47.399645710+03:00" level=info msg=">
Jun 13 14:29:47 uh-K53SD dockerd[6222]: time="2023-06-13T14:29:47.734448686+03:00" level=info msg=">
Jun 13 14:29:47 uh-K53SD dockerd[6222]: time="2023-06-13T14:29:47.815646453+03:00" level=info msg=">
Jun 13 14:29:47 uh-K53SD dockerd[6222]: time="2023-06-13T14:29:47.815829129+03:00" level=info msg=">
Jun 13 14:29:47 uh-K53SD dockerd[6222]: time="2023-06-13T14:29:47.855355325+03:00" level=info msg=">
Jun 13 14:29:47 uh-K53SD systemd[1]: Started Docker Application Container Engine.


[2] - Executing the Docker Command Without Sudo (Optional)
==========================================================
If you want to avoid typing sudo whenever you run the docker command, add your username to the docker group:
    $ sudo usermod -aG docker ${USER}
    $ su - ${USER}
    $ groups
xxxxxxx adm cdrom sudo dip plugdev kvm lpadmin lxd sambashare docker
    $ docker info
Client: Docker Engine - Community
 Version:    24.0.2
 Context:    default
 Debug Mode: false
 

[3] - Testing of my own image on DockerHub
==========================================================
    $ docker login
...

Load an image from DockerHub
    $ docker pull azrubael/first-steps:latest
latest: Pulling from azrubael/first-steps
7c457f213c76: Pull complete 
8c9da577c546: Pull complete 
6837e0e217f3: Pull complete 
f93e2ab2d03f: Pull complete 
Digest: sha256:7567903e5713c3c4a9ab37f47cfa70ac18abe5b1fc3e23960a2f7074042e525c
Status: Downloaded newer image for azrubael/first-steps:latest
docker.io/azrubael/first-steps:latest

    $ docker images
REPOSITORY             TAG       IMAGE ID       CREATED      SIZE
azrubael/first-steps   latest    391ef1427bc0   3 days ago   174MB

Runing a container made from pulled image
    $ docker run -d --name azbuntu18apache2 -p 4444:80 azrubael/first-steps:latest
54d32f7fccc77d5eb0a1f588c9176db194c4eb41c0e62b7862924c59b7ea1db1
    $ docker container ls -as
CONTAINER ID   IMAGE                         COMMAND                  CREATED              STATUS              PORTS                                   NAMES              SIZE
54d32f7fccc7   azrubael/first-steps:latest   "/bin/sh -c 'apachec…"   About a minute ago   Up About a minute   0.0.0.0:4444->80/tcp, :::4444->80/tcp   azbuntu18apache2   464B (virtual 174MB)

# Successfull trying to reach a running apache server
http://localhost:4444/
Azrubael Test Page
This is a simple page for the Apache deployment in Docker

# Trying to login to a running apache server 
    $ docker exec -it 54d32f7fccc7 /bin/bash
root@54d32f7fccc7:/# mc
root@54d32f7fccc7:/# exit
exit
    $ docker container stop 54d32f7fccc7
54d32f7fccc7
    $ docker container ls -as
CONTAINER ID   IMAGE                         COMMAND                  CREATED         STATUS                        PORTS     NAMES              SIZE
54d32f7fccc7   azrubael/first-steps:latest   "/bin/sh -c 'apachec…"   9 minutes ago   Exited (137) 34 seconds ago             azbuntu18apache2   4.42kB (virtual 174MB)

# Remove unwanted container
    $ docker rm 54d32f7fccc7 -f
54d32f7fccc7

To view all containers — active and inactive, run docker ps with the -a switch:
    $ docker ps -a
    $ docker container ls -as

    $ sudo ps -a
    
    ps: lists the processes executing in the current terminal for the current user
    ps ax: lists all processes currently executing for all users  
    ps e: shows the environment for the processes listed  
    kill PID: sends the SIGTERM signal to the process identified by PID
    fg: causes a job that was stopped or in the background to return to the foreground
    bg: causes a job that was stopped to go to the background
    jobs: lists the jobs currently running or stopped
    top: shows the processes currently using the most CPU time 
