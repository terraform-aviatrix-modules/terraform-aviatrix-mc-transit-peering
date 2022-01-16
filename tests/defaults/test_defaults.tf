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
}

resource "test_assertions" "peerings_map" {
  component = "peerings_map"

  equal "maps" {
    description = "Module output is equal to check map."
    got         = module.main.peerings
    want        = local.expected_map
  }
}