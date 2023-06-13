# 2023-06-13  10:39
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

[15] - Autoscaling [continue yesterday's work]
    $ kubectl apply -f ./230612-depl/230612-autoscaing.yaml
