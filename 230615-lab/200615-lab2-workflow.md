# 2023-06-15  11:23
===================

План работы:
1) Создание кластера Миникуб
2) Миникуб Monopode & Dualpode
3) Mиникуб Deployment                   <- деплой не получился и-за опечатки
4) Миникуб Services


[1] - Создание кластера Миникуб
===============================
    $ start minikube
    $ alias k3s="minikube kubectl --"
    $ k3s get nodes
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   14h   v1.26.3


[2] - Миникуб Monopode & Dualpode
=================================
    $ k3s apply  -f 12-monopod.yaml
pod/azapache-minikube created
    $ k3s apply  -f 13-dualpod.yaml
pod/azapp-minikube created
    $ k3s get pods
NAME                READY   STATUS              RESTARTS   AGE
azapache-minikube   1/1     Running             0          113s
azapp-minikube      2/2     ContainerCreating   0          64s
    $ k3s port-forward azapache-minikube 4444:80
Forwarding from 127.0.0.1:4444 -> 80
Forwarding from [::1]:4444 -> 80
# http://localhost:4444/
# Welcome to nginx!


# В другом терминале
--------------------
    $ minikube kubectl -- port-forward azapp-minikube 4445:8080
Forwarding from 127.0.0.1:4445 -> 8080
Forwarding from [::1]:4445 -> 8080
# http://localhost:4445/
# Apache Tomcat/8.5.38

    $ k3s delete -f 13-dualpod.yaml
pod "azapp-minikube" deleted
    $ k3s delete -f 12-monopod.yaml
pod "azapache-minikube" deleted

[3] - Mиникуб Deployment
    $ minikube status
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
    $ k3s get pods
No resources found in default namespace.
    $ k3s get pods --all-namespaces
NAMESPACE     NAME                               READY   STATUS    RESTARTS      AGE
kube-system   coredns-787d4945fb-vgzxf           1/1     Running   1 (21m ago)   15h
kube-system   etcd-minikube                      1/1     Running   1 (21m ago)   15h
kube-system   kube-apiserver-minikube            1/1     Running   1 (21m ago)   15h
kube-system   kube-controller-manager-minikube   1/1     Running   1 (21m ago)   15h
kube-system   kube-proxy-htllk                   1/1     Running   1 (21m ago)   15h
kube-system   kube-scheduler-minikube            1/1     Running   1 (21m ago)   15h
kube-system   storage-provisioner                1/1     Running   2 (20m ago)   15h
    $ k3s get deploy --all-namespaces
NAMESPACE     NAME      READY   UP-TO-DATE   AVAILABLE   AGE
kube-system   coredns   1/1     1            1           15h

-----------------------
    $ k3s create deployment minikube-depl --image adv4000/k8php:latest
deployment.apps/minikube-depl created
    $ k3s get deploy
NAME            READY   UP-TO-DATE   AVAILABLE   AGE
minikube-depl   0/1     1            0           32s
    $ k3s get deploy --all-namespaces
NAMESPACE     NAME            READY   UP-TO-DATE   AVAILABLE   AGE
default       minikube-depl   0/1     1            0           6m47s
kube-system   coredns         1/1     1            1           15h
    $ k3s get pods --all-namespaces
NAMESPACE     NAME                               READY   STATUS             RESTARTS      AGE
default       minikube-depl-5c479cfff8-bqdc7     0/1     ImagePullBackOff   0             7m49s
kube-system   coredns-787d4945fb-vgzxf           1/1     Running            1 (32m ago)   15h
kube-system   etcd-minikube                      1/1     Running            1 (32m ago)   15h
kube-system   kube-apiserver-minikube            1/1     Running            1 (32m ago)   15h
kube-system   kube-controller-manager-minikube   1/1     Running            1 (32m ago)   15h
kube-system   kube-proxy-htllk                   1/1     Running            1 (32m ago)   15h
kube-system   kube-scheduler-minikube            1/1     Running            1 (32m ago)   15h
kube-system   storage-provisioner                1/1     Running            2 (31m ago)   15h
    $ docker login
----------------------

# Проблемы с аутентификацией
    $ k3s delete deployment minikube-depl
deployment.apps "minikube-depl" deleted
    $ k3s get pods --all-namespaces
