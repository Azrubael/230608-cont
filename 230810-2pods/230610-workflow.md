# 2023-08-10  13:25
========================

[1] Create AWS kubernetes cluster
    Install three applications
========================

1.1) Required IAM permissions
========================

1.2) awscli     `command run authentication`
    https://docs.aws.amazon.com/cli/latest/userguide/cli-chapinstall.html
    $ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    $ unzip awscliv2.zip
    $ sudo ./aws/install
You can now run: /usr/local/bin/aws --version
    $ aws --version
aws-cli/2.11.27 Python/3.11.3 Linux/5.15.0-73-generic exe/x86_64.ubuntu.22 prompt/off
* OR
    $ cat awscli_README.md
========================

1.3) kubectl    `for cluster management`
    https://kubernetes.io/docs/tasks/tools/install-kubectl/
    $ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    $ sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    $ kubectl version --client
* OR
    $ kubectl_k8s_install.sh
* OR
    $ curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.27.1/2023-04-19/bin/linux/amd64/kubectl
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 46.9M  100 46.9M    0     0  2988k      0  0:00:16  0:00:16 --:--:-- 3411k
    $ ll
total 48104
drwxrwxr-x  2 uh uh     4096 Jun 10 16:14 ./
drwxr-x--- 39 uh uh     4096 Jun 10 16:14 ../
-rw-rw-r--  1 uh uh 49246208 Jun 10 16:15 kubectl
    $ chmod +x ./kubectl
    $ mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
    $ kubectl version --client
Client Version: v1.27.1-eks-2f008fe
Kustomize Version: v5.0.1
* OR 
    $ kubectl_AWS_install.sh
========================
    
1.4) eksctl     `elastic container service, to create clusters`
    https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html
    $ curl -sLO "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
    $ ll
total 79656
drwxrwxr-x  3 uh uh     4096 Jun 10 16:32 ./
drwxr-x--- 40 uh uh     4096 Jun 10 16:21 ../
drwxr-xr-x  3 uh uh     4096 Jun  9 16:36 aws/
-rw-rw-r--  1 uh uh 32301257 Jun 10 16:32 eksctl_Linux_amd64.tar.gz
-rwxrwxr-x  1 uh uh 49246208 Jun 10 16:15 kubectl*
    $ tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
    $ sudo mv /tmp/eksctl /usr/local/bin
    $ eksctl version
0.144.0
* OR
    $ eksctl_install.sh

-------------------------------------------------------------
# вариант установки по версии Дениса Астахова из репозитория pip3
    $ sudo su
    $ pip3 install awscli --upgrade
    $ mkdir ~/kubernetes/

========================================================================

[2] Checks and turning services
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
---------------
    $ export AWS_ACCESS_KEY_ID=xxxxxxx
    $ export AWS_SECRET_ACCESS_KEY=xxxxxxx
    $ export AWS_DEFAULT_REGION=xxxxxxx
    $ aws sts get-caller-identity
{
    "UserId": "xxxxxxx",
    "Account": "xxxxxxx",
    "Arn": "arn:aws:iam::yyyyyyy:user/xxxxxxx"
}
---------------
    $ aws iam get-user
{
    "User": {
        "Path": "/",
        "UserName": "xxxxxxx",
        "UserId": "yyyyyyy",
        "Arn": "arn:aws:iam::yyyyyyy:user/xxxxxxx",
        "CreateDate": "2023-06-10T16:26:21+00:00",
        "Tags": [
            {
                "Key": "xxxxxxx",
                "Value": "AWS_ACCESS_KEY"
            }
        ]
    }
}
---------------
    $ aws s3 ls
    $ aws configure set region eu-central-1
    $ aws configure set output json
    $ aws configure set role_session_name xxxxxx
    $ aws configure set role_arn arn:aws:iam::yyyyyyy:user/xxxxxxx
    $ aws configure set source_profile default
    
###OR
    $ aws configure --profile uh
    ...
========================================================================


[2] Create training cluster
    $ eksctl create cluster --name az-k8s
    ...
DEPLOYING A CLUSTER (it should takes a few minutes)
    ...
2023-06-10 21:00:04 [ℹ]  nodegroup "ng-451e529b" has 2 node(s)
2023-06-10 21:00:04 [ℹ]  node "ip-192-168-4-34.eu-central-1.compute.internal" is ready
2023-06-10 21:00:04 [ℹ]  node "ip-192-168-83-191.eu-central-1.compute.internal" is ready
2023-06-10 21:00:06 [ℹ]  kubectl command should work with "/home/uh/.kube/config", try 'kubectl get nodes'
2023-06-10 21:00:06 [✔]  EKS cluster "az-k8s" in "eu-central-1" region is ready
[video 07:40]
    $ kubectl cluster-info
Kubernetes control plane is running at https://6D05CBF181837B6FD17E89694BA5E1D1.gr7.eu-central-1.eks.amazonaws.com
CoreDNS is running at https://6D05CBF181837B6FD17E89694BA5E1D1.gr7.eu-central-1.eks.amazonaws.com/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
    $ kubectl get nodes
NAME                                              STATUS   ROLES    AGE   VERSION
ip-192-168-4-34.eu-central-1.compute.internal     Ready    <none>   18m   v1.25.9-eks-0a21954
ip-192-168-83-191.eu-central-1.compute.internal   Ready    <none>   18m   v1.25.9-eks-0a21954
    $ kubectl cluster-info dump
    ...
# МНОГАБУКАФФ
    ...
    $ eksctl delete cluster --name az-k8s
# ОБЯЗАТЕЛЬНО УДАЛИТЬ, Т.К. НЕРЕАЛЬНО ДОРОГО!!!    
2023-06-10 21:30:29 [ℹ]  will delete stack "eksctl-az-k8s-cluster"
2023-06-10 21:30:30 [✔]  all cluster resources were deleted
    $ aws emr list-clusters
{
    "Clusters": []
}

[video 12:20]
========================================================================

[3] Create a pod "myweb" with one apache container


[4] Create a pod "myapp@ with two containers


[5]