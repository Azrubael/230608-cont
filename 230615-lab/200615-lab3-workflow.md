# 2023-06-15  13:12
===================

План работы:
1) Создание кластера Миникуб
2) Миникуб Monopode & Dualpode        <- выполнил раньше
3) Mиникуб Deployment                 <- очередая попытка, теперь на minikube
4) Миникуб масштабирование
5) Замена контейнера в деплойменте
6) Разработка и проверка манифестов


[1] - Создание кластера Миникуб
===============================
    $ start minikube
    $ alias k3s="minikube kubectl --"
    $ k3s get nodes
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   14h   v1.26.3


[2] - Миникуб Monopode & Dualpode      <- выполнил раньше
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
=================================
    $ minikube status
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
    $ docker image pull adv4000/k8sphp:latest
    $ docker image pull adv4000/k8sphp:version1
    $ docker image pull adv4000/k8sphp:version2
    $ docker images
REPOSITORY                    TAG        IMAGE ID       CREATED        SIZE
gcr.io/k8s-minikube/kicbase   v0.0.39    67a4b1138d2d   2 months ago   1.05GB
adv4000/k8sphp                version2   aea070b7a225   3 years ago    812MB
adv4000/k8sphp                version1   a5f64fb45326   3 years ago    812MB
adv4000/k8sphp                latest     8eb0934c6441   3 years ago    498MB

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
    $ k3s create deployment minikube-depl --image adv4000/k8sphp:latest
deployment.apps/minikube-depl created
    $ k3s get deploy
NAME            READY   UP-TO-DATE   AVAILABLE   AGE
minikube-depl   0/1     1            0           32s
    $ k3s get deploy --all-namespaces
NAMESPACE     NAME            READY   UP-TO-DATE   AVAILABLE   AGE
default       minikube-depl   0/1     1            0           6m47s
kube-system   coredns         1/1     1            1           15h
    $ k3s get pods --all-namespaces
NAMESPACE     NAME                               READY   STATUS              RESTARTS        AGE
default       minikube-depl-7f88979444-scb85     1/1     Running   0               56s
kube-system   coredns-787d4945fb-vgzxf           1/1     Running   2 (8m9s ago)    16h
kube-system   etcd-minikube                      1/1     Running   2 (8m9s ago)    16h
kube-system   kube-apiserver-minikube            1/1     Running   2 (8m9s ago)    16h
kube-system   kube-controller-manager-minikube   1/1     Running   2 (17m ago)     16h
kube-system   kube-proxy-htllk                   1/1     Running   2 (8m9s ago)    16h
kube-system   kube-scheduler-minikube            1/1     Running   2 (8m9s ago)    16h
kube-system   storage-provisioner                1/1     Running   4 (7m13s ago)   16h
----------------------

    $ k3s get nodes
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   16h   v1.26.3
    $ k3s get pods
NAME                             READY   STATUS    RESTARTS   AGE
minikube-depl-7f88979444-scb85   1/1     Running   0          5m39s
    $ k3s describe pods minikube-depl-7f88979444-scb85
Name:             minikube-depl-7f88979444-scb85
Namespace:        default
...
  Normal  Created    5m33s  kubelet            Created container k8sphp
  Normal  Started    5m33s  kubelet            Started container k8sphp
    $ k3s describe deploy minikube-depl
