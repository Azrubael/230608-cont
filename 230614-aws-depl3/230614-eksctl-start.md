# 2023-08-13  19:52
===================

https://eksctl.io/usage/creating-and-managing-clusters/

Create a simple cluster with the following command:
    $ eksctl create cluster
NB: That will create an EKS cluster in your default region (as specified by your AWS CLI configuration) with one managed nodegroup containing two m5.large nodes.
After the cluster has been created, the appropriate kubernetes configuration will be added to your kubeconfig file. This is, the file that you have configured in the environment variable KUBECONFIG or ~/.kube/config by default. The path to the kubeconfig file can be overridden using the --kubeconfig flag.

---------------------------------
    $ vim azCluster.yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: azCluster
  region: eu-central-1
nodeGroups:
  - name: az-1
    instanceType: t3.micro
    desiredCapacity: 2
    volumeSize: 80
  - name: az-2
    instanceType: t2.micro
    desiredCapacity: 1
    volumeSize: 50

---------------------------------

Next, run this command:
    $ eksctl create cluster -f azCluster.yaml
2023-06-13 20:12:53 [ℹ]  eksctl version 0.144.0
2023-06-13 20:12:53 [ℹ]  using region eu-central-1
...
2023-06-13 20:34:39 [ℹ]  node "ip-192-168-15-237.eu-central-1.compute.internal" is ready
2023-06-13 20:34:39 [ℹ]  node "ip-192-168-48-159.eu-central-1.compute.internal" is ready
2023-06-13 20:34:39 [ℹ]  adding identity "arn:aws:iam::427443251551:role/eksctl-azCluster-nodegroup-az-2-NodeInstanceRole-FE74HJBHN5AB" to auth ConfigMap
2023-06-13 20:34:40 [ℹ]  nodegroup "az-2" has 0 node(s)
2023-06-13 20:34:40 [ℹ]  waiting for at least 1 node(s) to become ready in "az-2"
2023-06-13 20:35:15 [ℹ]  nodegroup "az-2" has 1 node(s)
2023-06-13 20:35:15 [ℹ]  node "ip-192-168-59-192.eu-central-1.compute.internal" is ready
2023-06-13 20:35:17 [ℹ]  kubectl command should work with "/home/uh/.kube/config", try 'kubectl get nodes'
2023-06-13 20:35:17 [✔]  EKS cluster "azCluster" in "eu-central-1" region is ready

# Поднятие кластера заняло около 25 минут

    $ kubectl get nodes
NAME                                              STATUS   ROLES    AGE     VERSION
ip-192-168-15-237.eu-central-1.compute.internal   Ready    <none>   2m28s   v1.25.9-eks-0a21954
ip-192-168-48-159.eu-central-1.compute.internal   Ready    <none>   2m29s   v1.25.9-eks-0a21954
ip-192-168-59-192.eu-central-1.compute.internal   Ready    <none>   94s     v1.25.9-eks-0a21954

    $ kubectl get nodes --all-namespaces
NAME                                              STATUS   ROLES    AGE     VERSION
ip-192-168-15-237.eu-central-1.compute.internal   Ready    <none>   3m43s   v1.25.9-eks-0a21954
ip-192-168-48-159.eu-central-1.compute.internal   Ready    <none>   3m44s   v1.25.9-eks-0a21954
ip-192-168-59-192.eu-central-1.compute.internal   Ready    <none>   2m49s   v1.25.9-eks-0a21954

https://*.console.aws.amazon.com/ec2/home?region=*#Instances:instanceState=running

### Удаление учебного кластера
    $ eksctl delete cluster -f azCluster.yaml
2023-06-13 20:42:44 [ℹ]  deleting EKS cluster "azCluster"
2023-06-13 20:42:44 [ℹ]  will drain 2 unmanaged nodegroup(s) in cluster "azCluster"
...
2023-06-13 20:45:26 [ℹ]  waiting for CloudFormation stack "eksctl-azCluster-nodegroup-az-1"
2023-06-13 20:45:27 [ℹ]  will delete stack "eksctl-azCluster-cluster"
2023-06-13 20:45:27 [✔]  all cluster resources were deleted
