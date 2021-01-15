# terraform-aviatrix-mc-transit-peering

### Description
This module will create a full mesh transit for all gateway names provided in the transit_gateways list input variable. Excluded network cidrs is not supported.

### Diagram
\<Provide a diagram of the high level constructs that will be created by this module>
<img src="<IMG URL>"  height="250">

### Compatibility
Module version | Terraform version | Controller version | Terraform provider version
:--- | :--- | :--- | :---
v1.0.2 | v0.13 | >=v6.2 | >=v2.17.1
v1.0.1 | v0.13 | |
v1.0.0 | v0.12 | |

### Usage Example
```
module "transit-peering" {
  source  = "terraform-aviatrix-modules/mc-transit-peering/aviatrix"
  version = "1.0.1"

  transit_gateways = [
    "gw1",
    "gw2",
    "gw3",
    "gw4",
    "gw5"
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

### Outputs
This module will return the following outputs:

key | description
:---|:---
\- | -
