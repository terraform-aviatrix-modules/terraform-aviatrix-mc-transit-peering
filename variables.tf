variable "transit_gateways" {
  type        = list(string)
  description = "List of transit gateway names to create full mesh peering from"
  default     = null
  nullable    = true
}

variable "transit_gateways_with_local_as" {
  type        = map(number)
  description = "Map of transit gateways with local_as_numbers."
  default     = null
  nullable    = true
}

variable "enable_peering_over_private_network" {
  type        = bool
  description = "Enable to use a private circuit for setting up peering"
  default     = false
  nullable    = false
}

variable "excluded_cidrs" {
  type        = list(string)
  description = "A list of CIDR's to exclude on the peers"
  default     = []
  nullable    = false
}

variable "enable_single_tunnel_mode" {
  type        = bool
  description = "Enable single tunnel mode."
  default     = false
  nullable    = false
}

variable "enable_insane_mode_encryption_over_internet" {
  type        = bool
  description = "Enable insane mode over internet"
  default     = null
}

variable "tunnel_count" {
  type        = number
  description = "Amount of tunnels to build for insane mode over internet"
  default     = null
}

variable "create_peerings" {
  type        = bool
  description = "Toggle for setting peering resource creation on or off. When set to false, it only generates the peerings output."
  default     = true
  nullable    = false
}

variable "prune_list" {
  type     = list(map(string))
  default  = []
  nullable = false
}

variable "enable_max_performance" {
  description = "Indicates whether the maximum amount of HPE tunnels will be created. Only valid when the two transit gateways are each launched in Insane Mode and in the same cloud type."
  type        = bool
  default     = null
}

variable "prepending" {
  default = null
  # type = map(map(list(string)))
  type = list(map(number))
}

variable "full_mesh_prepending" {
  default = null
  type    = number
}

