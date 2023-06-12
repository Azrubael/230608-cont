# 2023-06-12  09:00
===================

Work plan
a) Check AWS    [✔]
b) Return to raising of AWS clusters    [✔]
c) Return to study of pods with AWS
d) Deployments



Create a new commit "Step #03. Summing up yesterday's work: launched kubectl"


[c]  Return to study of pods with AWS

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
    $ kubectl apply -f 2-azapache.yaml --dry-run=client
pod/azapache-230811 created (dry run)

-----------------------
    $ kubectl apply -f 2-azapache.yaml
Error from server (BadRequest): error when creating "2-azapache.yaml": Pod in version "v1" cannot be handled as a Pod: strict decoding error: unknown field "metadata.region", unknown field "spec.containers[0].instanceType"
    $ vim 2-azapache.yaml
apiVersion: v1
kind: Pod
metadata:
  name  : azapache-230811
  labels:
    env  : training
    app  : main
    tier : backend
    owner: azrubael
spec:
  containers:
    - name  : azapache-worker
      image : azbuntu18-apache2:latest
      ports :
        - containerPort: 80

-----------------------
    $ kubectl apply -f 2-azapache.yaml
pod/azapache-230811 created
    $ kubectl get pods
NAME              READY   STATUS             RESTARTS   AGE
azapache-230811   0/1     ImagePullBackOff   0          4m20s
    $ kubectl describe pods azapache-230811
Name:             azapache-230811
Namespace:        default
Priority:         0
Service Account:  default
Node:             docker-desktop/192.168.65.4
Start Time:       Mon, 12 Jun 2023 09:47:23 +0300
Labels:           app=main
                  env=training
                  owner=azrubael
                  tier=backend
Annotations:      <none>
Status:           Pending
...
# В названии образа 'azbuntu18-apache2:latest' была опечатка

-----------------------
    $ kubectl delete -f 2-azapache.yaml
pod "azapache-230811" deleted
    $ kubectl apply -f 2-azapache.yaml
    $ kubectl get pods
NAME              READY   STATUS              RESTARTS   AGE
azapache-230811   0/1     ContainerCreating   0          4s
    $ kubectl describe pods azapache-230811
...

Type    Reason     Age   From               Message
----    ------     ----  ----               -------
Normal  Scheduled  14s   default-scheduler  Successfully assigned default/azapache-230811 to docker-desktop
Normal  Pulling    14s   kubelet            Pulling image "httpd:latest"

[video 18:40] 
-----------------------
    $ kubectl port-forward azapache-230811 4444:80
Forwarding from 127.0.0.1:4444 -> 80
Forwarding from [::1]:4444 -> 80

http://localhost:4444/
IT WORKS!!!

# Теперь пробуем заменить образ 'httpd:latest' на 'nginx:latest'
# после редактирования *.yaml звпускаем apply еще раз
    $ vim 
...
    $ kubectl apply -f 2-azapache.yaml
# все работает норм

===========================================================
[video 18:40] 
[c.4] Create a pod "myapp" with two containers
    $ vim 3-dual.yaml
apiVersion: v1
kind: Pod
metadata:
  name  : azapp-230812
  labels:
    env  : training
    app  : main
    tier : backend
    owner: azrubael
spec:
  containers:
    - name  : aznginx-worker
      image : nginx:latest
      ports :
        - containerPort: 80      
    - name  : aztomcat-worker
      image : tomcat:8.5.38
      ports :
        - containerPort: 8080
        
-----------------------
    $ kubectl apply -f 3-dual.yaml
pod/azapp-230812 created
    $ kubectl get pods
NAME           READY   STATUS    RESTARTS   AGE
azapp-230812   0/2     Pending   0          12s
    $ kubectl describe pods azapp-230812
Name:             azapp-230812
Namespace:        default
Priority:         0
Service Account:  default
Node:             docker-desktop/192.168.65.4
Start Time:       Mon, 12 Jun 2023 10:47:08 +0300
Labels:           app=main
                  env=training
                  owner=azrubael
                  tier=backend
...
Normal  Created    4s    kubelet            Created container aztomcat-worker
Normal  Started    4s    kubelet            Started container aztomcat-worker

### С разных терминалов !!!
    $ kubectl port-forward azapp-230812 4444:8080
# http://localhost:4444/
# Apache Tomcat/8.5.38
    $ kubectl port-forward azapp-230812 4445:80
# http://localhost:4445/
# Welcome to nginx!
    $ kubectl get pods
NAME           READY   STATUS    RESTARTS   AGE
azapp-230812   2/2     Running   0          9m1s
    $ kubectl delete -f 3-dual.yamlpod "azapp-230812" deleted


[c.5]