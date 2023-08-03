# terraform-aviatrix-mc-transit-peering

### Description
This module will create a full mesh transit for all gateway names provided in the transit_gateways list input variable.

### Compatibility
Module version | Terraform version | Controller version | Terraform provider version
:--- | :--- | :--- | :---
v1.0.9 | v1.x | >=v6.8 | >=v2.23.0

Check [release notes](https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit-peering/blob/master/RELEASE_NOTES.md) for more details.
Check [compatibility list](https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit-peering/blob/master/COMPATIBILITY.md) for older versions.

### Usage Example

```hcl
module "transit-peering" {
  source  = "terraform-aviatrix-modules/mc-transit-peering/aviatrix"
  version = "1.0.8"

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

```hcl
module "mc-transit-peering" {
  source  = "terraform-aviatrix-modules/mc-transit-peering/aviatrix"
  version = "1.0.9"

  prepending = [
    {
      "GW1" : 1,
      "GW3" : 1
    },
    {
      "GW2" : 4,
      "GW3" : 2
    },
    {
      "GW2" : 2,
      "GW4" : 2
    },
  ]

  transit_gateways_with_local_as = {
    "GW1" : 65051,
    "GW2" : 65052,
    "GW3" : 65053,
    "GW4" : 65054
  }
}

```


### Variables
The following variables are required:

key | value
:--- | :---
transit_gateways | List of transit gateway names to create full mesh peering from. NOT REQURED if "transit_gateways_with_local_as" provided. 
transit_gateways_with_local_as | Map of transit gateway names and their corresponding AS numbers. REQUIRED only when using prepending.

The following variables are optional:

key | default | value 
:---|:---|:---
create_peerings | true | Toggle for setting peering resource creation on or off. When set to false, it only generates the peerings output so you can use it outside of this module.
enable_insane_mode_encryption_over_internet | false | Enable insane mode over internet. Will be applied to all peerings. If you need more granularity, it is suggested to use the aviatrix_transit_gateway_peering resource directly in stead of this module.
enable_max_performance | null | Indicates whether the maximum amount of HPE tunnels will be created. Only valid when all transit gateways are each launched in Insane Mode and in the same cloud type.
enable_peering_over_private_network | false | Enable to use a private circuit for setting up peering
enable_single_tunnel_mode | false | Enable single tunnel mode. Will be applied to all peerings. If you need more granularity, it is suggested to use the aviatrix_transit_gateway_peering resource directly in stead of this module.
excluded_cidrs | [] | list of excluded cidrs. This will be applied to all peerings on both sides. If you need more granularity, it is suggested to use the aviatrix_transit_gateway_peering resource directly in stead of this module.
prune_list | [] | A list of maps for peerings that should not be created. Expects gateway name. Example: [ {"gw5" : "gw1"}, {"gw3" : "gw4"}, ]
tunnel_count | | Amount of tunnels to build for insane mode over internet. Will be applied to all peerings. If you need more granularity, it is suggested to use the aviatrix_transit_gateway_peering resource directly in stead of this module.
full_mesh_prepending | null | Accepted values: numbers. If provided AS-PATH prepend will be added number of times unless specific prepending is provided in "prepending" attribute which takes precedence. 
prepending | null | List of Transit Gateways pairs with their prepending numbers. Example [{"gw1":1, "gw2":3}, {"gw5":1,"gw4":1}]. Prepending is unidirectional that means gw1 would prepend just once towards gw2 but gw2 would prepend x3 towards gw1. 

### Outputs
This module will return the following outputs:

key | description
:---|:---
peerings | A map of all unique peerings between the provided list of gateways.
