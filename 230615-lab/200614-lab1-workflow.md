# 2023-06-14  21:12
===================

    $ minikube start
😄  minikube v1.30.1 on Ubuntu 22.04
✨  Automatically selected the docker driver
...
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
    $ docker images
REPOSITORY                    TAG       IMAGE ID       CREATED        SIZE
gcr.io/k8s-minikube/kicbase   v0.0.39   67a4b1138d2d   2 months ago   1.05GB
    $ docker container ls -a
CONTAINER ID   IMAGE                                 COMMAND                  CREATED              STATUS              PORTS                                                                                                                                  NAMES
d27e4ff14ee5   gcr.io/k8s-minikube/kicbase:v0.0.39   "/usr/local/bin/entr…"   About a minute ago   Up About a minute   127.0.0.1:32772->22/tcp, 127.0.0.1:32771->2376/tcp, 127.0.0.1:32770->5000/tcp, 127.0.0.1:32769->8443/tcp, 127.0.0.1:32768->32443/tcp   minikube
    $ minikube kubectl -- apply -f https://k8s.io/examples/pods/simple-pod.yaml
pod/nginx created
-------------------------
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
-------------------------

    $ alias k3s="minikube kubectl --"
    $ k3s get nodes
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   26m   v1.26.3
    $ k3s get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          23m
    $ k3s port-forward nginx 4444:80
    
# http://localhost:4444/
# Welcome to nginx!

    $ k3s delete -f https://k8s.io/examples/pods/simple-pod.yaml
pod "nginx" deleted
    $ k3s get pods
No resources found in default namespace.
    $ k3s get nodes
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   32m   v1.26.3
    $ minikube stop    
    $ $ minikube stop
✋  Stopping node "minikube"  ...
🛑  Powering off "minikube" via SSH ...
🛑  1 node stopped.

    

