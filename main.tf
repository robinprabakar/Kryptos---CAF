provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "v-netRG" {
  name     = "Shared-HUB-RG"
  location = "South India"
}

resource "azurerm_virtual_network" "example" { 
  name                = "Shared-HUB-Vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.v-netRG.location
  resource_group_name = azurerm_resource_group.v-netRG.name
}

resource "azurerm_subnet" "BasSub" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.v-netRG.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "AppGwSub" {
  name                 = "AppGatewaySubnet"
  resource_group_name  = azurerm_resource_group.v-netRG.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "Gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.v-netRG.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.3.0/24"]
}  

resource "azurerm_subnet" "Spare" {
  name                 = "VM-HUB-SNET"
  resource_group_name  = azurerm_resource_group.v-netRG.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.4.0/24"]
}  

resource "azurerm_resource_group" "bastionRG" {
  name     = "hub-bast-rsg"
  location = "South India"
}

resource "azurerm_resource_group" "AppGatewayRG" {
  name     = "Shared-HUB-RG"
  location = "South India"
}

resource "azurerm_resource_group" "GatewayRG" {
  name     = "Shared-HUB-RG"
  location = "South India"
}

resource "azurerm_public_ip" "bastpubip" {
  name                = "Bastion-PIP"
  location            = azurerm_resource_group.bastionRG.location
  resource_group_name = azurerm_resource_group.bastionRG.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "BastionHost" {
  name                = "AzureBastionHost"
  location            = azurerm_resource_group.bastionRG.location
  resource_group_name = azurerm_resource_group.bastionRG.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.BasSub.id
    public_ip_address_id = azurerm_public_ip.bastpubip.id
  }
}

resource "azurerm_public_ip" "PubIp" {
  name                = "APG-PIP"
  resource_group_name = azurerm_resource_group.AppGatewayRG.name
  location            = azurerm_resource_group.AppGatewayRG.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

#&nbsp;since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${azurerm_virtual_network.example.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.example.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.example.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.example.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.example.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.example.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.example.name}-rdrcfg"
}

resource "azurerm_application_gateway" "AppGw" {
  name                = "App-Gateway"
  resource_group_name = azurerm_resource_group.AppGatewayRG.name
  location            = azurerm_resource_group.AppGatewayRG.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.AppGwSub.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.PubIp.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 10
  }
}

resource "azurerm_resource_group" "HubManagementRG" {
  name     = "hub-mgmt-rsg"
  location = "South India"
}

resource "azurerm_automation_account" "AutomationAcc" {
  name                = "AutomationAccount"
  location            = azurerm_resource_group.HubManagementRG.location
  resource_group_name = azurerm_resource_group.HubManagementRG.name
  sku_name            = "Basic"
  
  tags = {
    environment = "HubEnvironment"
  }
}

