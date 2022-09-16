variable "Hub_resource_group_name" {
    default = "Shared-HUB-RG"
}

variable "Hub_location" {
    default = "South India"
}

variable "Hub_virtual_network" {
    default = "Shared-HUB-Vnet"
}
 
variable "bassubnet" {
    default = "AzureBastionSubnet"
}

variable "AppGtwysubnet" {
    default = "AppGatewaySubnet"
}

variable "GWsubnet" {
    default = "GatewaySubnet"
}

variable "sparesnet" {
    default = "VM-HUB-SNET"
}

variable "Hub_Bas_resource_group_name" {
    default = "hub-bast-rsg"
}

variable "Hub_Bas_location" {
    default = "South India"
}

variable "Appgw_resource_group_name" {
    default = "Shared-HUB-RG"
}

variable "Appgw_location" {
    default = "South India"
}

variable "Gateway_resource_group_name" {
    default = "Shared-HUB-RG"
}

variable "Gateway_location" {
    default = "South India"
}

variable "HubManagement_resource_group_name" {
    default = "hub-mgmt-rsg"
}

variable "HubManagement_location" {
    default = "South India"
}

variable "automation_account_name" {
    default = "AutomationAccount"
}

variable "Log_Analytics_Workspace_name" {
    default = "LG-Monitor-HUB"
}

variable "HubIdentity_resource_group_name" {
    default = "hub-idm-rg"
}

variable "HubIdentity_location" {
    default = "South India"
}

variable "key_vault_name" {
    default = "Kryptos-KV"
}

variable "recovery_services_vault_name" {
    default = "Kryptos-RSV"
}

variable "Spoke_resource_group_name" {
    default = "Prod-RG"
}

variable "Spoke_location" {
    default = "South India"
}

variable "Spoke_virtual_network" {
    default = "Prod-Vnet"
}

variable "SpkAppSnet" {
    default = "App-Spoke-Snet"
}

variable "SpkDBSub" {
    default = "DB-Spoke-Snet"
}

variable "SpkSpareSnet" {
    default = "Web-Spoke-Snet"
}

variable "Spoke_app_resource_group_name" {
    default = "APP-SPOKE-RG"
}

variable "Spoke_app_location" {
    default = "South India"
}

variable "Spoke_Db_resource_group_name" {
    default = "DB-Spoke-RG"
}

variable "Spoke_Db_location" {
    default = "South India"
}

variable "Spoke_SharedSvcs_resource_group_name" {
    default = "Web-Spoke-RG"
}

variable "Spoke_SharedSvcs_location" {
    default = "South India"
}

variable "Spoke_key_vault_name" {
    default = "Spoke-KV"
}

variable "Firewall_Snet" {
    default = "AzureFirewallSubnet"
}

variable "Bastion_PubIp_name" {
    default = "Bastion-PIP"
}

variable "Bastion_Host_name" {
    default = "AzureBastionHost"
}

variable "AppGw_pubIp_name" {
    default = "APG-PIP"
}

variable "App_Gw_name" {
    default = "App-Gateway"
}

variable "Vpn_pubIp_name" {
    default = "VGN-PIP"
}

variable "Virtual_Network_Gw_name" {
    default = "VPN-Site1"
}

variable "Local_Ntwrk_Gw_name" {
    default = "KryptosLngTag"
}

variable "Kryptos_connections_name" {
    default = "KryptosConnectionsTag"
}

variable "Firewall_PubIp_name" {
    default = "Firewall-PIP"
}

variable "Hub_Firewall_name" {
    default = "HubFirewall"
}

variable "Hub_Spoke_Peering_name" {
    default = "HubToSpokePeering"
}

variable "Spoke_Hub_Peering_name" {
    default = "SpokeToHubPeering"
}

variable "Spoke_Vnet_RT" {
    default = "RouteTableSpoke"
}

variable "Management_group_name" {
    default = "CAF Management Group"
}

variable "Hub_Firewall_Policy" {
    default = "HubFirewallPolicy"
}

variable "Dnat_Firewall_Rule_name" {
    default = "DnatRules"
}

variable "Network_Firewall_Rule_name" {
    default = "NetworkRules"
}

variable "Application_Firewall_Rule_name" {
    default = "ApplicationRules"
}

variable "Policy_def_network_int_name" {
    default = "NetworkInterface"
}

variable "Network_int_policy_type" {
    default = "Custom"
}

variable "Network_int_mode" {
    default = "All"
}

variable "Network_int_display_name" {
    default = "Network interfaces should not have public IPs"
}

