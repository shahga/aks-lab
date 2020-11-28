# *******************
# ! Objective: Setup
# Docker
# Kubernetes CLI
# Azure CLI
# Azure Subscription
# VS Code
# *******************

# Get Code
git clone https://www.github.com/shahga/aks-lab


# Install Docker Desktop Engine
# docker Commands 
# https://docs.docker.com/docker-for-windows/install/

# ! @ Show Docker Engine in Windows Bar

docker --version

# Kubernetes CLI - kubectl commands
# https://kubernetes.io/docs/tasks/tools/install-kubectl/
kubectl version
Set-Alias -Name k -Value 'C:/Program Files/Docker/Docker/Resources/bin/kubectl.exe'

# Azure CLI - az commands
# https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
az --version


# Install Kubernetes Command-line tool and kubelogin and plugin for Azure authentication
az aks install-cli 

az upgrade

# Azure CLI, AKS Preview Features
az extension add --name aks-preview

# Azure MSDN Subscription
# https://portal.azure.com

# Visual Studio Code [OPTIONAL]
# https://code.visualstudio.com/Download
