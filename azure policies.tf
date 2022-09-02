provider "azurerm" {
  features {}
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
