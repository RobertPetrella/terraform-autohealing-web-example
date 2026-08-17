#Terraform variables
variable "location" {
    description = "Azure Region location"
    default = "Australia East"
}

variable "vm_admin_username" {
    description = "Admin username for VM"
}

variable "vm_admin_password" {
    description = "Admin password for VM creation"
    sensitive = true
}