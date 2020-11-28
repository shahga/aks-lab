 # **********************************************************************
# ! Objective: Kubernetes Selector, LoadBalancer, ClusterIp, ExternalName
# Cluster IP Service YAML
# Create ClusterIP Service
# Inspect ClusterIP Service
# LoadBalancer Service YAML
# Create LoadBalancer Service
# Inspect LoadBalancer Service
# ExternalName Service YAML
# Create ExternalName Service
# Inspect ExternalName Service
# ***********************************************************************

cd c:/aks-lab/m04-Selector-Service

# ***************************
 # ! Create and Set Namespace
# ****************************
kubectl get namespaces
kubectl create namespace "lab"
kubectl config set-context --current --namespace "lab"


 # *******************
 # ! CLusterIp Service
 # ********************

 # ! @@ ./manifests/pod-example.yaml  ...same kuard Pod YAML we have already seen.

# Create Pod for Service
kubectl apply -f manifests/pod-example.yaml

# Notice the Pods have labels app=kuard and environment=prod
kubectl get pods -o wide --show-labels

# ! @@ ./manifests/service-clusterip.yaml
    # Kind = Service
    # Select pods with Label app = kuard
    # targetPort = 80 and Port = 80


# Create a service based on the equality operator 
kubectl create -f manifests/service-clusterip.yaml

# Notice the Cluster IP
kubectl get service

# Describe the newly created service. 
kubectl describe service clusterip-example > cluster-ip-output.txt

# ! @@ cluster-ip-output.txt 

# It is listening on Port 80 and connecting to Port 80 on the backend
# The Pod it is connecting to is in Endpoints


# ***********************
# ! LoadBalancer Service
# ***********************

# ! @@ manifests/service-loadbalancer.yaml
        # Line 6 Load Balancer

# Watch in another terminal
kubectl get service -w

# Add a load balancer  (This creates an Azure Load Balancer)
kubectl apply -f manifests/service-loadbalancer.yaml

# Describe the load balancer service (Note the load balancer Ingress)
kubectl describe service loadbalancer-example > loadbalancer-output.txt

# ! @@ loadbalancer-output.txt

# ! @@ http://<load-balancer-ip>

# ************************
# ! ExternalName Service
# ************************

# Create an ExternalName service called externalname that points to google.com
kubectl create service externalname externalname-example --external-name=www.google.com

# Look at the generated DNS record has been created 
kubectl exec -it pod-example -- ash

#  At container prompt
~ $ nslookup externalname-example.lab.svc.cluster.local
~ $ exit

#  Now show in UI
kubectl port-forward pod-example 8080:8080
# https://127.0.0.1:8080 
# In UI lookup DNS externalname-example.lab.svc.cluster.local

# ! @@ Azure Portal > Services 

# **********
# ! Cleanup
# **********
kubectl delete -f manifests/service-clusterip.yaml
kubectl delete -f manifests/service-loadbalancer.yaml
kubectl delete service externalname-example
kubectl delete namespace "lab"
