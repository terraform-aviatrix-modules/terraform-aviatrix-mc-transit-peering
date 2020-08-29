variable "transit_gateways" {
  type        = list(string)
  description = "List of transit gateway names to create full mesh peering from"
}