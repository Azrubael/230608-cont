2023-08-09  15:45
=================
Debian:10

        root@679bbc713801:/# 
        root@679bbc713801:/# vim
        root@679bbc713801:/# mc

        root@679bbc713801:/# exit
exit
    uh@uh-K53SD:~$ docker images
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
ubuntu       18.04     f9a80a55f492   10 days ago   63.2MB
debian       10        8b5601a5a7f8   2 weeks ago   114MB
    uh@uh-K53SD:~$ docker container ls -a
CONTAINER ID   IMAGE       COMMAND   CREATED         STATUS                     PORTS     NAMES
679bbc713801   debian:10   "bash"    7 minutes ago   Exited (0) 4 minutes ago             reverent_taussig
    uh@uh-K53SD:~$ docker container start 679bbc713801
679bbc713801
    uh@uh-K53SD:~$ docker exec -it 679bbc713801 /bin/bash
        root@679bbc713801:/# vim
        root@679bbc713801:/# mc
        