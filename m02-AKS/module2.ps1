# **********************************************************************
# ! Objective: AKS
# Create Azure Kubernetes Service in Azure using Azure CLI
# Overview of AKS on Azure Portal
# Connect to AKS using Azure CLI
# Try some Kubernetes CLI - Kubectl Commands
# **********************************************************************

cd c:/aks-lab/m02-AKS

# ******************
# ! AKS: Azure CLI 
# ******************
# Create Resource Group
az group create --name "akslab-rgp" --location "EastUS" `

# Create AKS using Az CLI
az aks create --name "akslab-k8s" `
                --resource-group "akslab-rgp" `
                --node-resource-group "akslab-k8s-nodes-rgp" `
                --location "EastUS" `
                --enable-cluster-autoscaler `
                --node-count 1 --min-count 1 --max-count 3 `
                --node-osdisk-size 30 --node-osdisk-type Ephemeral --node-vm-size Standard_DS2_v2 `
                --vnet-subnet-id "/subscriptions/da078965-c29e-45e8-98bd-062b43cd30d3/resourceGroups/akslab-rgp/providers/Microsoft.Network/virtualNetworks/akslab-vnet/subnets/akslab-subnet" `
                --network-plugin azure `
                --dns-name-prefix "akslab-k8s" `
                --docker-bridge-address "172.17.0.1/16" `
                --service-cidr "100.0.0.0/16" `
                --dns-service-ip "100.0.0.10" `
                --attach-acr "akslabgs"

# ************************
# ! @@ AKS on Azure Portal
# ************************
# MSDN Subscription
# Resource Group akslab-k8s-nodes-rgp
    # is managed by Azure and contains Worker Nodes related resources
# AKS Cluster akslab-rgp   
    # Left Menu: Overview 
        # Resource Group and Subscription
        # Kubernetes Version of the Master 
        # API Server Address is the address of kubeapi-server of Master Control Plane
        # Network Type: Azure CNI
        # Nodepools = 1 nodepool and Version is same Master, but it could be different.
        # Size of Virtual Machines for Worker Nodes.
    # Nodepool

# Stop AKS Cluster
az aks stop --name akslab-k8s --resource-group akslab-rgp

# Start AKS Cluster
az aks start --name akslab-k8s --resource-group akslab-rgp

# **********************
# ! Inspect AKS Cluster
# **********************
# AKS Credentials
az aks get-credentials --name akslab-k8s --resource-group akslab-rgp --admin --overwrite

# https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands

# Cluster info
kubectl cluster-info

# Current Context
kubectl config current-context

# Nodes
kubectl get nodes

# kubectl outputs
kubectl get nodes -o json
kubectl get nodes -o wide
kubectl get nodes -o yaml


# **********
# ! Cleanup
# **********
az aks update --name akslab-k8s --resource-group akslab-rgp --disable-cluster-autoscaler
az aks stop --name akslab-k8s --resource-group akslab-rgp
az aks delete --name akslab-k8s --resource-group akslab-rgp
