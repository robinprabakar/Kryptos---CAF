resource "azurerm_policy_definition" "Interface1" {
  name                = var.Policy_def_network_int_name
  policy_type         = var.Network_int_policy_type
  mode                = var.Network_int_mode
  display_name        = var.Network_int_display_name
  management_group_id = var.Management_group_name

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
  name                 = var.NetworkAssign_name
  policy_definition_id = var.NetworkAssign_policy_definition_id
  management_group_id  = var.Management_group_name
}

resource "azurerm_policy_definition" "LocationDef" {
  name                = var.Policy_def_LocationDef_name
  policy_type         = var.LocationDef_policy_type
  mode                = var.LocationDef_mode
  display_name        = var.LocationDef_display_name
  management_group_id = var.Management_group_name

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
  name                 = var.LocAssign_name
  policy_definition_id = var.LocationAssign_policy_definition_id
  management_group_id  = var.Management_group_name
}
