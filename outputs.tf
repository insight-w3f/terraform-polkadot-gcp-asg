output "cmd" {
  value = module.packer.packer_command
}

output "instance_group_id" {
  value = module.asg.instance_group
}

output "target_pool_id" {
  value = join(",", google_compute_target_pool.this.*.self_link)
}

output "lb_endpoint" {
  value = var.use_external_lb ? join(",", google_compute_forwarding_rule.external.*.service_name) : join(",", google_compute_forwarding_rule.internal.*.service_name)
}