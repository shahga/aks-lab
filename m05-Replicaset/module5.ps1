# ************************************************************************
# ! Objective: Kubernetes Replicaset
# ReplicaSet YAML
# Create ReplicaSet
# Inspect ReplicaSet
# Delete one Pod and see ReplicaSet create one new Pod
# Scale ReplicaSet
# ************************************************************************

cd c:/aks-lab/m05-Replicaset

# ***************************************
# ! Create and Set Namespace
# ***************************************
kubectl create namespace "lab"
kubectl config set-context --current --namespace "lab"

# ***********************
# ! Replicaset Workload
# ************************

# ! @@ manifests/rs-example.yaml

# Split terminal
kubectl get pods -w

# Create a Replicaset (in another window watch pods)
kubectl apply -f manifests/rs-example.yaml

# See the Replicaset
kubectl get replicaset -o wide


# Let us take a closer look at our Replicaset
kubectl describe replicaset replicaset-example > replicaset-output.txt
    # Selector
    # Replicas 


# Pods managed by Replicaset 
kubectl get pods

# Describe the pod and point out "Controlled By:  ReplicaSet/replicaset-example"
kubectl describe pod <pod-name>

kubectl describe pod replicaset-example-sq4nx


# Split the Terminal window, and watch the Pod lifecycle
kubectl get pods --watch


# Delete a pod and see it recreated
kubectl delete pod <pod-name>

kubectl delete pod replicaset-example-8lt2z


# Scale up the replica count to 5, see two additional instances being created.
kubectl scale replicaset replicaset-example --replicas=5


# Cleanup 
kubectl delete replicaset replicaset-example


# **********
# ! CLEANUP
# **********
kubectl delete -f manifests/rs-example.yaml
kubectl delete namespace "lab"