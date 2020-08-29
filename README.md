# terraform-aviatrix-mc-transit-peering

### Description
\<Provide a description of the module>

### Diagram
\<Provide a diagram of the high level constructs thet will be created by this module>
<img src="<IMG URL>"  height="250">

### Compatibility
Module version | Terraform version | Controller version | Terraform provider version
:--- | :--- | :--- | :---
v1.0.0 | | |

### Usage Example
```
module "transit-peering" {
  source  = "terraform-aviatrix-modules/mc-transit-peering/aviatrix"
  version = "1.0.0"

  gateway_names = ["gw1","gw2","gw3","gw4","gw5"]
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
\- | -

### Outputs
This module will return the following outputs:

key | description
:---|:---
\- | -
