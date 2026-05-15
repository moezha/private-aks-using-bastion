#!/bin/bash

sudo apt -qq update

# install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# install Kubectl CLI
snap install kubectl --classic

# ==========================================
# Commands to run ONCE logged into the VM:
# ==========================================
# az login --identity
# az aks list -o table
# az aks get-credentials -g rg-private-aks-bastion-moez -n aks-cluster
# kubectl get nodes