variable "NetworkAssign_name" {
    default = "NetworkAssignment"
}

variable "NetworkAssign_policy_definition_id" {
    default = "azurerm_policy_definition.Interface1.id"
}

variable "Policy_def_LocationDef_name" {
    default = "only-deploy-in-southindia"
}

variable "LocationDef_policy_type" {
    default = "Custom"
}

variable "LocationDef_mode" {
    default = "All"
}

variable "LocationDef_display_name" {
    default = "Allowed locations"
}

variable "LocAssign_name" {
    default = "LocationAssignment"
}

variable "LocationAssign_policy_definition_id" {
    default = "azurerm_policy_definition.LocationDef.id"
}

variable "NtwrkSG_name" {
    default = "MyTagNSG"
}

variable "rule1_name" {
    default = "NSGRule1"
}

variable "rule1_priority" {
    default = "400"
}

variable "rule1_direction" {
    default = "Inbound"
}

variable "rule1_access" {
    default = "Allow"
}

variable "rule1_protocol" {
    default = "Tcp"
}

variable "rule1_source_port_range" {
    default = "*"
}

variable "rule1_destination_port_range" {
    default = "9389"
}

variable "rule1_source_address_prefix" {
    default = "10.0.0.1"
}

variable "rule1_destination_address_prefix" {
    default = "172.16.36.0"
}

variable "rule2_name" {
    default = "NSGRule2"
}

variable "rule2_priority" {
    default = "500"
}

variable "rule2_direction" {
    default = "Inbound"
}

variable "rule2_access" {
    default = "Allow"
}

variable "rule2_protocol" {
    default = "Udp"
}

variable "rule2_source_port_range" {
    default = "*"
}

variable "rule2_destination_port_range" {
    default = "123"
}

variable "rule2_source_address_prefix" {
    default = "10.0.0.1"
}

variable "rule2_destination_address_prefix" {
    default = "172.16.36.0"
}

variable "rule3_name" {
    default = "NSGRule3"
}

variable "rule3_priority" {
    default = "600"
}

variable "rule3_direction" {
    default = "Inbound"
}

variable "rule3_access" {
    default = "Allow"
}

variable "rule3_protocol" {
    default = "Udp"
}

variable "rule3_source_port_range" {
    default = "*"
}

variable "rule3_destination_port_range" {
    default = "0-65535"
}

variable "rule3_source_address_prefix" {
    default = "10.0.0.1"
}

variable "rule3_destination_address_prefix" {
    default = "172.16.36.0"
}

variable "NtwrkSG_tag" {
    default = "NSGEnvironmentTag"
}

variable "NtwrkIntrfce_spkVM_name" {
    default = "NetworkInterface_SpokeVM"
}

variable "NtwrkIntrfce_spkVM_ip_name" {
    default = "SpkVmInternalIp"
}

variable "NtwrkIntrfce_spkVM_subnet_id" {
    default = "azurerm_subnet.SpokeSpare.id"
}

variable "NtwrkIntrfce_spkVM_private_ip_address_allocation" {
    default = "Dynamic"
}

variable "SpkMachine_name" {
    default = "VM-Spoke-WEB"
}

variable "SpkMachine_size" {
    default = "Standard_F2"
}

variable "SpkMachine_admin_username" {
    default = "Windows"
}

variable "SpkMachine_admin_password" {
    default = "Windows@12345"
}

variable "SpkMachine_network_interface_id" {
    default = "azurerm_network_interface.NtwrkIntrfce_spkVM.id"
}

variable "SpkMachine_os_disk_cashing" {
    default = "ReadWrite"
}

variable "SpkMachine_os_disk_storage_account_type" {
    default = "Standard_LRS"
}

variable "SpkMachine_source_image_reference_publisher" {
    default = "MicrosoftWindowsServer"
}

variable "SpkMachine_source_image_reference_offer" {
    default = "WindowsServer"
}

variable "SpkMachine_source_image_reference_sku" {
    default = "2016-Datacenter"
}

variable "SpkMachine_source_image_reference_version" {
    default = "latest"
}

variable "Route_Configuration_name" {
    default = "RouteConfiguration"
}

variable "Address_prefix_range" {
    default = "0.0.0.0/0"
}

variable "Appliance_type_name" {
    default = "VirtualAppliance"
}

variable "Appliance_type_ip_address" {
    default = "10.0.5.4"
}

variable "Spoke_Vnet_route_table_id" {
    default = "azurerm_route_table.SpkV-NetRT.id"
}
