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
    

========================================================================
[c]

[c.3] Create a pod "myweb" with one apache container


[c.4] Create a pod "myapp" with two containers


[c.5]