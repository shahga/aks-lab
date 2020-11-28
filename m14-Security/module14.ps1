#***************************************************************************************
#! OBJECTIVE: Kubernetes Security:  ServiceAccount, ClusterRole and ClusterRoleBinding 
#***************************************************************************************


cd C:\aks-lab\m14-Security

# ! Namespace Setup
kubectl create namespace concepts
kubectl config set-context --current --namespace "concepts"

# **********************************
# ! ClusterRole, Rolebinding for Pod
# ***********************************

# Create a Service Account 
# 1. Execute the Command below to perform the following steps:
# 	- Create a custom service account foo
# 	- Create a role “service-reader” that only has read permissions on services resource 
# 	- Bind the “service-reader” role to foo
# 	- create a Pod with the custom service principle foo 

kubectl apply -f manifests/security-example.yaml
# Open a bash shell inside the Pod
kubectl exec security-example  -it -- bash

# 2. Execute the below Commands inside the pod and finally run an API command

token=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
hostname=kubernetes.default.svc
curl -v --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt -H "Authorization:Bearer $token" https://$hostname:443/api/v1/namespaces/default/services
#   Note:  The output should contain HTTP/1.1 200 OK
  
curl -v --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt -H "Authorization:Bearer $token" https://$hostname:443/api/v1/namespaces/default/secrets
#   Note:  The output should contain HTTP/1.1 200 OK
exit

# *******************************************************************
# ! ClusterRole, Rolebinding for Pod with access to Services removed
# *******************************************************************

#--> Illustrate the updated yaml with changed permissions

# 	- Original Line:  resources: ["services", "endpoints", "pods", "secrets"]
# 	- Updated Line:   resources: ["endpoints", "pods", "secrets"]  

kubectl apply -f manifests/security-example-updated.yaml

# Open a bash shell inside the Pod
kubectl exec security-example -it --   bash

# 4. Execute the below Commands inside the pod and run an API command
token=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
hostname=kubernetes.default.svc

#   Services:  The output should contain HTTP/1.1 403 Forbidden 
curl -v --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt -H "Authorization:Bearer $token" https://$hostname:443/api/v1/namespaces/default/services
  
#  Secrets:  The output should contain HTTP/1.1 200 OK
curl -v --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt -H "Authorization:Bearer $token" https://$hostname:443/api/v1/namespaces/default/secrets
exit

# **********
# ! Cleanup
# **********
kubectl delete serviceaccount security-example-serviceaccount
kubectl delete clusterrole security-example-clusterrole
kubectl delete clusterrolebinding security-example-rolebinding

kubectl delete namespace "concepts"

