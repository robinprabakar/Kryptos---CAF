resource "azurerm_network_interface" "NtwrkIntrfce_spkVM" {
  name                = var.NtwrkIntrfce_spkVM_name
  location            = var.Spoke_SharedSvcs_location
  resource_group_name = var.Spoke_SharedSvcs_resource_group_name

  ip_configuration {
    name                          = var.NtwrkIntrfce_spkVM_ip_name
    subnet_id                     = var.NtwrkIntrfce_spkVM_subnet_id
    private_ip_address_allocation = var.NtwrkIntrfce_spkVM_private_ip_address_allocation
  }
}

resource "azurerm_windows_virtual_machine" "SpkMachine" {
  name                = var.SpkMachine_name
  resource_group_name = var.Spoke_SharedSvcs_resource_group_name
  location            = var.Spoke_SharedSvcs_location
  size                = var.SpkMachine_size
  admin_username      = var.SpkMachine_admin_username
  admin_password      = var.SpkMachine_admin_password
  network_interface_ids = [
    var.SpkMachine_network_interface_id,
  ]

  os_disk {
    caching              = var.SpkMachine_os_disk_cashing
    storage_account_type = var.SpkMachine_os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.SpkMachine_source_image_reference_publisher
    offer     = var.SpkMachine_source_image_reference_offer
    sku       = var.SpkMachine_source_image_reference_sku
    version   = var.SpkMachine_source_image_reference_version
  }
}
