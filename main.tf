locals {
  peerings = [
    for gw in var.transit_gateways : [
      #list_selection = slice(var.transit_gateways, index(var.transit_gateways, gw) + 1, length(var.transit_gateways) + 1) #Should result in list of remaining gateways
      for item in slice(var.transit_gateways, index(var.transit_gateways, gw) + 1, length(var.transit_gateways) + 1) : {
        gw1 = gw
        gw2 = item
      }
    ]
  ]
}

/*
resource "aviatrix_transit_gateway_peering" "test_transit_gateway_peering" {
  for_each 
  transit_gateway_name1             = "transit-Gw1"
  transit_gateway_name2             = "transit-Gw2"
}
*/