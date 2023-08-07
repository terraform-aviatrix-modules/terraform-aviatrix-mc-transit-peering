# AS-PATH prepending use case

## SCENARIO 1 - AS-PATH prepending for transit gateways' peerings 
<img src="https://github.com/conip/terraform-aviatrix-mc-transit-peering/blob/ba8cedb3a922b67f9093e500db9b5859629068a3/examples/example1%20-%20as-path-prepending/img/as-path-prepending-use-case1.jpeg" title="AS PATH PREPENDING">

By default all transit peerings should have prepending enabled with value of 3. Specific regional transit peerings shouldn't have any prepending (0). Two regions should act as fallback to each other so prepending of 2 is applied. 

### Example Code to achieve the above:

```hcl
module "mc-transit-peering" {
  source  = "terraform-aviatrix-modules/mc-transit-peering/aviatrix"
  version = "1.0.9"

  prepending = [
    {
      "GW1" : 0,
      "GW2" : 0
    },
    {
      "GW3" : 0,
      "GW4" : 0
    },
    {
      "GW5" : 0,
      "GW6" : 0
    },   
    {
      "GW1" : 2,
      "GW4" : 2
    },
    {
      "GW1" : 2,
      "GW3" : 2
    },
    {
      "GW2" : 2,
      "GW3" : 2
    },
    {
      "GW2" : 2,
      "GW4" : 2
    },
  ]

  full_mesh_prepending = 3

  transit_gateways_with_local_as = {
    "GW1" : 65051,
    "GW2" : 65052,
    "GW3" : 65053,
    "GW4" : 65054,
    "GW5" : 65055,
    "GW6" : 65056
  }
}
```