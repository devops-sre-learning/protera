# output "load_balancer_ip_or_dns" {
#   value       = try(module.lb.lb_ip, "")
#   description = "LB IP/DNS (empty if LB disabled)"
# }
output "vpc_id" {
  value = module.network.vpc_name
}
output "app_instance_group" {
  value = module.compute.instance_group
}
output "db_private_ip" {
  value = module.db.db_private_ip
}
output "logs_bucket" {
  value = module.storage.bucket_name
}
