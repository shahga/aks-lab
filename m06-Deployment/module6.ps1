 # ***************************************************************
 # ! Objective: Kubernetes Deployment
 # Deployment YAML
 # Create Deployment
 # Inspect Deployment
 # Scale Deployment
 # Rollout and Rollback Deployment
 # ***************************************************************

cd c:/aks-lab/m06-Deployment

# ***************************
# ! Create and Set Namespace
# ***************************
kubectl create namespace "lab"
kubectl config set-context --current --namespace "lab"

# *********************
# ! Deployment Workload
# **********************

# ! @@ manifests/deployment-example.yaml
      # kind
      # name
      # replicas
      # selector
      # strategy - Rolling Update, which means one new Pod is created before existing one is deleted

# Second terminal
kubectl get replicaset -w 

# Third terminal
kubectl get pods -w 

# Create a deployment (this will create deployment, replicaset and pods). 
# Record saves the history of deployment
kubectl apply -f manifests/deployment-example.yaml --record


# Show deployment. Show how replicaSet is hash suffix. Show how pods have ReplicaSet hash suffix.
kubectl get deployment
kubectl describe deployment deploy-example


# ***************************
# ! Scaling using Deployment
# ***************************
 
# Scale the deployment 
kubectl scale deployments deploy-example --replicas=5

# Describe the deployment - show the two updates, show old and new replicasets
kubectl describe deployments


# ****************************************
# ! Rollout and Rollback using Deployment
# ****************************************

# Show the deployment history
kubectl rollout history deployment deploy-example 

# Update a container image version to 1.9.10 (revision 2)
kubectl apply -f manifests/rev2.yaml --record
kubectl rollout history deployment deploy-example


# Show Image for Pod
kubectl get pods
kubectl describe pod <pod-id>


# Update a container image version to 1.9.11 (revision 3)
kubectl apply -f manifests/rev3.yaml --record
kubectl rollout history deployment deploy-example


# Show Image for Pod
kubectl get pods
kubectl describe pod <pod-id>


# ! Undo deployment ( rolling back to version=2, go from version 1.9.11 to 1.9.10)
kubectl rollout undo deployments deploy-example --to-revision=2     


# Check the history again (notice #2 is now #4 - renumbers to the latest version)
kubectl rollout history deployment deploy-example 


# Show Image for Pod
kubectl get pods
kubectl describe pod <pod-id>


# **********
# ! CLEANUP
# **********
kubectl delete namespace "lab"