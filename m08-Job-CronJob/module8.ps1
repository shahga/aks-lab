# *****************************************************************
#  ! Objective: Kubernetes Job, CronJob
# Job YAML
# Create Job
# Inspect Job
# CronJob YAML
# Create CronJob
# Inspect CronJob
# *****************************************************************

cd c:\aks-lab\m08-Job-CronJob

# ***************************
# ! Create and Set Namespace
# ***************************
kubectl create namespace "lab"
kubectl config set-context --current --namespace "lab"
 
# *******
# ! JOB
# *******
 
# ! @@ manifests/job-example.yaml

# Second Terminal
kubectl get pods --watch

# create a job object and wacth the jobs being created
kubectl create -f manifests/job-example.yaml

kubectl get pods --show-labels

# ! @@ 
# Only two Pods are being provisioned at a time; since we specified parallelism = 2 
# This is done until the total number of completions is satisfied, which is 4.
# Additionally, the Pods are labeled with controller-uid, this acts as a unique ID for that specific Job.
# When done, the Pods persist in a Completed state. They are not deleted after the Job is completed or failed. 
    # This is intentional to better support troubleshooting.

# Describe the job object. show Events of four Pods.
kubectl describe job job-example > job-output.t

# logs from the job object, shows "hello.." output
kubectl get pods
kubectl logs <job-example-pod-name>

kubectl logs xxx

# Delete the job.
kubectl delete job job-example

# Now the Pods are gone
kubectl get pods

# **********
# ! Cronjob
# **********
# ! @@ manifests/cronjob-example.yaml

# Create CronJob cronjob-example 
# It is configured to run the Job from the earlier example every minute, 
# using the cron schedule "*/1 * * * *". This schedule is UTC ONLY.

kubectl create -f manifests/cronjob-example.yaml

# Give it some time to run, and then list the Jobs.
kubectl get jobs -w

# The CronJob controller will purge Jobs according to the successfulJobHistoryLimit and failedJobHistoryLimit attributes. 
kubectl get Cronjob cronjob-example

# Delete the Cronjob
kubectl delete cronjob cronjob-example

# **********
# ! Cleanup 
# **********
kubectl delete namespace "lab"