NAMESPACE     NAME                               READY   STATUS    RESTARTS      AGE
kube-system   coredns-787d4945fb-vgzxf           1/1     Running   1 (43m ago)   15h
kube-system   etcd-minikube                      1/1     Running   1 (43m ago)   15h
kube-system   kube-apiserver-minikube            1/1     Running   1 (43m ago)   15h
kube-system   kube-controller-manager-minikube   1/1     Running   1 (43m ago)   15h
kube-system   kube-proxy-htllk                   1/1     Running   1 (43m ago)   15h
kube-system   kube-scheduler-minikube            1/1     Running   1 (43m ago)   15h
kube-system   storage-provisioner                1/1     Running   2 (42m ago)   15h
    $ k3s get nodes --all-namespacesNAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   15h   v1.26.3


    $ docker image pull azrubael/first-steps:latest
latest: Pulling from azrubael/first-steps
7c457f213c76: Pull complete 
8c9da577c546: Pull complete 
6837e0e217f3: Pull complete 
f93e2ab2d03f: Pull complete 
Digest: sha256:7567903e5713c3c4a9ab37f47cfa70ac18abe5b1fc3e23960a2f7074042e525c
Status: Downloaded newer image for azrubael/first-steps:latest
docker.io/azrubael/first-steps:latest
    $ docker run -d --name first-steps -p 4447:80 azrubael/first-steps
8f5b3e33d952ce25ef3c6e44768f699b2b0e9da26fa3c4baf22505fdcee63f9e
    $ docker container ls -as
CONTAINER ID   IMAGE                                 COMMAND                  CREATED         STATUS          PORTS                                                                                                                                  NAMES         SIZE
8f5b3e33d952   azrubael/first-steps                  "/bin/sh -c 'apachec…"   2 minutes ago   Up 2 minutes    0.0.0.0:4447->80/tcp, :::4447->80/tcp                                                                                                  first-steps   464B (virtual 174MB)
d27e4ff14ee5   gcr.io/k8s-minikube/kicbase:v0.0.39   "/usr/local/bin/entr…"   16 hours ago    Up 56 minutes   127.0.0.1:32772->22/tcp, 127.0.0.1:32771->2376/tcp, 127.0.0.1:32770->5000/tcp, 127.0.0.1:32769->8443/tcp, 127.0.0.1:32768->32443/tcp   minikube      3.07MB (virtual 1.06GB)
    $ docker run -d --name first-steps -p 4447:80 azrubael/first-steps
8f5b3e33d952ce25ef3c6e44768f699b2b0e9da26fa3c4baf22505fdcee63f9e
    $ docker exec -it 8f5b3e33d952 /bin/bash
    $ docker container stop 8f5b3e33d952
8f5b3e33d952
    $ docker container rm 8f5b3e33d952 -f
8f5b3e33d952
    $ docker container prune
    $ docker rmi 391ef1427bc0 -f
Untagged: azrubael/first-steps:latest
Untagged: azrubael/first-steps@sha256:7567903e5713c3c4a9ab37f47cfa70ac18abe5b1fc3e23960a2f7074042e525c
Deleted: sha256:391ef1427bc0556835b426519d1119a599984fa8b0cb663249845d569ace5ae0
Deleted: sha256:0f5e33a72931d03fd1e3327c35b250ca12f1645c0a7fd81618eff4e3119c43e3
Deleted: sha256:fcf21cadcbae1c9bd5e9a33966cec9fdeb4d75bed15ea8518fe9326f4c3e01c2
Deleted: sha256:afe00948d18794ca8af32548930c4637e4e2dc8f2325f2c56fbfd4001e37065c
Deleted: sha256:548a79621a426b4eb077c926eabac5a8620c454fb230640253e1b44dc7dd7562
    $ docker image prune -a
WARNING! This will remove all images without at least one container associated to them.
Are you sure you want to continue? [y/N] y
Total reclaimed space: 0B
    
    
    $ k3s get deploy --all-namespaces
NAMESPACE     NAME      READY   UP-TO-DATE   AVAILABLE   AGE
kube-system   coredns   1/1     1            1           15h
    $ k3s get nodes --all-namespacesNAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   15h   v1.26.3
    $ minikube stop
✋  Stopping node "minikube"  ...
🛑  Powering off "minikube" via SSH ...
🛑  1 node stopped.


