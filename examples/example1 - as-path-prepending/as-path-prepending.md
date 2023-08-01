# AS-PATH prepending use case

## SCENARIO 1 - AS-PATH prepending for transit gateways' peerings 
<img src="https://github.com/conip/terraform-aviatrix-mc-transit-peering/blob/ba8cedb3a922b67f9093e500db9b5859629068a3/examples/example1%20-%20as-path-prepending/img/as-path-prepending-use-case1.jpeg" title="AS PATH PREPENDING">

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

  transit_gateways = [
    "GW1",
    "GW2",
    "GW3",
    "GW4",
    "GW5",
    "GW6"
  ]
}
```