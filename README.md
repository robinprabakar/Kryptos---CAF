LIST OF COMPONENTS CREATED THROUGH THE TERRAFORM MODULE - CAF

SKELETON: 1.V-Nets (For Hub & Spoke) 2.Subnets (For Hub & Spoke)

SERVICES: 1.Bastion Host 2.Application Gateway 3.Automation Account 4.Log Analytics Workspace 5.KeyVault (For Hub & Spoke) 6.Recovery Services Vault 7.VPN Gateway 8.Local Network Gateway 9.Virtual Machine (To Verify Connection between On-Prem To Azure though VPN Gateway) 10.Azure Firewall 11.Peering (To Establish Connection between Hub and Spoke Vnets) 12.Route Tables and its association (To Subnets)

POLICIES & RULES: 1.Azure Firewall Rules (Dnat, Network and Application Rules) 2.Azure Policies (Assigning to Management Groups) 3.Network Security Group rules
