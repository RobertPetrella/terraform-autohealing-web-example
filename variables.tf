#Terraform variables
variable "location" {
    description = "Azure Region location"
    default = "Australia East"
}

variable "resource_group_name" {
    description = "Resource Group Name"
}

variable "vm_admin_username" {
    description = "Admin username for VM"
}

variable "vm_admin_password" {
    description = "Admin password for VM creation"
    sensitive = true
}