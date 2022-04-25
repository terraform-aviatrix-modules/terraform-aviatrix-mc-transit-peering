# terraform-aviatrix-mc-transit-deployment-framework - release notes

## v1.0.6

### Add support for pruning, allowing a partial mesh. Specify gw_name pairs for which peerings should not be created:
```
  prune_list = [
    {"gw5" : "gw1"},
    {"gw3" : "gw4"},
  ]
```