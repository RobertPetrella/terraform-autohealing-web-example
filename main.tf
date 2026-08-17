#Configure Azure provider for Terraform
terraform {
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 3.0.2"
      }
    }

    required_version = "value"
}

provider "azurerm" {
    features {}
  
}

resource "azurerm_resource_group" "rg" {
    name = "azure-resource"
    location = "Australia East"
}

#setup Virtual Networks for Azure load balanced VMs
resource "azurerm_virtual_network" "vnet" {
  name = "azurevm-vnet"
  address_space = ["10.0.0.0/16"]
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name = "azurevm-subnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes =  ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  count = 2
  name = "azurevm-nic-${count.index}"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Create Network security groups for secure TCP connections
resource "azurerm_network_security_group" "securetcp" {
  name                = "secure-network-group"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "web"
    priority                   = 1008
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.1.0/24"
  }
}

#Associate the security group to the VMs subnet
resource "azurerm_subnet_network_security_group_association" "securetcp_assicaition" {
  subnet_id = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.securetcp.id
  
}

#Configure Azure Ubuntu VMs
resource "azurerm_linux_virtual_machine" "vm" {
  name = "azurevm-vm"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id,]
  size = "Standard_DS1_v2"

  admin_ssh_key {
    username = "admin"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts"
    version = "latest"
  }
  provision_vm_agent = true
  allow_extension_operations = true #Allows extensions to run in VM
}

#Deploy NGINX Onto VMs utilising a bash script to update apt and deploy NGINX
resource "azurerm_virtual_machine_extension" "deploy_nginx" {
  name = "deploy-nginx"
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
  publisher = "Microsoft.Azure.Extensions"
  type = "CustomScript"
  type_handler_version = "2.1"
  settings = <<SETTINGS
  {
    "commandToExecute": "sudo apt update && sudo apt install -y nginx && sudo systemctl enable nginx && sudo systemctl start nginx"
  }
  SETTINGS
}