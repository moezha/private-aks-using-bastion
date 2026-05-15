resource "azurerm_network_interface" "nic-vm" {
  name                 = "nic-vm"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-vm.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = null
  }
}

resource "azurerm_linux_virtual_machine" "vm-linux" {
  name                            = "vm-linux-jumpbox"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_D2s_v3" 
  disable_password_authentication = true
  admin_username                  = var.admin_username
  network_interface_ids           = [azurerm_network_interface.nic-vm.id]
  priority                        = "Spot"
  eviction_policy                 = "Delete"

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("~/.ssh/id_rsa.pub") 
  }

  custom_data = filebase64("./install-tools.sh")

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.identity-vm.id]
  }

  os_disk {
    name                 = "os-disk-vm"
    caching              = "ReadWrite"       
    storage_account_type = "StandardSSD_LRS" 
    disk_size_gb         = 64 
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy" 
    sku       = "22_04-lts-gen2" 
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }
}