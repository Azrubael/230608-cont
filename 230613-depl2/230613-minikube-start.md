# 2023-08-13  17:51
===================

[1] - https://minikube.sigs.k8s.io/docs/start/

    $ minikube version
minikube version: v1.30.1
commit: 08896fd1dc362c097c925146c4a0d0dac715ace0
    $ minikube start
😄  minikube v1.30.1 on Ubuntu 22.04
    $ minikube kubectl -- get po -A
NAMESPACE              NAME                                        READY   STATUS    RESTARTS       AGE
default                hello-minikube-77b6f68484-xpnml             1/1     Running   2 (74s ago)    70m
kube-system            coredns-787d4945fb-d6jp5                    1/1     Running   2 (64s ago)    71m
kube-system            etcd-minikube                               1/1     Running   1 (106s ago)   72m
kube-system            kube-apiserver-minikube                     1/1     Running   1 (106s ago)   72m
kube-system            kube-controller-manager-minikube            1/1     Running   1 (46m ago)    72m
kube-system            kube-proxy-kzxmm                            1/1     Running   1 (106s ago)   71m
kube-system            kube-scheduler-minikube                     1/1     Running   1 (106s ago)   72m
kube-system            storage-provisioner                         1/1     Running   3 (47s ago)    72m
kubernetes-dashboard   dashboard-metrics-scraper-5c6664855-qczh2   1/1     Running   2 (74s ago)    71m
kubernetes-dashboard   kubernetes-dashboard-55c4cbbc7c-mpfsk       1/1     Running   2 (74s ago)    71m
    $ alias k3s="minikube kubectl --"
    $ k3s create deployment hello-minikube --image=kicbase/echo-server:1.0
    $ k3s get deploy
NAME             READY   UP-TO-DATE   AVAILABLE   AGE
hello-minikube   1/1     1            1           75m
    $ k3s get nodes
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   78m   v1.26.3
    $ k3s get pods
NAME                              READY   STATUS    RESTARTS        AGE
hello-minikube-77b6f68484-xpnml   1/1     Running   2 (7m23s ago)   76m
    $ k3s expose deployment hello-minikube --type=NodePort --port=8080
Error from server (AlreadyExists): services "hello-minikube" already exists
    $ k3s get services hello-minikube
NAME             TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
hello-minikube   NodePort   10.109.113.116   <none>        8080:30763/TCP   77m

# The easiest way to access this service is to let minikube launch a web browser for you:
    $ minikube service hello-minikube
|-----------|----------------|-------------|---------------------------|
| NAMESPACE |      NAME      | TARGET PORT |            URL            |
|-----------|----------------|-------------|---------------------------|
| default   | hello-minikube |        8080 | http://192.168.49.2:30763 |
|-----------|----------------|-------------|---------------------------|
🎉  Opening service default/hello-minikube in default browser...

# Request served by hello-minikube-77b6f68484-xpnml
# HTTP/1.1 GET /
# Host: 192.168.49.2:30763
...
# User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/114.0

    $ minikube pause
⏸️  Pausing node minikube ... 
⏯️  Paused 18 containers in: kube-system, kubernetes-dashboard, storage-gluster, istio-operator
    $ minikube unpause
⏸️  Unpausing node minikube ... 
⏸️  Unpaused 18 containers in: kube-system, kubernetes-dashboard, storage-gluster, istio-operator
    $ minikube stop 
    $ minikube status
minikube
type: Control Plane
host: Stopped
kubelet: Stopped
apiserver: Stopped
kubeconfig: Stopped
    $ minikube start
$ minikube status
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
    $ k3s get nodes
NAME       STATUS   ROLES           AGE    VERSION
minikube   Ready    control-plane   101m   v1.26.3
    $ k3s get deploy
NAME             READY   UP-TO-DATE   AVAILABLE   AGE
hello-minikube   1/1     1            1           100m
    $ k3s delete deploy hello-minikube
deployment.apps "hello-minikube" deleted
    $ k3s get deploy
No resources found in default namespace.
    $ k3s get nodes
NAME       STATUS   ROLES           AGE    VERSION
minikube   Ready    control-plane   103m   v1.26.3
    $ k3s get pods
No resources found in default namespace.


    $ minikube delete --all
🔥  Deleting "minikube" in docker ...
🔥  Removing /home/uh/.minikube/machines/minikube ...
💀  Removed all traces of the "minikube" cluster.
🔥  Successfully deleted all profiles
