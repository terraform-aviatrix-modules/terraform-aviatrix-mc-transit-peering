locals {
  #Compiled map
  transit_map = { for gw in var.transit_gateways : gw => {
    asn = try(var.transit_gateways_with_local_as[gw], null)
  } }

  peerings = flatten([
    for gw1 in var.transit_gateways : [
      #The slice below creates a new list with the remaining gateways excluding itself. E.g. based on input var.transit_gateways = ["gw1","gw2","gw3","gw4","gw5","gw6","gw7","gw8","gw9","gw10"] and we arrive at gw = "gw6" in the for loop for example, the sliced list will result in: ["gw7","gw8","gw9","gw10"]
      for gw2 in slice(var.transit_gateways, index(var.transit_gateways, gw1) + 1, length(var.transit_gateways)) : {
        gw1 = gw1
        gw2 = gw2
        prepend_as_path1 = try(
          [for i in range([for j in var.prepending : j if contains(keys(j), gw1) && contains(keys(j), gw2)][0][gw1]) : var.transit_gateways_with_local_as[gw1]], #Generates AS Path with gw1 AS Number based on length in var.prepending
          [for i in range(var.full_mesh_prepending) : var.transit_gateways_with_local_as[gw1]],                                                                  #Generates AS Path with gw1 AS Number based on length in var.full_mesh_prepending
          null                                                                                                                                                   #Default value
        )
        prepend_as_path2 = try(
          [for i in range([for j in var.prepending : j if contains(keys(j), gw1) && contains(keys(j), gw2)][0][gw2]) : var.transit_gateways_with_local_as[gw2]], #Generates AS Path with gw2 AS Number based on length in var.prepending
          [for i in range(var.full_mesh_prepending) : var.transit_gateways_with_local_as[gw2]],                                                                  #Generates AS Path with gw1 AS Number based on length in var.full_mesh_prepending
          null                                                                                                                                                   #Default value
        )
      }
    ]
  ])

  #Create map for consumption in for_each.
  peerings_map = {
    for peering in local.peerings : "${peering.gw1}:${peering.gw2}" => peering if !contains(var.prune_list, tomap({ (peering.gw1) : (peering.gw2) })) && !contains(var.prune_list, tomap({ (peering.gw2) : (peering.gw1) }))
  }
}

resource "aviatrix_transit_gateway_peering" "peering" {
  for_each                                    = var.create_peerings ? local.peerings_map : null
  transit_gateway_name1                       = each.value.gw1
  transit_gateway_name2                       = each.value.gw2
  enable_peering_over_private_network         = var.enable_peering_over_private_network
  gateway1_excluded_network_cidrs             = var.excluded_cidrs
  gateway2_excluded_network_cidrs             = var.excluded_cidrs
  enable_single_tunnel_mode                   = var.enable_single_tunnel_mode
  enable_insane_mode_encryption_over_internet = var.enable_insane_mode_encryption_over_internet
  tunnel_count                                = var.tunnel_count
  enable_max_performance                      = var.enable_max_performance
  prepend_as_path1                            = each.value.prepend_as_path1
  prepend_as_path2                            = each.value.prepend_as_path2
  lifecycle {
    ignore_changes = [
      gateway1_excluded_tgw_connections,
      gateway2_excluded_tgw_connections,
    ]
  }
}