resource "azurerm_log_analytics_workspace" "LogAnalyticsWrkspce" {
  name                = "LG-Monitor-HUB"
  location            = azurerm_resource_group.HubManagementRG.location
  resource_group_name = azurerm_resource_group.HubManagementRG.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

data "azurerm_client_config" "currentconfiguration" {}

resource "azurerm_resource_group" "HubIDMRG" {
  name     = "hub-idm-rg"
  location = "South India"
}

resource "azurerm_key_vault" "KitKeyVlt" {
  name                       = "Kryptos-KV"
  location                   = azurerm_resource_group.HubIDMRG.location
  resource_group_name        = azurerm_resource_group.HubIDMRG.name
  tenant_id                  = data.azurerm_client_config.currentconfiguration.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
}

resource "azurerm_recovery_services_vault" "RcvryVlt" {
  name                = "Kryptos-RSV"
  location            = azurerm_resource_group.HubIDMRG.location
  resource_group_name = azurerm_resource_group.HubIDMRG.name
  sku                 = "Standard"

  soft_delete_enabled = true
}

resource "azurerm_public_ip" "VpnPubip" {
    name                = "VGN-PIP"
    location            = azurerm_resource_group.v-netRG.location
    resource_group_name = azurerm_resource_group.v-netRG.name
  
    allocation_method = "Dynamic"
  }
  
  resource "azurerm_virtual_network_gateway" "VrtlNtwkGW" {
    name                = "VPN-Site1"
    location            = azurerm_resource_group.v-netRG.location
    resource_group_name = azurerm_resource_group.v-netRG.name
  
    type     = "Vpn"
    vpn_type = "RouteBased"
  
    active_active = false
    enable_bgp    = false
    sku           = "VpnGw2"
  
    ip_configuration {
      name                          = "VnetGatewayConfig"
      public_ip_address_id          = azurerm_public_ip.VpnPubip.id
      private_ip_address_allocation = "Dynamic"
      subnet_id                     = azurerm_subnet.Gateway.id
    }
  }
  
resource "azurerm_local_network_gateway" "KryptosLNG" {
  name                = "KryptosLngTag"
  location            = azurerm_resource_group.v-netRG.location
  resource_group_name = azurerm_resource_group.v-netRG.name
  gateway_address     = "14.141.19.38"
  address_space       = ["172.16.36.0/24"]
}

resource "azurerm_virtual_network_gateway_connection" "KryptosConnections" {
  name                = "KryptosConnectionsTag"
  location            = azurerm_resource_group.v-netRG.location
  resource_group_name = azurerm_resource_group.v-netRG.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.VrtlNtwkGW.id
  local_network_gateway_id   = azurerm_local_network_gateway.KryptosLNG.id

  shared_key = "K6Ypt0$v6u0n$19)@"
}

resource "azurerm_resource_group" "SpokeV-NetRG" {
  name     = "Prod-RG"
  location = "South India"
}

resource "azurerm_virtual_network" "SpkV-Net" {
  name                = "Prod-Vnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.SpokeV-NetRG.location
  resource_group_name = azurerm_resource_group.SpokeV-NetRG.name
}   

resource "azurerm_subnet" "SpkAppSub" {
  name                 = "App-Spoke-Snet"
  resource_group_name  = azurerm_resource_group.SpokeV-NetRG.name
  virtual_network_name = azurerm_virtual_network.SpkV-Net.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_subnet" "SpkDBSub" {
  name                 = "DB-Spoke-Snet"
  resource_group_name  = azurerm_resource_group.SpokeV-NetRG.name
  virtual_network_name = azurerm_virtual_network.SpkV-Net.name
  address_prefixes     = ["10.1.1.0/24"]
}  

resource "azurerm_subnet" "SpokeSpare" {
  name                 = "Web-Spoke-Snet"
  resource_group_name  = azurerm_resource_group.SpokeV-NetRG.name
  virtual_network_name = azurerm_virtual_network.SpkV-Net.name
  address_prefixes     = ["10.1.2.0/24"]
}

resource "azurerm_resource_group" "SpokeApplicationRG" {
  name     = "APP-SPOKE-RG"
  location = "South India"
}   

resource "azurerm_resource_group" "SpokeDatabaseRG" {
  name     = "DB-Spoke-RG"
  location = "South India"
}  

data "azurerm_client_config" "Spokecurrentconfiguration" {}

resource "azurerm_resource_group" "SharedSvcsRG" {
  name     = "Web-Spoke-RG"
  location = "South India"
} 

resource "azurerm_key_vault" "SpkKeyVlt" {
  name                       = "Spoke-KV"
  location                   = azurerm_resource_group.SharedSvcsRG.location
  resource_group_name        = azurerm_resource_group.SharedSvcsRG.name
  tenant_id                  = data.azurerm_client_config.Spokecurrentconfiguration.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
}

resource "azurerm_network_interface" "NtwrkIntrfce" {
  name                = "NetworkInterface"
  location            = azurerm_resource_group.SharedSvcsRG.location
  resource_group_name = azurerm_resource_group.SharedSvcsRG.name

  ip_configuration {
    name                          = "VmInternalIp"
    subnet_id                     = azurerm_subnet.SpokeSpare.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "SpkMachine" {
  name                = "VM-Spoke-WEB"
  resource_group_name = azurerm_resource_group.SharedSvcsRG.name
  location            = azurerm_resource_group.SharedSvcsRG.location
  size                = "Standard_F2"
  admin_username      = "Windows"
  admin_password      = "Windows@12345"
  network_interface_ids = [
    azurerm_network_interface.NtwrkIntrfce.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_subnet" "AzFirewallSubnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.v-netRG.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.5.0/24"]
}

resource "azurerm_public_ip" "FirePubIp" {
  name                = "Firewall-PIP"
  location            = azurerm_resource_group.AppGatewayRG.location
  resource_group_name = azurerm_resource_group.AppGatewayRG.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "MyHubFirewall" {
  name                = "HubFirewall"
  location            = azurerm_resource_group.v-netRG.location
  resource_group_name = azurerm_resource_group.v-netRG.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  
  ip_configuration {
    name                 = "FirewallConfiguration"
    subnet_id            = azurerm_subnet.AzFirewallSubnet.id
    public_ip_address_id = azurerm_public_ip.FirePubIp.id
  }
}

resource "azurerm_firewall_policy" "MyHubFirewallPolicy" {
  name                = "HubFirewallPolicy"
  resource_group_name = azurerm_resource_group.v-netRG.name
  location            = azurerm_resource_group.v-netRG.location
}

resource "azurerm_firewall_policy_rule_collection_group" "DnatFirewallRule" {
  name               = "DnatRules"
  firewall_policy_id = azurerm_firewall_policy.MyHubFirewallPolicy.id
  priority           = 100
  nat_rule_collection {
    name     = "nat_rule_collection1"
    priority = 100
    action   = "Dnat"
    rule {
      name                = "nat_rule_collection1_rule1"
      protocols           = ["TCP","UDP"]
      source_addresses    = ["10.0.0.1", "10.0.0.2"]
      destination_address = "172.16.36.0"
      destination_ports   = ["389"]
      translated_address  = "192.168.0.1"
      translated_port     = "8080"
    }
     rule {
      name                = "nat_rule_collection1_rule2"
      protocols           = ["TCP"]
      source_addresses    = ["10.0.0.1", "10.0.0.2"]
      destination_address = "172.16.36.0"
      destination_ports   = ["636"]
      translated_address  = "192.168.0.1"
      translated_port     = "8080"
    }
    rule {
      name                = "nat_rule_collection1_rule3"
      protocols           = ["TCP"]
      source_addresses    = ["10.0.0.1", "10.0.0.2"]
      destination_address = "172.16.36.0"
      destination_ports   = ["3268"]
      translated_address  = "192.168.0.1"
      translated_port     = "8080"
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "NetworkFirewallRules" {
  name               = "NetworkRules"
  firewall_policy_id = azurerm_firewall_policy.MyHubFirewallPolicy.id
  priority           = 200
    network_rule_collection {
    name     = "network_rule_collection1"
    priority = 200
    action   = "Deny"
    rule {
      name                  = "network_rule_collection1_rule1"
      protocols             = ["TCP"]
      source_addresses      = ["10.0.0.1"]
      destination_addresses = ["172.16.36.0"]
      destination_ports     = ["3269"]
    }
    rule {
      name                  = "network_rule_collection1_rule2"
      protocols             = ["TCP","UDP"]
      source_addresses      = ["10.0.0.1"]
      destination_addresses = ["172.16.36.0"]
      destination_ports     = ["88"]
    }
    rule {
      name                  = "network_rule_collection1_rule3"
      protocols             = ["TCP","UDP"]
      source_addresses      = ["10.0.0.1"]
      destination_addresses = ["172.16.36.0"]
      destination_ports     = ["53"]
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "ApplicationFirewallRules" {
  name               = "ApplicationRules"
  firewall_policy_id = azurerm_firewall_policy.MyHubFirewallPolicy.id
  priority           = 300  
    application_rule_collection {
    name     = "app_rule_collection1"
    priority = 300
    action   = "Deny"
    rule {
      name = "app_rule_collection1_rule1"
      protocols {
        type = "Http"
        port = 80
      }
      source_addresses  = ["10.0.0.1"]
      destination_fqdns = ["google.com"]
    }
    rule {
      name = "app_rule_collection1_rule2"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["10.0.0.1"]
      destination_fqdns = ["microsoft.com"]
    }
  }
}

resource "azurerm_virtual_network_peering" "hbtospk" {
  name                      = "HubToSpokePeering"
  resource_group_name       = azurerm_resource_group.v-netRG.name
  virtual_network_name      = azurerm_virtual_network.example.name
  remote_virtual_network_id = azurerm_virtual_network.SpkV-Net.id
}

resource "azurerm_virtual_network_peering" "spktohb" {
  name                      = "SpokeToHubPeering"
  resource_group_name       = azurerm_resource_group.SpokeV-NetRG.name
  virtual_network_name      = azurerm_virtual_network.SpkV-Net.name
  remote_virtual_network_id = azurerm_virtual_network.example.id
}

resource "azurerm_route_table" "SpkV-NetRT" {
  name                = "RouteTableSpoke"
  location            = azurerm_resource_group.SpokeV-NetRG.location
  resource_group_name = azurerm_resource_group.SpokeV-NetRG.name

  route {
    name                   = "RouteConfiguration"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.5.4"
  }
}

resource "azurerm_subnet_route_table_association" "SubAssocRT" {
  subnet_id      = azurerm_subnet.SpokeSpare.id
  route_table_id = azurerm_route_table.SpkV-NetRT.id
}

resource "azurerm_management_group" "MgmtGrp" {
  display_name = "CAF Management Group"
}

resource "azurerm_policy_definition" "Interface1" {
  name                = "NetworkInterface"
  policy_type         = "Custom"
  mode                = "All"
  display_name        = "Network interfaces should not have public IPs"
  management_group_id = azurerm_management_group.MgmtGrp.id

  policy_rule = <<POLICY_RULE
    {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Network/networkInterfaces"
          },
          {
            "not": {
              "field": "Microsoft.Network/networkInterfaces/ipconfigurations[*].publicIpAddress.id",
              "notLike": "*"
            }
          }
        ]
      },
      "then": {
        "effect": "deny"
      }
    }
POLICY_RULE
}

resource "azurerm_management_group_policy_assignment" "NetworkAssign" {
  name                 = "NetworkAssignment"
  policy_definition_id = azurerm_policy_definition.Interface1.id
  management_group_id  = azurerm_management_group.MgmtGrp.id
}

resource "azurerm_policy_definition" "LocationDef" {
  name                = "only-deploy-in-southindia"
  policy_type         = "Custom"
  mode                = "All"
  display_name        = "Allowed locations"
  management_group_id = azurerm_management_group.MgmtGrp.id

  policy_rule = <<POLICY_RULE
    {
    "if": {
      "not": {
        "field": "location",
        "equals": "southindia"
      }
    },
    "then": {
      "effect": "Deny"
    }
  }
POLICY_RULE
}

resource "azurerm_management_group_policy_assignment" "LocAssign" {
  name                 = "LocationAssignment"
  policy_definition_id = azurerm_policy_definition.LocationDef.id
  management_group_id  = azurerm_management_group.MgmtGrp.id
}

resource "azurerm_network_security_group" "NtwrkSG" {
  name                = "MyTagNSG"
  location            = azurerm_resource_group.v-netRG.location
  resource_group_name = azurerm_resource_group.v-netRG.name

  security_rule {
    name                       = "NSGRule1"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9389"
    source_address_prefix      = "10.0.0.1"
    destination_address_prefix = "172.16.36.0"
  }

  security_rule {
    name                       = "NSGRule2"
    priority                   = 500
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "123"
    source_address_prefix      = "10.0.0.1"
    destination_address_prefix = "172.16.36.0"
  }

  security_rule {
    name                       = "NSGRule3"
    priority                   = 600
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "0-65535"
    source_address_prefix      = "10.0.0.1"
    destination_address_prefix = "172.16.36.0"
  }

  tags = {
    environment = "NSGEnvironmentTag"
  }
}
