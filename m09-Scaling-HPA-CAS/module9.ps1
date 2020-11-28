# ****************************************************************************
# ! OBJECTIVE:  Kubernetes Horizontal Pod Scaler, AKS Cluster Auto Scaler 
# Create Service and Pods via Deployment 
# Configure Horizontal Pod Autoscaler
# Enable Cluster Auto Scaler
# See Nodes Scale as we increase the number of Pods
# ****************************************************************************

cd c:/aks-lab/m09-Scaling-HPA-CAS

# *****************************
# ! Create and Set Namespace
# ****************************
kubectl create namespace lab
kubectl config set-context --current --namespace "lab"

# **************************************
# ! Create Pod and Service via Deployment
# ***************************************

# Create Pod via Deployment and put a Service on top of it.
# ! @@ manifests/scale-example.yml

# Second terminal
kubectl get service  -w

kubectl apply -f manifests/scale-example.yml

# When the "EXTERNAL-IP" changes from <pending> to a value, navigate to the IP with your web browser to verify the app is working.
# http://<external-ip>/swagger http://20.62.191.249/swagger

# http://40.88.208.27/swagger


# ******************************************
# ! Pod Auto Scaling - Horizontal Pod Scaler
# ******************************************

# Now scale our app such that if average CPU comsumption for Pod exceeds 50% increase number of Pods to maximum of 10
kubectl autoscale deployment scale-example-v1 --cpu-percent=50 --min=1 --max=10

# We can see the status of your pods with:
kubectl get horizontalpodautoscaler
kubectl get pods

# ! Cleanup
kubectl delete hpa scale-example-v1

# ******************************************
# ! Node Scaling - Cluster Auto Scaler (AKS)
# *******************************************

# ! Manual Node Scaling
kubectl get nodes
az aks scale -g "akslab-rgp" -n "akslab-k8s" --node-count 1


# ! Cluster Auto Scaling
az aks update `
  --resource-group "akslab-rgp" `
  --name "akslab-k8s" `
  --enable-cluster-autoscaler `
  --min-count 1 `
  --max-count 3

# Second terminal, see 25 pods running across at least two if not all three nodes
kubectl get pods -o wide -w

# Then we can scale our PODs (we set a max of 20 per node) to 25:
kubectl scale --replicas=35 deployment/scale-example-v1

# ! @@ Azure Portal - Node Count

# Disable Autoscaler
az aks update --resource-group "akslab-rgp" --name "akslab-k8s" --disable-cluster-autoscaler

# Scaling the Nodes down to one
az aks scale -g akslab-rgp -n akslab-k8s --node-count 1

# **********
# ! Cleanup
# **********
kubectl delete namespace "lab"