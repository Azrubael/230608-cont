# 2023-06-12  16:00
===================
Create and manage Deployments

[1] - Start docker engine

[2] - Run my image created from a 'Dockerfile' in ./230609-apache/:

    $ docker run -d --name 230612-az -p 4444:80 azrubael/first-steps:latest
Unable to find image 'azrubael/first-steps:latest' locally
latest: Pulling from azrubael/first-steps
7c457f213c76: Pull complete 
8c9da577c546: Pull complete 
6837e0e217f3: Pull complete 
f93e2ab2d03f: Pull complete 
Digest: sha256:7567903e5713c3c4a9ab37f47cfa70ac18abe5b1fc3e23960a2f7074042e525c
Status: Downloaded newer image for azrubael/first-steps:latest
7cd3f8935b8599b6ae5026fd23b7ced0f034eeeb28075b3aa2de5e772fb80d58
    $ docker images
REPOSITORY              TAG        IMAGE ID       CREATED         SIZE
azrubael/first-steps    latest     391ef1427bc0   2 days ago      174MB
nginx                   latest     f9c14fe76d50   2 weeks ago     143MB
httpd                   latest     d1676199e605   2 weeks ago     145MB
    $ docker container ls -a
CONTAINER ID   IMAGE                         COMMAND                  CREATED         STATUS         PORTS                  NAMES
7cd3f8935b85   azrubael/first-steps:latest   "/bin/sh -c 'apachec…"   3 minutes ago   Up 3 minutes   0.0.0.0:4444->80/tcp   230612-az


[3] - Wisit a test page
# http://localhost:4444/
# Azrubael Test Page
# This is a simple page for the Apache deployment in Docker


[4] - Stop a running container
    $ docker container stop 7cd3f8935b85
7cd3f8935b85
    $ CONTAINER ID   IMAGE                         COMMAND                  CREATED         STATUS                        PORTS     NAMES
7cd3f8935b85   azrubael/first-steps:latest   "/bin/sh -c 'apachec…"   7 minutes ago   Exited (137) 16 seconds ago             230612-az
    $ docker container rm 7cd3f8935b85 -f
7cd3f8935b85
    $ docker container ls -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
    $

[5] - Creating a new *.yaml file for run a pod
    $ vim ../230610-2pods/4-first-steps.yaml
apiVersion: v1
kind: Pod
metadata:
  name  : az-first-steps
  labels:
    env  : training
    app  : main
    tier : backend
    owner: azrubael
spec:
  containers:
    - name  : azbuntu-worker
      image : azrubael/first-steps:latest
      ports :
        - containerPort: 80
 
        
------------------------------------------
[6] - Run a new pod with my image 'azrubael/first-steps:latest'
# Check AWS
    $ aws_access_key_id = XXXXXXX
aws_secret_access_key = XXXXXXX
region = XXXXXXX
output = json
    $ aws iam get-user
    $ kubectl version --client --output=json
    $ aws s3 ls
    $ kubectl config current-context
docker-desktop
    $ kubectl apply -f 4-first-steps.yaml --dry-run=client
pod/az-first-steps created (dry run)
    $ kubectl apply -f 4-first-steps.yaml
pod/az-first-steps created
    $ kubectl get pods
NAME             READY   STATUS             RESTARTS   AGE
az-first-steps   0/1     ImagePullBackOff   0          113s
    $ kubectl describe pods az-first-steps
Name:             az-first-steps
Namespace:        default
Priority:         0
Service Account:  default
Node:             docker-desktop/192.168.65.4
...
Type     Reason     Age                  From               Message
----     ------     ----                 ----               -------
Warning  Failed     39s (x4 over 2m18s)  kubelet            Error: ErrImagePull
Warning  Failed     25s (x6 over 2m17s)  kubelet            Error: ImagePullBackOff

# Решил не тратить время и удалить с жесткого диска под, контейнер и образ
    $ kubectl delete -f 4-first-steps.yaml
pod "az-first-steps" deleted
    $ docker images
...
    $ docker rmi 391ef1427bc0 -f
    $ docker builder prune --all
WARNING! This will remove all build cache. Are you sure you want to continue? [y/N] y
Total:	0B

# Непонятно почему у меня контекст докера и поды запускаются именно докером
# Может быть так и нужно?


------------------------------------------
[7] - Start work with training program
    $ kubectl create deployment den-depl --image adv4000/k8sphp:latest
deployment.apps/den-depl created
    $ kubectl get deploy
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
den-depl   1/1     1            0           34s
    $ kubectl describe pods den-depl
Name:             den-depl-76d9bbc9d9-gmn8f
Namespace:        default
Priority:         0
Service Account:  default
Node:             docker-desktop/192.168.65.4
Start Time:       Mon, 12 Jun 2023 16:54:47 +0300
Labels:           app=den-depl
                  pod-template-hash=76d9bbc9d9
...
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  94s   default-scheduler  Successfully assigned default/den-depl-76d9bbc9d9-gmn8f to docker-desktop
  Normal  Pulling    93s   kubelet            Pulling image "adv4000/k8sphp:latest"
  Normal  Pulled     29s   kubelet            Successfully pulled image "adv4000/k8sphp:latest" in 1m4.21365184s (1m4.213750883s including waiting)
  Normal  Created    28s   kubelet            Created container k8sphp
  Normal  Started    28s   kubelet            Started container k8sphp
    $ kubectl describe deployment den-depl
