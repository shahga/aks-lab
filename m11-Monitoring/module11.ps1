# *******************************************************
# ! OBJECTIVE: AKS Monitoring
# Enable Azure Monitor
# Inspect Azure Monitor for Containers on Azure Portal
# *******************************************************

# ! Create Log Analytics/Azure Monitor Workspace
az monitor log-analytics workspace create --resource-group "akslab-rgp" `
                                          --workspace-name "akslab-log" --location EastUS

# ! Enable AKS Monitoring
az aks enable-addons --name "akslab-k8s" --resource-group "akslab-rgp" `
                        --addons monitoring `
                        --workspace-resource-id "/subscriptions/da078965-c29e-45e8-98bd-062b43cd30d3/resourcegroups/akslab-rgp/providers/microsoft.operationalinsights/workspaces/akslab-log"


# ! @@ Multi Cluster Dashboard
    # Azure Portal > Services > Monitor > Container 
        # Show Monitored Clusters
        # Show Un-Monitored Clusters

# ! @@ Insights
    # akslab-k8s > Insights
        # Cluster - Overall Cluster level view
            # Node CPU Utilization
            # Node Memory Utilization
            # Node Count
            # Active Pod Count
        # Nodes            
            # Pods running on each Node
            # Pod details: Type of Pod, Labels, CPU Requests/Limits 
            # View LiveData: Streaming Logs
        # Controller
            # View of Pods by Controllers like Replicaset, DaemonSet, Deployment.
        # Containers
            # View of Pods
        # Deployments
        # ! Recommended Alerts

# ! @@ Logs

# ! @@ Diagonize & Solve Problems 

# ! Disable AKS Monitoring
az aks disable-addons --name "akslab-k8s" --resource-group "akslab-rgp" `
                        --addons monitoring
