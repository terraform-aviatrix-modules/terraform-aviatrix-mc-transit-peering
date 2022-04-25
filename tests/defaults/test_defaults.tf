terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }
    aviatrix = {
      source = "aviatrixsystems/aviatrix"
    }
  }
}

module "main" {
  source = "../.."

  transit_gateways = [
    "gw1",
    "gw2",
    "gw3",
    "gw4",
    "gw5",
  ]

  create_peerings = false
}

module "pruned" {
  source = "../.."

  transit_gateways = [
    "gw1",
    "gw2",
    "gw3",
    "gw4",
    "gw5",
  ]

  #Prune 1-5 + 3-4
  prune_list = [
    { "gw5" : "gw1" }, #Reverse order
    { "gw3" : "gw4" }, #Ascending order
  ]

  create_peerings = false
}

locals {
  expected_map = {
    "gw1:gw2" = {
      "gw1" = "gw1"
      "gw2" = "gw2"
    }
    "gw1:gw3" = {
      "gw1" = "gw1"
      "gw2" = "gw3"
    }
    "gw1:gw4" = {
      "gw1" = "gw1"
      "gw2" = "gw4"
    }
    "gw1:gw5" = {
      "gw1" = "gw1"
      "gw2" = "gw5"
    }
    "gw2:gw3" = {
      "gw1" = "gw2"
      "gw2" = "gw3"
    }
    "gw2:gw4" = {
      "gw1" = "gw2"
      "gw2" = "gw4"
    }
    "gw2:gw5" = {
      "gw1" = "gw2"
      "gw2" = "gw5"
    }
    "gw3:gw4" = {
      "gw1" = "gw3"
      "gw2" = "gw4"
    }
    "gw3:gw5" = {
      "gw1" = "gw3"
      "gw2" = "gw5"
    }
    "gw4:gw5" = {
      "gw1" = "gw4"
      "gw2" = "gw5"
    }
  }

  pruned_map = {
    "gw1:gw2" = {
      "gw1" = "gw1"
      "gw2" = "gw2"
    }
    "gw1:gw3" = {
      "gw1" = "gw1"
      "gw2" = "gw3"
    }
    "gw1:gw4" = {
      "gw1" = "gw1"
      "gw2" = "gw4"
    }
    # "gw1:gw5" = {
    #   "gw1" = "gw1"
    #   "gw2" = "gw5"
    # }
    "gw2:gw3" = {
      "gw1" = "gw2"
      "gw2" = "gw3"
    }
    "gw2:gw4" = {
      "gw1" = "gw2"
      "gw2" = "gw4"
    }
    "gw2:gw5" = {
      "gw1" = "gw2"
      "gw2" = "gw5"
    }
    # "gw3:gw4" = {
    #   "gw1" = "gw3"
    #   "gw2" = "gw4"
    # }
    "gw3:gw5" = {
      "gw1" = "gw3"
      "gw2" = "gw5"
    }
    "gw4:gw5" = {
      "gw1" = "gw4"
      "gw2" = "gw5"
    }
  }
}

resource "test_assertions" "peerings_map" {
  component = "peerings_map"

  equal "maps" {
    description = "Module output is equal to check map."
    got         = module.main.peerings
    want        = local.expected_map
  }
}

resource "test_assertions" "peerings_map_pruned" {
  component = "peerings_map_pruned"

  equal "maps_pruned" {
    description = "Module output is equal to check map."
    got         = module.pruned.peerings
    want        = local.pruned_map
  }
}
