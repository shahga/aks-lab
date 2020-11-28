# **********************************************
# ! Objective: DOCKER, AZURE CONTAINER REGISTRY
# Sample ASP Dotnet Core Application - TaskApi
# Understand DockerFile
# Try some Docker CLI commands
# Build Image using Docker CLI
# Create Azure Container Registry
# Push Image to Azure Container Registry
# Pull Image from Azure Container Registry
# Run ASP Dotnet Core Application - TaskApi
# **********************************************

# ************************************
# ! @@ TaskApi Project and its 
# ! @@ ./aisazdevops-taskapi/Dockerfile 
# *************************************
# *********************
# ! Build Docker Image
# *********************

cd c:/aks-lab/m01-Docker/aisazdevops-taskapi

# See local Docker Images 
docker images

# See local Docker Container Instances 
docker ps -a

# Stop running Container and Clean Images 
docker stop  <id>
docker rm <container-name or id>


# Build the docker image
# Make sure linux containers are selected 
docker build -t taskapi-aspnetcore:v1 .

# **************************
# ! Azure Container Registry
# **************************
az group create --name akslab-rgp --location eastus

az acr create --name akslabgs  --resource-group akslab-rgp --location eastus  --sku Premium
az acr login --name akslabgs --resource-group akslab-rgp

# On Azure Portal 
#   Overview: Login Server, Storage Capacity
#   Repositories
#   Replications


# ***************************************************************************************
# ! Push Docker Image for Registry
# ***************************************************************************************
# Tag the Docker Image with Remove Registry 
docker tag taskapi-aspnetcore:v1 akslabgs.azurecr.io/taskapi-aspnetcore:v1

# Push Docker Image
docker push akslabgs.azurecr.io/taskapi-aspnetcore:v1

# Pull and Run Docker Image
docker pull akslabgs.azurecr.io/taskapi-aspnetcore:v1
docker images 
docker inspect < image_id>
docker run -d -p30090:80 <image-id>

docker run -d -p30090:80 akslabgs.azurecr.io/taskapi-aspnetcore:v1


# Open in Browser
# http://127.0.0.1:30090/swagger

# *********
# ! Cleanup
# *********
docker ps
docker stop <container-id>
docker rm <container-id>
docker rmi akslabgs.azurecr.io/taskapi-aspnetcore:v1 --force
docker rmi taskapi-aspnetcore:v1 --force

