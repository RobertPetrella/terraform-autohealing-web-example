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

#Configure Azure Ubuntu VMs
resource "azurerm_virtual_machine" "vm" {
  name = "$azurevm-vm"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22-04-lts"
    version = "latest"
  }

  storage_os_disk {
    name = "mainosdisk1"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name = "examplewebserver"
    admin_username = "fakeadmin"
    admin_password = "FakePassword1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}