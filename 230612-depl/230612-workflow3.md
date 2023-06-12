# 2023-06-12  20:10
===================

# Restore deployment
    $ aws_access_key_id = XXXXXXX
aws_secret_access_key = XXXXXXX
region = XXXXXXX
output = json
    $ aws iam get-user
    $ aws s3 ls
    $ kubectl version --client --output=json
    $ kubectl config current-context
docker-desktop
    $ kubectl create deployment den-depl --image adv4000/k8sphp:latest
deployment.apps/den-depl created
    $ kubectl autoscale deployment den-depl --min=2 --max=4 --cpu-percent=80
# Error from server (AlreadyExists): horizontalpodautoscalers.autoscaling "den-depl" already exists
    $ kubectl get deploy
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
den-depl   2/2     2            2           80s
    $ kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
den-depl-76d9bbc9d9-jqsw6   1/1     Running   0          2m18s
den-depl-76d9bbc9d9-r6mft   1/1     Running   0          98s
    $ kubectl rollout history deployment/den-depl
deployment.apps/den-depl 
REVISION  CHANGE-CAUSE
1         <none>


[12] - Production image (:latest) replacement [замена продакшн образа]
[video 14:15]
    $ kubectl rollout restart deployment/den-depl
    $ kubectl rollout status deployment/den-depl
    

------------------------------------------
[13] - Writing manifest files
[video 15:35]
    $ vim 230612-first.yaml
...
    $ kubectl apply -f ./230612-depl/230612-first.yaml
deployment.apps/azweb-deployment created
    $ kubectl get deploy
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
azweb-deployment   1/1     1            1           64s
den-depl           2/2     2            2           31m
    $ vim 230612-replicas.yaml
...
    $ kubectl apply -f ./230612-depl/230612-replicas.yaml
deployment.apps/azweb-deployment-replicas created
    $ kubectl get pods
NAME                                         READY   STATUS    RESTARTS   AGE
azweb-deployment-6767cb6796-nf97n            1/1     Running   0          10m
azweb-deployment-replicas-7984898b88-cc7ls   1/1     Running   0          2m26s
azweb-deployment-replicas-7984898b88-fz2qg   1/1     Running   0          2m26s
azweb-deployment-replicas-7984898b88-k9sw7   1/1     Running   0          2m26s
den-depl-76d9bbc9d9-jqsw6                    1/1     Running   0          40m
den-depl-76d9bbc9d9-r6mft                    1/1     Running   0          40m
# ВНИМАНИЕ !!!
# На данный момент запущено три деплоймента: 
    $ kubectl get deploy
NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
azweb-deployment            1/1     1            1           8m45s
azweb-deployment-replicas   3/3     3            3           70s
den-depl                    2/2     2            2           39m

------------------------------------------
[14] - Studying the work of one of the pods and replacement a version of the application
[video 23:25]
    $ kubectl port-forward azweb-deployment-replicas-7984898b88-k9sw7 4444:80
Forwarding from 127.0.0.1:4444 -> 80
Forwarding from [::1]:4444 -> 80

# http://localhost:4444/
# Hello From Kubernetes
# Server IP Address is: 127.0.0.1
# Application version 1.0

    $  vim 230612-replicas.yaml
...
        image: adv4000/k8sphp:version2
...
    $ kubectl apply -f ./230612-depl/230612-replicas.yaml
deployment.apps/azweb-deployment-replicas configured
    $ kubectl get pods
NAME                                         READY   STATUS    RESTARTS   AGE
azweb-deployment-6767cb6796-nf97n            1/1     Running   0          21m
azweb-deployment-replicas-6d984fbb95-65bql   1/1     Running   0          2m6s
azweb-deployment-replicas-6d984fbb95-8v6b7   1/1     Running   0          2m8s
azweb-deployment-replicas-6d984fbb95-ncqb4   1/1     Running   0          2m10s
den-depl-76d9bbc9d9-jqsw6                    1/1     Running   0          52m
den-depl-76d9bbc9d9-r6mft                    1/1     Running   0          51m
    $ kubectl port-forward azweb-deployment-replicas-6d984fbb95-65bql 4444:80
Forwarding from 127.0.0.1:4444 -> 80
Forwarding from [::1]:4444 -> 80
Handling connection for 4444
Handling connection for 4444

# http://localhost:4444/
# Hello From Kubernetes
# Server IP Address is: 127.0.0.1
# Application version 1.0

------------------------------------------
[15] - Autoscaling
    $ vim 230612-autoscaling.yaml
...
    $ kubectl apply -f ./230612-depl/230612-autoscaing.yaml
deployment.apps/azweb-deployment-autoscaling configured

[16] - Cleaning
    $ docker container prune
    $ docker builder prune --all
    $ docker image prune -a
