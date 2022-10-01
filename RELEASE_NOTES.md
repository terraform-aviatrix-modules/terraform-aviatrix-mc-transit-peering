# terraform-aviatrix-mc-transit-deployment-framework - release notes

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