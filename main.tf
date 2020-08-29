locals {
  peerings = flatten([
    for gw in var.transit_gateways : [
      #list_selection = slice(var.transit_gateways, index(var.transit_gateways, gw) + 1, length(var.transit_gateways) + 1) #Should result in list of remaining gateways
      for peer_gw in slice(var.transit_gateways, index(var.transit_gateways, gw) + 1, length(var.transit_gateways)) : {
        gw1 = gw
        gw2 = peer_gw
      }
    ]
  ])
}

resource "aviatrix_transit_gateway_peering" "test_transit_gateway_peering" {
  for_each = local.peerings
  transit_gateway_name1             = each.value.gw1
  transit_gateway_name2             = each.value.gw2
}