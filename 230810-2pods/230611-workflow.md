# 2023-06-11  11:15
===================

Work plan
a) Check AWS    [✔]
b) Return to raising of AWS clusters    [✔]
c) Return to study of pods with AWS
d) Deployments


========================================================================

[a] - Check AWS    [✔]

    $ ~/k8s/start.sh
    $ cat ~/.aws/config
[default]
aws_access_key_id = XXXXXXX
aws_secret_access_key = XXXXXXX
region = XXXXXXX
output = json

-----------------------
    $ aws iam get-user
{
    "User": {
        "Path": "/",
        "UserName": "uu",
        "UserId": "XXXXXX",
        "Arn": "YYYYYYYY",
        "CreateDate": "2023-06-10T16:26:21+00:00",
        "Tags": [
            {
                "Key": "XXXXXXX",
                "Value": "AWS_ACCESS_KEY"
            }
        ]
    }
}

-----------------------
    $ kubectl version --client --output=json
{
  "clientVersion": {
    "major": "1",
    "minor": "27+",
    "gitVersion": "v1.27.1-eks-2f008fe",
    "gitCommit": "abfec7d7e55d56346a5259c9379dea9f56ba2926",
    "gitTreeState": "clean",
    "buildDate": "2023-04-14T20:43:13Z",
    "goVersion": "go1.20.3",
    "compiler": "gc",
    "platform": "linux/amd64"
  },
  "kustomizeVersion": "v5.0.1"
}
-----------------------
    $ aws s3 ls
ни ответа ни привета)
    $ kubectl cluster-info
матюки т.к. нету кластера
    $ kubectl get nodes
матюки т.к. нету нодов
    $ kubectl get pods
матюки т.к. нету подов

========================================================================

[b] - Return to raising of AWS clusters    [✔]

    $ eksctl create cluster -f mycluster.yaml
2023-06-11 17:55:39 [ℹ]  eksctl version 0.144.0
2023-06-11 17:55:39 [ℹ]  using region eu-central-1
...
2023-06-11 18:10:53 [ℹ]  kubectl command should work with "/home/uh/.kube/config", try 'kubectl get nodes'
2023-06-11 18:10:53 [✔]  EKS cluster "az-k8s-230811" in "eu-central-1" region is ready

[video 12:55]
-----------------------
[video 14:00]
    $ kubectl cluster-info
Kubernetes control plane is running at https://67009F21C56B2521CF9EEBC7BDAAACF9.gr7.eu-central-1.eks.amazonaws.com
CoreDNS is running at https://67009F21C56B2521CF9EEBC7BDAAACF9.gr7.eu-central-1.eks.amazonaws.com/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

-----------------------
    $ kubectl get nodes
NAME                                             STATUS   ROLES    AGE     VERSION
ip-192-168-51-35.eu-central-1.compute.internal   Ready    <none>   5m58s   v1.25.9-eks-0a21954
ip-192-168-75-46.eu-central-1.compute.internal   Ready    <none>   5m59s   v1.25.9-eks-0a21954

-----------------------
    $ aws emr list-clusters
{
    "Clusters": []
}
-----------------------
    $ kubectl cluster-info dump
...
многабукаф  

-----------------------
    $ eksctl delete cluster --name az-k8s-230811
УДАЛЯТЬ ОБЯЗАТЕЛЬНО!

========================================================================
[c]
    $ export AWS_ACCESS_KEY_ID=XXXXXX
    $ export AWS_SECRET_ACCESS_KEY=XXXXXXX
    $ export AWS_DEFAULT_REGION=XXXXXXX
    $ aws s3 ls
в ответ не должно быть ничего, если нет рабочих нод и т.п.
    $ eksctl create cluster -f 1-mycluster.yaml --dry-run
apiVersion: eksctl.io/v1alpha5
availabilityZones:
...

-----------------------
https://hub.docker.com/         login
#    $ kubectl run hello --generator=run-pod/v1 --image=azrubael/first-steps:latest --port=80
# Устарело после Kubernetes 1.16 !!!
    $ kubectl run hello --image=azrubael/first-steps:latest --port=80 --dry-run=client
# дальше не стал работать с этим вариантом из-за того, что поднимется платный нод
[video 04:00]
    
-----------------------

[c.3] Create a pod "myweb" with one apache container
    $ vim 2-azapache.yaml
apiVersion: v1
kind: Pod

metadata:
  name  : azapache-230811
  region: eu-central-1

spec:
  containers:
    - name             : azapache-worker
      instanceType     : t3.micro

-----------------------
    $ kubectl apply -f 2-azapache.yaml --dry-run=client
# ERROR
# The connection to the server localhost:8080 was refused - did you specify the right host or port?
    $ kubectl config view
apiVersion: v1
clusters: null
contexts: null
current-context: ""
kind: Config
preferences:
    $ kubectl config get-contexts
CURRENT   NAME   CLUSTER   AUTHINFO   NAMESPACE

# https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#-em-set-context-em- 

##############################################
created a new user 'awsuhcli'
    $ aws configure
    $ aws configure
AWS Access Key ID [****************32UJ]: 
AWS Secret Access Key [****************85bc]: 
Default region name [*******]: 
Default output format [json]: 
##############################################
    $ kubectl config current-context
docker-desktop
    $ kubectl apply -f 2-azapache.yaml --dry-run=client
pod/azapache-230811 created (dry run)


-----------------------
[c.4] Create a pod "myapp" with two containers


[c.5]