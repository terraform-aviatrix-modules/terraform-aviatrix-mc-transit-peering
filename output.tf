output "peerings" {
  value       = nonsensitive(local.peerings_map)
  description = "Map of all created peerings"
}