Name:                   minikube-depl
Namespace:              default
CreationTimestamp:      Thu, 15 Jun 2023 13:24:56 +0300
Labels:                 app=minikube-depl
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=minikube-depl
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
...
NewReplicaSet:   minikube-depl-7f88979444 (1/1 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  8m50s  deployment-controller  Scaled up replica set minikube-depl-7f88979444 to 1


[4] - Миникуб масштабирование деплоя
====================================
    $ k3s scale deployment minikube-depl --replicas 4
deployment.apps/minikube-depl scaled
    $ k3s get pods
NAME                             READY   STATUS    RESTARTS   AGE
minikube-depl-7f88979444-2dx6f   1/1     Running   0          51s
minikube-depl-7f88979444-cj24z   1/1     Running   0          51s
minikube-depl-7f88979444-scb85   1/1     Running   0          21m
minikube-depl-7f88979444-tkt4g   1/1     Running   0          51s
    $ k3s get deploy
NAME            READY   UP-TO-DATE   AVAILABLE   AGE
minikube-depl   4/4     4            4           22m
# Проверка создания набора раплик 'replicas set', которая будет постоянно
# делать менеджмент необходимого количества реплик
    $ k3s get rs
NAME                       DESIRED   CURRENT   READY   AGE
minikube-depl-7f88979444   4         4         4       23m
    $ k3s autoscale deploy minikube-depl --min=2 --max=5 --cpu-percent=80
horizontalpodautoscaler.autoscaling/minikube-depl autoscaled
# выполнено горизонтальное автомасштабирование

    $ k3s get pods --all-namespaces
NAMESPACE     NAME                               READY   STATUS    RESTARTS      AGE
default       minikube-depl-7f88979444-2dx6f     1/1     Running   0             10m
default       minikube-depl-7f88979444-cj24z     1/1     Running   0             10m
default       minikube-depl-7f88979444-scb85     1/1     Running   0             31m
default       minikube-depl-7f88979444-tkt4g     1/1     Running   0             10m
kube-system   coredns-787d4945fb-vgzxf           1/1     Running   2 (38m ago)   16h
kube-system   etcd-minikube                      1/1     Running   2 (38m ago)   16h
kube-system   kube-apiserver-minikube            1/1     Running   2 (38m ago)   16h
kube-system   kube-controller-manager-minikube   1/1     Running   2 (47m ago)   16h
kube-system   kube-proxy-htllk                   1/1     Running   2 (38m ago)   16h
kube-system   kube-scheduler-minikube            1/1     Running   2 (38m ago)   16h
kube-system   storage-provisioner                1/1     Running   4 (37m ago)   16h
# проверим состояние работы горизонтального автомасшабирования 'hpa'
    $ k3s get hpa
NAME            REFERENCE                  TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
minikube-depl   Deployment/minikube-depl   <unknown>/80%   2         5         4          2m54s
    $ k3s rollout history deployment/minikube-depl
deployment.apps/minikube-depl 
REVISION  CHANGE-CAUSE
1         <none>
    $ k3s rollout status deployment/minikube-depl
deployment "minikube-depl" successfully rolled out


[5] - Замена контейнера в деплойменте
=====================================
    $ k3s describe deploy minikube-depl
...
  Containers:
   k8sphp:
    Image:        adv4000/k8sphp:latest
...
    $ minikube kubectl -- set image deployment/minikube-depl k8sphp=adv4000/k8sphp:version1
deployment.apps/minikube-depl image updated
    $ k3s rollout status deployment/minikube-depl
Waiting for deployment "minikube-depl" rollout to finish: 2 out of 4 new replicas have been updated...
...
Waiting for deployment "minikube-depl" rollout to finish: 1 old replicas are pending termination...
Waiting for deployment "minikube-depl" rollout to finish: 3 of 4 updated replicas are available...
deployment "minikube-depl" successfully rolled out
    $ k3s rollout history deployment/minikube-depl
deployment.apps/minikube-depl 
REVISION  CHANGE-CAUSE
1         <none>
2         <none>
    $ k3s set image deployment/minikube-depl k8sphp=adv4000/k8sphp:latest --record
deployment.apps/minikube-depl image updated
Flag --record has been deprecated, --record will be removed in the future
deployment.apps/minikube-depl image updated
    $ k3s rollout history deployment/minikube-depl
deployment.apps/minikube-depl 
REVISION  CHANGE-CAUSE
2         <none>
3         kubectl set image deployment/minikube-depl k8sphp=adv4000/k8sphp:latest --cluster=minikube --record=true
    $ k3s set image deployment/minikube-depl k8sphp=adv4000/k8sphp:version2 --record=true
Flag --record has been deprecated, --record will be removed in the future
deployment.apps/minikube-depl image updated
    $ k3s rollout history deployment/minikube-depl
deployment.apps/minikube-depl 
REVISION  CHANGE-CAUSE
2         <none>
3         kubectl set image deployment/minikube-depl k8sphp=adv4000/k8sphp:latest --cluster=minikube --record=true
4         kubectl set image deployment/minikube-depl k8sphp=adv4000/k8sphp:version2 --cluster=minikube --record=true
    $ minikube kubectl rollout undo deployment/minikube-depl
# ЕСЛИ НАДО ПРОСТО СРОЧНО ОТКАТИТЬ НА ПРЕДЫДУЩИЙ ОБРАЗ
    $ k3s rollout undo deployment/minikube-depl --to-revision=4
# ЕСЛИ ТРЕБУЕТСЯ ОТКАТ ДЕПЛОЯ НА КОНКРЕТНЫЙ РЕВИЖН
    $ k3s describe deploy minikube-depl
...
    $ k3s get pods
NAME                            READY   STATUS    RESTARTS   AGE
minikube-depl-ffcb9f5fc-46znf   1/1     Running   0          6m9s
minikube-depl-ffcb9f5fc-gb2wj   1/1     Running   0          6m8s
minikube-depl-ffcb9f5fc-n9pnh   1/1     Running   0          6m13s
minikube-depl-ffcb9f5fc-vks99   1/1     Running   0          6m13s

# ЕСЛИ НАДО ПРОСТО ПЕРЕЗАПУСТИТЬ ДЕПЛОЙМЕНТ    
    $ k3s rollout restart deployment/minikube-depl
deployment.apps/minikube-depl restarted
    $ k3s rollout status deployment/minikube-depl
deployment "minikube-depl" successfully rolled out


[6] - Разработка и проверка манифестов
см. следующую лабораторную работу
[timecode 15:35]

[7] - Заключительные операции
=============================
    $ k3s delete deployment minikube-depl 
deployment.apps "minikube-depl" deleted
    $ docker container ls -a                <- по необходимости
    $ docker container prune                <- по необходимости
    $ docker images
REPOSITORY                    TAG        IMAGE ID       CREATED        SIZE
gcr.io/k8s-minikube/kicbase   v0.0.39    67a4b1138d2d   2 months ago   1.05GB
adv4000/k8sphp                version2   aea070b7a225   3 years ago    812MB
adv4000/k8sphp                version1   a5f64fb45326   3 years ago    812MB
adv4000/k8sphp                latest     8eb0934c6441   3 years ago    498MB

    $ docker rmi aea070b7a225 a5f64fb45326 8eb0934c6441 -f
Untagged: adv4000/k8sphp:version2
Untagged: adv4000/k8sphp@sha256:6ccfffa1bc1b1642a875bd734c01565629fb98c2b7eb10dae2ffbd5e05472e41
Deleted: sha256:aea070b7a225fb8aec941734a9e79449c948e2243eede56933cbac14cb14f58b
Deleted: sha256:bae3c7ab3d29b660e0102253cafd3ddaf63c29c21df73a1d454ded524322b4c2
Untagged: adv4000/k8sphp:version1
Untagged: adv4000/k8sphp@sha256:4bbd5c51e08bb113308adad32acbdc98a12be38d3a54421d1e9fd6b9a4f4ef5a
Deleted: sha256:a5f64fb45326bb7754f7c5b725970345be475d08dd0329ec1cfd82f281513221
Deleted: sha256:be026256f50fa83e913edc6b7616897bd3a0d5c24560cd23bab729284150c5e0
Deleted: sha256:56c5796b0d4b4f233adb5c8d550f1db29b6ede64b755514b93b78fcbb36a4610
Deleted: sha256:a0c12d4655bff001e9e8a4b96e5e2bdb5ea569b00e1e80b6101d68abeffa5c47
Deleted: sha256:3be971fe57c80674416803d84595665457ccce68c2278d7f20def7bb0ff34e81
Deleted: sha256:9f856a31a19b9076c45195825844d89d7dad641870d1bd10c66579ff6bc1a0b4
Untagged: adv4000/k8sphp:latest
Untagged: adv4000/k8sphp@sha256:326243d50969a4be8b156bc15f539e49adf216958e6b4fb4e655d67b87c30b53
Deleted: sha256:8eb0934c64419736a030607ae703c9dfdf7029d4cdc6f3953d99b224f311fe41
Deleted: sha256:2f84b2dac8f34fbf69974ce670e7a3b8758ef39991cdd566068c4415ecf8f4b4
Deleted: sha256:7f1674f79e4dc966813c73c9cc5131e1c65c7d1aa56bb58947c9a2cb43f48de6
Deleted: sha256:c9d6002ad2dd49203d5bd482441d2a8bb8c5ad778ec182b910d893719b716ef9
Deleted: sha256:751af2cc0c4433211983200b40d04201b82b913c2b81c5aafc4f4c828290bc61
Deleted: sha256:a2925614516b6afe24537338707a1ff1f9b89f61e7df03a618ed78d91da31dab

    $ docker image prune -a
WARNING! This will remove all images without at least one container associated to them.
Are you sure you want to continue? [y/N] y
Total reclaimed space: 0B
    
    
    $ k3s get deploy --all-namespaces
NAMESPACE     NAME      READY   UP-TO-DATE   AVAILABLE   AGE
kube-system   coredns   1/1     1            1           15h
    $ k3s get nodes --all-namespaces
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   15h   v1.26.3
    $ minikube stop
✋  Stopping node "minikube"  ...
🛑  Powering off "minikube" via SSH ...
🛑  1 node stopped.


