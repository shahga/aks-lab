# ********************************************************
# ! Objective: Kubernetes Namespace, Pod, Label
# Namespaces with Kubectl
# Create Pod imperatively
# Inspect Pod
# Connect to UI served by Pod
# Exec into Pod
# Pod YAML
# Create Pod declaratively using YAML
# Labels with Kubectl
# ********************************************************

cd C:\aks-lab\m03-Namespace-Pod-Label

# *************
# ! Namespace
# *************
kubectl cluster-info

# Default Namespaces
kubectl get namespaces

# Create a Namespaces
kubectl create namespace "lab"

# Look at namespaces again and see our lab namespace
kubectl get namespaces

kubectl config set-context --current --namespace "lab"

# Deleting Namespace deletes all resources placed inside namespace
kubectl delete namespace "lab"

# *******
# ! Pod
# *******

# ! Imperatively Create Pod.  
# Run an Image in a Pod.  Name, Api Version, Image for the Contianer
# https://github.com/kubernetes-up-and-running/kuard
kubectl run kuard --generator=run-pod/v1  --image=gcr.io/kuar-demo/kuard-amd64:1 

# Get Pod 
kubectl get pods

# ! Let us see what Pod is serving
#  Proxy to the pod and see in the browser. I will split the terminal as it
kubectl port-forward kuard 8080:8080

# ! @@ Browse http://127.0.0.1:8080 and see the details in UI
    # Liveness Probes: Set Fail next three probes and see Pod recreated
    # Readiness Probes
    # Quota Requests and Limits
    # Volumes & Volume Mount

# Stop the port-forward Ctrl+C

# Exec into into the pod bash shell. Meaning Execute a command in a container. 
kubectl exec -it kuard ash

# The prompt is now inside the Container, which is running inside Kubernetes Cluster in Azure.
~ cd var 
~ ls
~ exit

# Delete Pod
kubectl delete pods kuard

# *******************************
# ! Create a Pod (Declaratively)
# *******************************

# ! @@ ./manifests/pod-example-full.yml
# Four main parts and they look very similar to Pod output. This is because via Specs we are defining the desired state of Pod.
    # Api Version. This is the version of Pod specification. It is version v1
    # Kind or type of resource specified in this document. It is Pod
    # Metadata for the Pod
            # Name. This is name of the pod.
            # Labels. These are applied to the Pod.
    # Specs. This is the specification for the Pod
        # Container
            # Image URL
            # Name of the Container
            # Port / Protocol where Pod will be listening.
            # Liveness Probes: Set Fail next three probes and see Pod recreated
            # Readiness Probes
            # Quota Requests and Limits
            # Volume Mounts
        
        # Volume - We will learn about Volume


# In another Terminal, so you can see Pods being created and deleted
kubectl get pods -w

# Create Pod declaratively using Pod Manifest
# apply a configuration to a resource specified in file
kubectl apply -f manifests/pod-example-full.yml

# Delete the configuration specified in the resource
kubectl delete -f manifests/pod-example-full.yml

kubectl apply -f manifests/pod-example-full.yml

# Get the Pod details in YAML format and save it in file.
kubectl get pod kuard -o yaml > pod-example-output.txt 

# ! @@ pod-example-output.txt
    # YAML looks very similar to Pod YAML 
    # apiVersion
    # kind 
    # creationtime
    # namespace
    # spec > container > image
    # status conditions > 
                        # pod scheduled - remember kubernetes scheduling sysytem from Kuberenetes architecture
                                    # pod has been scheduled
                        # container ready: all containers in the pod are ready
                        # initialized: any init containers have started
                        # ready: pod is ready and able to serve requests.

# I find describe easier to understand
kubectl describe pods kuard > pod-example-describe-ouput.txt

# ! @@ pod-example-describe-ouput.txt

# ******************************
# ! KUBERNETES CONCEPTS: Labels
# ******************************
# Get Pods
kubectl get pods --show-labels

# Filter Pods by Labels. This filering is also used by Kubernetes, and we will see that in Service Module
kubectl get pods --selector=app=demo

# ! @@ Azure Portal > Cluster > Namespaces
# ! @@ Azure Portal > Cluster > Workloads

# **********
# ! Cleanup
# **********
kubectl delete namespace "lab"
