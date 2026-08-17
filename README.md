# terraform-autohealing-web-example
The purpose of this Github project is for prracticing and earning how to utilise Terraform with Azure DevOps. The goal of this project is to create a load balanced VM deployment of a minimum of two Linux NGINX web servers with N+1 explandability, and to deploy a load balancer with health probing to ensure constant uptime.

This project is simply a concept and is used to primarily for myself to learn and understand the concept of Infrastructure as Code and how to do a simple writeup of IaC architecture to further improve my skillsets.

## Chosen Provider: Azure
Azure was chosen as the provider due to my familiarity of Azure.

## Assumptions
THe Web Servers for this project are designed to be ultra lightweight websites (the basic NGINX page). Several assumptions were made when calculating the requirements and to fit within a monthly running budget of <= $20AUD/month
### Virtual Machine Tier: Standard_B1s
Standard_B1s was chosen for the VM servers as these servers are just hosting a basic webpage. This provides the lowest cost for the servers while also maintaining enough storage and compute to host the basic NGINX page.
### Azure Hosting Region
East US 2 was chosen due to the cost constraint as determined by the Azure cost calculator.
