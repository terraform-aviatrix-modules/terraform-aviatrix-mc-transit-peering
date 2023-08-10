# terraform-aviatrix-mc-transit-deployment-framework - release notes

## v1.0.9
Adds functionality of AS-PATH prepending on transit peerings. 
The following attributes "prepend_as_path1" and "prepend_as_path2" are no longer under ignore_changes block which means that whatever is configured will be replaced by explicit configuration of of the module itself. 

```
  prepending = [
    {
      "${module.mc_transit_az_1.transit_gateway.gw_name}" : 0,
      "${module.mc_transit_az_2.transit_gateway.gw_name}" : 0
    },
    {
      "${module.mc_transit_az_5.transit_gateway.gw_name}" : 2,
      "${module.mc_transit_az_3.transit_gateway.gw_name}" : 2
    },
    {
      "${module.mc_transit_az_4.transit_gateway.gw_name}" : 3,
      "${module.mc_transit_az_2.transit_gateway.gw_name}" : 2
    }
  ]

  full_mesh_prepending = 3
```
The order of prependig is the following:
1. Explicit prepending for each one of the pair in prepending list.
2. Full mesh if attribute "full_mesh_prepending" set to number
3. no prepending if 1. and 2. not set

## v1.0.8
Removes specific handling of sensitive required for outputs of older mc-transit module, to restore compatibility.

## v1.0.7

### Add support for configuring enable_max_performance

## v1.0.6

### Add support for pruning, allowing a partial mesh. Specify gw_name pairs for which peerings should not be created:
```
  prune_list = [
    {"gw5" : "gw1"},
    {"gw3" : "gw4"},
  ]
```