...
    $ kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
den-depl-76d9bbc9d9-gmn8f   1/1     Running   0          12m

# Итог: деплоймент создал под, который нормальной виден через гуй докера,
# а его диагностическая информация имеет положительный характер
[video 02:30]


------------------------------------------
[8] - Deploy scaling [масштабирование развертывания]
[video 04:25]
    $ kubectl scale deployment den-depl --replicas 3
deployment.apps/den-depl scaled
    $ kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
den-depl-76d9bbc9d9-gmn8f   1/1     Running   0          15m
den-depl-76d9bbc9d9-r6lvt   1/1     Running   0          30s
den-depl-76d9bbc9d9-v5q79   1/1     Running   0          30s
    $ kubectl get deploy
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
den-depl   3/3     3            3           16m

# check replicas set
    $ kubectl get rs
NAME                  DESIRED   CURRENT   READY   AGE
den-depl-76d9bbc9d9   3         3         3       18m
# check self recovering
    $ kubectl delete pods den-depl-76d9bbc9d9-v5q79
pod "den-depl-76d9bbc9d9-v5q79" deleted
    $ kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
den-depl-76d9bbc9d9-gmn8f   1/1     Running   0          20m
den-depl-76d9bbc9d9-kskqx   1/1     Running   0          12s    <- recovered!
den-depl-76d9bbc9d9-r6lvt   1/1     Running   0          5m48s


------------------------------------------
[9] - Autoscaling [автомасштабирование развертывания]
[video 06:39]
    $ kubectl autoscale deployment den-depl --min=2 --max=4 --cpu-percent=80
horizontalpodautoscaler.autoscaling/den-depl autoscaled
    $ kubectl get deploy
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
den-depl   3/3     3            3           26m
# check horizontal pods autoscaling
    $ kubectl get hpa
NAME       REFERENCE             TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
den-depl   Deployment/den-depl   <unknown>/80%   2         4         3          2m17s


------------------------------------------
[10] - Image update [обновление образа контейнера путем его замены]
[video 08:20]
# Предварительная проверка истории разворачивания развертывания
    $ kubectl rollout status deployment/den-depl
deployment "den-depl" successfully rolled out
    $ kubectl rollout history deployment/den-depl
deployment.apps/den-depl 
REVISION  CHANGE-CAUSE
1         <none>
    $ kubectl describe deployment den-depl
...
  Containers:
   k8sphp:          <- Важно знать название контейнера
    Image:        adv4000/k8sphp:latest
...
    $ kubectl set image deployment/den-depl k8sphp=adv4000/k8sphp:version1 --record
Flag --record has been deprecated, --record will be removed in the future
deployment.apps/den-depl image updated
    $ kubectl set image deployment/den-depl k8sphp=adv4000/k8sphp:version2 --record
    $ kubectl rollout status deployment/den-depl
Waiting for deployment "den-depl" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "den-depl" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "den-depl" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "den-depl" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "den-depl" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "den-depl" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "den-depl" rollout to finish: 1 old replicas are pending termination...
Waiting for deployment "den-depl" rollout to finish: 1 old replicas are pending termination...
deployment "den-depl" successfully rolled out
    $ kubectl rollout history deployment/den-depl
deployment.apps/den-depl 
REVISION  CHANGE-CAUSE
1         <none>
2         kubectl set image deployment/den-depl k8sphp=adv4000/k8sphp:version1 --record=true

------------------------------------------
[11] - Image rollback [откат образа контейнера на предыдущую версию]
[video 12:09]
    $ kubectl rollout undo deployment/den-depl
deployment.apps/den-depl rolled back
    $ kubectl rollout history deployment/den-depl
deployment.apps/den-depl 
REVISION  CHANGE-CAUSE
2         kubectl set image deployment/den-depl k8sphp=adv4000/k8sphp:version1 --record=true
3         <none>
# После отката не предыдущую версию
    $ kubectl set image deployment/den-depl k8sphp=adv4000/k8sphp:version2 --record
Flag --record has been deprecated, --record will be removed in the future
deployment.apps/den-depl image updated
    $ kubectl rollout history deployment/den-depl
deployment.apps/den-depl 
REVISION  CHANGE-CAUSE
2         kubectl set image deployment/den-depl k8sphp=adv4000/k8sphp:version1 --record=true
3         <none>
4         kubectl set image deployment/den-depl k8sphp=adv4000/k8sphp:version2 --record=true
# После раскручивания :version2 (исправленной)
    $ kubectl rollout undo deployment/den-depl --to-revision=3
    $ $ kubectl rollout undo deployment/den-depl --to-revision=3
deployment.apps/den-depl rolled back
    $ kubectl rollout history deployment/den-depl
deployment.apps/den-depl 
REVISION  CHANGE-CAUSE
2         kubectl set image deployment/den-depl k8sphp=adv4000/k8sphp:version1 --record=true
4         kubectl set image deployment/den-depl k8sphp=adv4000/k8sphp:version2 --record=true
5         <none>
    $ kubectl describe deployment den-depl
[video 12:09]

# Внимение: продакш-образ врегда должен быть ':latest', а другие версии могут
# использоваться только для тестирования
# Далее рассмотрен процесс замены продакшн-образа ':latest'

    $ kubectl delete deployment/den-depl
deployment.apps "den-depl" deleted
