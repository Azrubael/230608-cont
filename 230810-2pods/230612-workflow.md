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
    $ kubectl apply -f /mnt/SSDATA/CODE/Python-projects/230608-cont/230810-2pods/2-azapache.yaml --dry-run=client
pod/azapache-230811 created (dry run)
    $ kubectl apply -f /mnt/SSDATA/CODE/Python-projects/230608-cont/230810-2pods/2-azapache.yaml

-----------------------
Error from server (BadRequest): error when creating "/mnt/SSDATA/CODE/Python-projects/230608-cont/230810-2pods/2-azapache.yaml": Pod in version "v1" cannot be handled as a Pod: strict decoding error: unknown field "metadata.region", unknown field "spec.containers[0].instanceType"


-----------------------
[c.4] Create a pod "myapp" with two containers


[c.5]