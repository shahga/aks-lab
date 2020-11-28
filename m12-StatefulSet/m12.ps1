# **********************************************************************
# ! Objective: Kubernetes StatefulSet & Headless Service
# StatefulSet YAMl
# Create StatefulSet
# Inspect StatefulSet and PersitentVolumes
# Delete-Recreate StatefulSet  and see PersistentVolumes
# Headless Service YAML
# Create Headless Service
# Inspect DNS of StatefulSet Pods
# ***********************************************************************
  
cd c:/aks-lab/m12-StatefulSet

# ***************************
# ! Create and Set Namespace
# ***************************
kubectl create namespace "lab"
kubectl config set-context --current --namespace "lab"

# ***************
# ! STATEFULSET
# **************

# ! @@ manifests/sts-example.yaml

# Second terminal see Pods being created in Sequence
kubectl get pods --show-labels --watch

# Create statefulset with update strategy onDelete
kubectl create -f manifests/sts-example.yaml

# See the statefulset
kubectl get statefulset

# See the details of statefulset, how it created four Pods in sequece and has storage for each one.
kubectl describe statefulset sts-example

# Notice the persistent volume claims
kubectl get pvc

# Now delete one of the pod. The new Pod is create with same name
kubectl delete pod sts-example-0

kubectl get pods 

# ! Storage does not get deleted for StatefulSet

# Delete the StatefulSet sts-example
kubectl delete statefulset sts-example

# View the Persistent Volume Claims.
#   Created PVCs are NOT garbage collected automatically when a StatefulSet is deleted. 
#   They must be reclaimed independently of the StatefulSet itself.

kubectl get persistentvolumeclaim -w

# In fact, Recreate the StatefulSet using the same manifest.
#   Note that new PVCs were NOT provisioned. 
#   The StatefulSet controller assumes if the matching name is present, that PVC is intended to be used for the associated Pod.

kubectl create -f manifests/sts-example.yaml --record

# View the Persistent Volume Claims again.
kubectl get persistentvolumeclaim
kubectl get pods

# ********************
#  ! Headless Service
# ********************

# Now that we have Pods running, we need DNS to connect to these Pods.
# This is where Headless Service becomes useful

# ! @@ manifests/sts-service-example.yaml

# Create a headless service in front of the STS
kubectl apply -f manifests/sts-service-example.yaml

# Looks at Headless Service. It points to four Endpoints, which are four Pods.
kubectl describe service sts-service-example

# Query the DNS entry for the app service. We will see three addresses 
kubectl exec sts-example-0 -- nslookup sts-service-example.lab.svc.cluster.local

# Query one of instances directly. This is a unique feature to StatefulSets. This allows for services to directly 
#   Interact with a specific instance of a Pod. If the Pod is updated and obtains a new IP, the DNS record will 
#   Immediately point to it enabling consistent service discovery.

kubectl exec sts-example-0 -- nslookup sts-example-1.sts-service-example.lab.svc.cluster.local

# **********
# ! Cleanup
# **********
kubectl delete svc sts-service-example
kubectl delete statefulset sts-example
kubectl delete pvc www-sts-example-0 www-sts-example-1 www-sts-example-2
kubectl delete namespace "lab"