variable "transit_gateways" {
  type        = list(string)
  description = "List of transit gateway names to create full mesh peering from"
}

variable "enable_peering_over_private_network" {
  type        = bool
  description = "Enable to use a private circuit for setting up peering"
  default     = false
}

variable "excluded_cidrs" {
  type        = list(string)
  description = "A list of CIDR's to exclude on the peers"
  default     = []
}