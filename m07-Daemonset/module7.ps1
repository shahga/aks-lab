# **************************************************
# ! Objective: Kubernetes DaemonSet
# DaemonSet YAML
# Remove Node Label that is in Daemonset Filter
# Create DaemonSet and see that Pods are not created
# Change Nodel Label that is in Daemonset Filter
# See the Pods automatically created.  
# ****************************************************

cd c:/aks-lab/m07-Daemonset

# ***************************
# ! Create and Set Namespace
# ***************************
kubectl create namespace "lab"
kubectl config set-context --current --namespace "lab"
 
# *********************
# ! Daemonset Workload
# *********************

# ! @@ manifests/ds-example.yaml
    # node selector 

# Get nodes (point out nodeType= value)
kubectl get nodes --show-labels 

# Remove nodeType label 
kubectl label nodes <node-name> --overwrite nodeType-
kubectl label nodes aks-nodepool1-15973376-vmss000003 --overwrite nodeType-

kubectl get nodes --show-labels

# ! Second Termial 
# Show that no pods were created, as nodeSelector is looking for nodes with nodeType=Edge
kubectl get pods --watch

kubectl apply -f manifests/ds-example.yaml --record

# Change the node label and get pods agains
kubectl label nodes <node-name> --overwrite nodeType=Edge
kubectl label nodes aks-nodepool1-15973376-vmss000003 --overwrite nodeType=Edge

# Notice how the Pods or now created
kubectl get pods 

# Walk through the poperties of describe command 
kubectl describe daemonset daemonset-example > daemonset-output.txt

# Clean Up Command
kubectl delete daemonset daemonset-example

# **********
# ! Cleanup 
# **********
kubectl label nodes <node-name> --overwrite nodeType-
kubectl label nodes aks-nodepool1-15973376-vmss000003 --overwrite nodeType-


kubectl delete namespace "lab"