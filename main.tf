locals {
  # sorting initial GW list as key created in peerings_map is i.e. GW1:GW2 and naming order matters for prepending list of map (which is sorted when passed into module by default)
  transit_gateways_sorted = sort(var.transit_gateways)
  # Create all peerings based on list of all gateways  
  peerings = flatten([
    for gw in local.transit_gateways_sorted : [
      #The slice below creates a new list with the remaining gateways excluding itself. E.g. based on input var.transit_gateways = ["gw1","gw2","gw3","gw4","gw5","gw6","gw7","gw8","gw9","gw10"] and we arrive at gw = "gw6" in the for loop for example, the sliced list will result in: ["gw7","gw8","gw9","gw10"]
      for peer_gw in slice(local.transit_gateways_sorted, index(local.transit_gateways_sorted, gw) + 1, length(var.transit_gateways)) : {
        gw1 = gw
        gw2 = peer_gw
      }
    ]
  ])

  #Create map for consumption in for_each.
  peerings_map = {
    for peering in local.peerings : "${peering.gw1}:${peering.gw2}" => peering if !contains(var.prune_list, tomap({ (peering.gw1) : (peering.gw2) })) && !contains(var.prune_list, tomap({ (peering.gw2) : (peering.gw1) }))
  }

  # creates a map of all GWs and theri local_as_number
  transit_gw_as_map = {
    for key, value in data.aviatrix_transit_gateway.gw_info_list : data.aviatrix_transit_gateway.gw_info_list[key].gw_name => {
      local_as_number = value["local_as_number"]
    }
  }

  prepending = var.prepending

  # creates the list of the same structure as the peerings_map as its easier to merge them for values searching for key
  modification_1 = try({
    for i in range(length(local.prepending)) : "${keys(local.prepending[i])[0]}:${keys(local.prepending[i])[1]}" => {
      gw1 = values(local.prepending[i])[0]
      gw2 = values(local.prepending[i])[1]
    }
  },null)

  peerings2 = {
    for key1, value1 in local.peerings_map : key1 => {
      gw1 = value1["gw1"],
      gw2 = value1["gw2"],

      # prepending in the following order:
      # 1) if explicit prepending for specific pair of Transit GW
      # 2) if full_mesh_prepending is set to some number
      # 3) none as fallback 
      prepend_as_path1 = try([for i in range(local.modification_1[key1]["gw1"]) : local.transit_gw_as_map[value1["gw1"]].local_as_number], try([for i in range(var.full_mesh_prepending) : local.transit_gw_as_map[value1["gw1"]].local_as_number], null)),
      prepend_as_path2 = try([for i in range(local.modification_1[key1]["gw2"]) : local.transit_gw_as_map[value1["gw2"]].local_as_number], try([for i in range(var.full_mesh_prepending) : local.transit_gw_as_map[value1["gw2"]].local_as_number], null))
    }
  }

  # Pass the peerings_map or an empty map to the resource, based on var.create_peerings.
  peerings_resources = var.create_peerings ? local.peerings2 : null
}

# creating the list of all Transit GW and their respective attributes as we need to find out the "local_as_number"
data "aviatrix_transit_gateway" "gw_info_list" {
  count   = length(var.transit_gateways)
  gw_name = var.transit_gateways[count.index]
}

resource "aviatrix_transit_gateway_peering" "peering" {
  for_each                                    = try(nonsensitive(local.peerings_resources), local.peerings_resources)
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
