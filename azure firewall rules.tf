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





