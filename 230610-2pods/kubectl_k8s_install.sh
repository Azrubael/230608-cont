#!/bin/bash

# unly for Linux, x86-64 architecture
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Validate the binary (optional)
# curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
# echo "Validate checksum:"
# echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

echo "Now kubectl utility installed. Greetings!"

kubectl version --client