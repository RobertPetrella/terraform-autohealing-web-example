# terraform-autohealing-web-example
The purpose of this Github project is for practising and earning how to utilise Terraform with Azure DevOps. The goal of this project is to create a load balanced VM deployment of a minimum of two Linux NGINX web servers with N+1 expandability, and to deploy a load balancer with health probing to ensure constant uptime.

This project is simply a concept and is used to primarily for myself to learn and understand the concept of Infrastructure as Code and how to do a simple write-up of IaC architecture to further improve my skill sets.

To run the project, please clone it to a working directory:
```
git clone https://github.com/RobertPetrella/terraform-autohealing-web-example.git
```

## Build and Execute Terraform Plan

### 1. Initialise Terraform
Run the following command to initialise Terraform deployment:
```
terraform init -upgrade
```
### 2. Create Terraform Plan
Run Terraform plan and parse the output file. This will determine what is necessary to create the infrastructure without executing the code.
```
terraform plan -out main.tfplan
```
### 3. Apply Terraform Plan
Apply the execution plan to the cloud infrastructure.
```
terraform apply main.tfplan
```
Note: This will only work if you create a terraform plan with the outfile in step 2 above.
If not outfile is specified, use the following command instead:
```
terraform apply
```
### 4. Test if Applied Plan has Deployed
As specified in the outputs.tf file in the repository, two parameters can be checked once applying the Terraform Plan.
View the Public IP:
```
terraform output -raw public_ip_address
```
View Resource group name:
```
terraform output -raw resource_group_name
```
### 5. Clean-up Terraform Resources
The following commands will destroy the deployed VMs and free up all resources. First, run terraform plan to setup a destroy plan:
```
terraform plan -destroy -out main.destroy.tfplan
```
Execute terraform apply to run the plan created above:
```
terraform apply main.destroy.tfplan
```

## Chosen Provider: Azure
Azure was chosen as the provider due to my familiarity of Azure.

## Assumptions
THe Web Servers for this project are designed to be ultra lightweight websites (the basic NGINX page). Several assumptions were made when calculating the requirements and to fit within a monthly running budget of <= $20AUD/month
### Virtual Machine Tier: Standard_B1s
Standard_B1s was chosen for the VM servers as these servers are just hosting a basic webpage. This provides the lowest cost for the servers while also maintaining enough storage and compute to host the basic NGINX page.
### Azure Hosting Region
East US 2 was chosen due to the cost constraint as determined by the Azure cost calculator. THis region provided the lowest cost per month to keep within the budget restraints with the chosen VM Tier above.

## IaC Architecture Drawing
![alt text](https://github.com/RobertPetrella/terraform-autohealing-web-example/blob/main/architecture/Azure_web_balancer.jpg "Azure Load Balanced Ubuntu VMs")
