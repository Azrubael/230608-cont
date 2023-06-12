#!/bin/bash

# Download the kubectl 1.27 binary for your cluster's Kubernetes version from Amazon S3
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.27.1/2023-04-19/bin/linux/amd64/kubectl

# (Optional) Verify the downloaded binary with the SHA-256 checksum for your binary.
# curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.27.1/2023-04-19/bin/linux/amd64/kubectl.sha256
# sha256sum -c kubectl.sha256
# openssl sha1 -sha256 kubectl


# Apply execute permissions to the binary.
chmod +x ./kubectl

# Copy the binary to a folder in your PATH.
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH

# Add the $HOME/bin path to your shell initialization file so that it is configured when you open a shell.
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc

# After you install kubectl, you can verify its version
kubectl version --short --client