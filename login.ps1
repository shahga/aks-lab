# **********************
# ! Connect to Azure
# **********************
az login
az account set --subscription <your subscription name>


# **********************
# ! Connect to ACR
# **********************
az acr login --name akslabgs --resource-group akslab-rgp


# *****************
# ! Connect to AKS
# *****************
az aks get-credentials --name akslab-k8s --resource-group akslab-rgp --admin --overwrite


# *****************
# ! Start/Stop AKS
# *****************
az aks stop --name akslab-k8s --resource-group akslab-rgp
az aks start --name akslab-k8s --resource-group akslab-rgp


# ***************
# ! Set Namespace
# ***************
kubectl config set-context --current --namespace "lab"
