
# Nginx Application with Prometheus Monitoring and ArgoCD Integration

## Overview

This project demonstrates how to deploy an Nginx application on Azure Kubernetes Service (AKS), set up Prometheus for monitoring, and use ArgoCD for GitOps-style deployment and management. Additionally, we configure an alert for high CPU usage on the Nginx pods and use Helm for Prometheus and Alertmanager installation.

---

## Steps to Run the Terraform Module and Set Up the Environment

### Prerequisites

- **Azure CLI**: Install Azure CLI [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- **Terraform**: Install Terraform [here](https://www.terraform.io/downloads)
- **kubectl**: Install kubectl [here](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- **Helm**: Install Helm [here](https://helm.sh/docs/intro/install/)
- **ArgoCD CLI**: Install ArgoCD CLI [here](https://argo-cd.readthedocs.io/en/stable/cli_installation/)

### Step 1: Set Up Terraform

1. **Create Storage Account for Terraform State**:  
   Create an Azure Storage Account to store the Terraform state files.  
   Configure the backend for Terraform state in the Azure Storage Account.

2. **Set Environment Variables** (choose one method):

   **PowerShell**:  
   `$env:ARM_SUBSCRIPTION_ID = "<your-subscription-id>"`  
   `$env:ARM_CLIENT_ID = "<your-client-id>"`  
   `$env:ARM_CLIENT_SECRET = "<your-client-secret>"`  
   `$env:ARM_TENANT_ID = "<your-tenant-id>"`

   **Bash**:  
   `export ARM_SUBSCRIPTION_ID=<your-subscription-id>`  
   `export ARM_CLIENT_ID=<your-client-id>`  
   `export ARM_CLIENT_SECRET=<your-client-secret>`  
   `export ARM_TENANT_ID=<your-tenant-id>`

   Alternatively, if you have the Azure CLI installed, run:  
   `az login`  
   `az account set --subscription <your-subscription-id>`

3. **Initialize and Apply Terraform**:  
   `terraform init`  
   `terraform plan -out=tfplan -input=false -var-file=PROD.tfvars`  
   `terraform apply -input=false -auto-approve tfplan`

---

## Connect to the AKS Cluster

1. **Get AKS Credentials**:  
   Once the Terraform process completes, configure `kubectl` to access the AKS cluster:  
   `az aks get-credentials --resource-group <your-resource-group> --name <your-cluster-name> --overwrite-existing`

---

## Install ArgoCD on AKS

1. **Install ArgoCD**:  
   Run the following commands to install ArgoCD in the AKS cluster:  
   `kubectl create namespace argocd`  
   `kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml`

2. **Expose ArgoCD UI** (optional):  
   Expose the ArgoCD UI for easier access:  
   `kubectl port-forward svc/argocd-server -n argocd 8080:443`  
   Access ArgoCD at [https://localhost:8080](https://localhost:8080).

3. **Retrieve the ArgoCD Admin Password**:  
   Get the initial password for the admin user:  
   `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo`

---

## Add Your GitHub Repository to ArgoCD

1. **Create GitHub Personal Access Token (PAT)**:  
   Go to [GitHub Personal Access Tokens](https://github.com/settings/tokens) and create a new token with `repo` access.

2. **Install ArgoCD CLI**:  
   If not already installed, you can install the ArgoCD CLI:  
   `brew install argocd`

3. **Log into ArgoCD**:  
   `argocd login <ARGOCD_SERVER> --username admin --password <YOUR_PASSWORD>`

4. **Add Your GitHub Repository**:  
   `argocd repo add https://github.com/your-user/your-private-repo.git \`  
   `--username your-username \`  
   `--password your-personal-access-token`

---

## Define ArgoCD Application

1. **Create an ArgoCD Application**:  
   Define the ArgoCD application in the `argocd-app.yaml` file and apply it to your Kubernetes cluster:  
   `kubectl apply -f ./argocd/argocd-app.yaml`

2. **Verify ArgoCD Sync**:  
   Check the status of your deployed application:  
   `kubectl get svc nginx -n default`

   Access the Nginx app externally using the external IP:  
   `curl http://<EXTERNAL-IP>`

   You should see: `Welcome to Azure AKS!`

---

## Install Prometheus and Alertmanager Using Helm

1. **Add Prometheus Helm Repository**:  
   `helm repo add prometheus-community https://prometheus-community.github.io/helm-charts`  
   `helm repo update`
   `optionally pull the repository of the chart: helm pull prometheus-community/kube-prometheus-stack --untar`

2. **Install Prometheus and Alertmanager**:  
   Use the provided `values.yaml` from the `Prometheus` folder in the repository:  
   `helm install monitoring prometheus-community/kube-prometheus-stack \`  
   `--namespace monitoring --create-namespace \`  
   `-f values.yaml`

3. **Expose Prometheus**:  
   Expose Prometheus to access the metrics:  
   `kubectl port-forward svc/monitoring-kube-prometheus-prometheus 9090 -n monitoring`

   Access Prometheus at [http://localhost:9090](http://localhost:9090).

---

## Test High CPU Usage on Nginx Pods

1. **Run High CPU Load**:  
   Simulate high CPU usage on the Nginx pod by running:  
   `kubectl get pods -l app=nginx`  
   `kubectl exec -it <nginx-pod-name> -- bash -c "while true; do echo $(($RANDOM * $RANDOM)); done"`

2. **Verify Alert in Prometheus**:  
   After a couple of minutes, the **NginxHighCPU** alert should appear in Prometheus. Access the **Alerts** tab in Prometheus UI to verify.

---

## Summary of Key Steps

1. **Nginx Deployment**: Set up with a LoadBalancer in AKS.  
2. **Prometheus Installation**: Installed using Helm.  
3. **Prometheus Scraping**: Configured with ServiceMonitor to scrape Nginx metrics.  
4. **Alert Setup**: Configured basic alert for high CPU usage in PrometheusRule.
