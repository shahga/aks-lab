# ************************************************
# ! OBJECTIVE: Azure Container Instance (ACI)
# Enable ACI on Azure Subscription
# Connect AKS cluster to ACI
# Pod with ACI YAML
# Create Pod in ACI
# Inspect Pod
# ************************************************

cd c:/aks-lab/m10-Scaling-ACI

# **************************
# ! Create and Set Namespace
# **************************
kubectl get namespaces
kubectl create namespace "lab"
kubectl config set-context --current --namespace "lab"


# **************
# ! Enable ACI
# *************

# ! Register Azure Providers needed for ACI
az provider register -n Microsoft.ContainerInstance
az provider register -n Microsoft.ContainerService

# See all nodes
kubectl get nodes 

# ! Enable ACI on AKS
az aks enable-addons --addons virtual-node --name "akslab-k8s" --resource-group "akslab-rgp" `
                    --subnet "akslab-aci-subnet"

# See ACI nodes
kubectl get nodes 

# ! @@ manifests/virtual-kubelet-linux-hello-world.yaml
    # nodeSelector: type: virtual-kubelet
    # tolerations: virtual-kubelet.io/provider = azure

# Deploy pods into linux virtual kubelet
kubectl apply -f manifests/virtual-kubelet-linux-hello-world.yaml
kubectl get pods -w

kubectl describe pod helloworld > helloworld-aci-output.txt

# **********
# ! Cleanup
# **********
# Delete pod
kubectl delete pod helloworld

# Disable ACI
az aks disable-addons --addons virtual-node --name "akslab-k8s" --resource-group "akslab-rgp"

kubectl delete namespace "lab"
