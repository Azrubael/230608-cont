# 2023-06-14  17:36
===================

[1] - Check AWS
===============================================
    $ aws_access_key_id = XXXXXXX
aws_secret_access_key = XXXXXXX
region = XXXXXXX
output = json
    $ aws iam get-user
    $ kubectl version --client --output=json
    $ aws s3 ls
    $ kubectl config current-context
error: current-context is not set
    $ vim 1-azCluster.yaml
-------------------------------------
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name  : az-k8s-230614
  region: eu-central-1

nodeGroups:
  - name             : azworker-g1
    instanceType     : t3.micro
    desiredCapacity  : 2


-------------------------------------
    $ eksctl create cluster -f 1-azCluster.yaml
2023-06-14 17:50:31 [ℹ]  eksctl version 0.144.0
2023-06-14 17:50:31 [ℹ]  using region ...
...   
2023-06-14 18:07:36 [ℹ]  nodegroup "azworker-g1" has 2 node(s)
2023-06-14 18:07:36 [ℹ]  node "ip-192-168-34-215.eu-central-1.compute.internal" is ready
2023-06-14 18:07:36 [ℹ]  node "ip-192-168-77-177.eu-central-1.compute.internal" is ready
2023-06-14 18:07:38 [ℹ]  kubectl command should work with "******/config", try 'kubectl get nodes'
2023-06-14 18:07:38 [✔]  EKS cluster "az-k8s-230614" in "YYYYYYYYYY" region is ready

    $ kubectl config current-context
XX@az-k8s-230614.YYYYYYYYYY.eksctl.io
    $ kubectl get nodes
NAME                                              STATUS   ROLES    AGE    VERSION
ip-192-168-34-215.YYYYYYYYYY.compute.internal   Ready    <none>   4m4s   v1.25.9-eks-0a21954
ip-192-168-77-177.YYYYYYYYYY.compute.internal   Ready    <none>   4m9s   v1.25.9-eks-0a21954
    $ kubectl get pods
No resources found in default namespace.




[2] - Creating a pod with one container
===============================================
    $ vim 2-monopod.yaml
-------------------------------------
apiVersion: v1
kind: Pod

metadata:
  name  : azapache-230614
  labels:
    env  : training
    app  : main
    tier : backend
    owner: azrubael

spec:
  containers:
    - name  : azapache-singleton
      image : nginx:latest
#      image : httpd:latest
      ports :
        - containerPort: 80
-------------------------------------

    $ kubectl apply -f 2-monopod.yaml
pod/azapache-230614 created
    $  kubectl get pods
NAME              READY   STATUS    RESTARTS   AGE
azapache-230614   1/1     Running   0          46s
    $ kubectl describe pods azapache-230614
Name:             azapache-230614
Namespace:        default
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  2m3s  default-scheduler  Successfully assigned default/azapache-230614 to ip-192-168-34-215.eu-central-1.compute.internal
  Normal  Pulling    2m2s  kubelet            Pulling image "nginx:latest"
  Normal  Pulled     117s  kubelet            Successfully pulled image "nginx:latest" in 5.024085132s (5.024107267s including waiting)
  Normal  Created    117s  kubelet            Created container azapache-singleton
  Normal  Started    117s  kubelet            Started container azapache-singleton

    $ kubectl port-forward azapache-230614 4444:80
Forwarding from 127.0.0.1:4444 -> 80
Forwarding from [::1]:4444 -> 80

# http://localhost:4444/
# Welcome to nginx!



[3] - Creating a second pod with two containers
===============================================
    $ vim 3-dualpod.yaml
-------------------------------------
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
      image : httpd:latest
      ports :
        - containerPort: 80
    - name  : aztomcat-worker
      image : tomcat:8.5.38
      ports :
        - containerPort: 8080
-------------------------------------

# In a NEW SHELL !!!
    $ aws_access_key_id = XXXXXXX
aws_secret_access_key = XXXXXXX
region = XXXXXXX
    $ kubectl apply -f 3-dualpod.yaml
pod/azapp-230812 created
    $ kubectl get nodes --all-namespaces
NAME                                              STATUS   ROLES    AGE   VERSION
ip-192-168-34-215.eu-central-1.compute.internal   Ready    <none>   19m   v1.25.9-eks-0a21954
ip-192-168-77-177.eu-central-1.compute.internal   Ready    <none>   19m   v1.25.9-eks-0a21954
    $ kubectl get pods --all-namespaces
NAMESPACE     NAME                      READY   STATUS    RESTARTS   AGE
default       azapache-230614           1/1     Running   0          11m
default       azapp-230812              2/2     Running   0          102s
kube-system   aws-node-6cg7r            1/1     Running   0          19m
kube-system   aws-node-ww7qh            1/1     Running   0          19m
kube-system   coredns-cbbbbb9cb-l9v58   1/1     Running   0          29m
kube-system   coredns-cbbbbb9cb-pfnlf   1/1     Running   0          29m
kube-system   kube-proxy-jtpjh          1/1     Running   0          19m
kube-system   kube-proxy-rtbv2          1/1     Running   0          19m
    $ kubectl port-forward azapp-230812 4445:8080
Forwarding from 127.0.0.1:4445 -> 8080
Forwarding from [::1]:4445 -> 8080

# http://localhost:4445/
# Apache Tomcat/8.5.38

    $ kubectl port-forward azapp-230812 4445:80
Forwarding from 127.0.0.1:4445 -> 80
Forwarding from [::1]:4445 -> 80
^C


[4] - Deleting unwanter resources
=================================
    $ $ eksctl get cluster
NAME		REGION		EKSCTL CREATED
az-k8s-230614	eu-central-1	True

    $ kubectl delete -f 2-monopod.yaml
pod "azapache-230614" deleted
    $ kubectl delete -f 3-dualpod.yaml
pod "azapp-230812" deleted
    $ eksctl delete cluster -f 1-azCluster.yaml
2023-06-14 18:35:09 [ℹ]  deleting EKS cluster "az-k8s-230614"
2023-06-14 18:35:09 [ℹ]  will drain 1 unmanaged nodegroup(s) in cluster "az-k8s-230614"
2023-06-14 18:35:09 [ℹ]  starting parallel draining, max in-flight of 1
...
2023-06-14 18:37:53 [ℹ]  waiting for CloudFormation stack "eksctl-az-k8s-230614-nodegroup-azworker-g1"
2023-06-14 18:37:53 [ℹ]  will delete stack "eksctl-az-k8s-230614-cluster"
2023-06-14 18:37:54 [✔]  all cluster resources were deleted

    $ eksctl get cluster
No clusters found

[16] - Cleaning
    $ docker container prune
    $ docker builder prune --all
    $ docker image prune -a


    
