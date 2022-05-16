# terraform-aviatrix-mc-transit-peering

### Description
This module will create a full mesh transit for all gateway names provided in the transit_gateways list input variable.

### Compatibility
Module version | Terraform version | Controller version | Terraform provider version
:--- | :--- | :--- | :---
v1.0.6 | v0.13 + v1.x | >=v6.4 | >=v2.19.0

Check [release notes](https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit-peering/blob/master/RELEASE_NOTES.md) for more details.
Check [compatibility list](https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit-peering/blob/master/COMPATIBILITY.md) for older versions.

### Usage Example
```
module "transit-peering" {
  source  = "terraform-aviatrix-modules/mc-transit-peering/aviatrix"
  version = "1.0.6"

  transit_gateways = [
    "gw1",
    "gw2",
    "gw3",
    "gw4",
    "gw5"
  ]

  excluded_cidrs = [
    "0.0.0.0/0",
  ]
}
```

### Variables
The following variables are required:

key | value
:--- | :---
transit_gateways | List of transit gateway names to create full mesh peering from

The following variables are optional:

key | default | value 
:---|:---|:---
enable_peering_over_private_network | false | Enable to use a private circuit for setting up peering
excluded_cidrs | [] | list of excluded cidrs. This will be applied to all peerings on both sides. If you need more granularity, it is suggested to use the aviatrix_transit_gateway_peering resource directly in stead of this module.
enable_single_tunnel_mode | false | Enable single tunnel mode. Will be applied to all peerings. If you need more granularity, it is suggested to use the aviatrix_transit_gateway_peering resource directly in stead of this module.
enable_insane_mode_encryption_over_internet | false | Enable insane mode over internet. Will be applied to all peerings. If you need more granularity, it is suggested to use the aviatrix_transit_gateway_peering resource directly in stead of this module.
tunnel_count | | Amount of tunnels to build for insane mode over internet. Will be applied to all peerings. If you need more granularity, it is suggested to use the aviatrix_transit_gateway_peering resource directly in stead of this module.
create_peerings | true | Toggle for setting peering resource creation on or off. When set to false, it only generates the peerings output so you can use it outside of this module.
prune_list | [] | A list of maps for peerings that should not be created. Expects gateway name. Example: [ {"gw5" : "gw1"}, {"gw3" : "gw4"}, ]

### Outputs
This module will return the following outputs:

key | description
:---|:---
peerings | A map of all unique peerings between the provided list of gateways.
