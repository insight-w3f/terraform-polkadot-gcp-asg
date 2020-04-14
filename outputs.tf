output "cmd" {
  value = module.packer.packer_command
}

output "instance_group_id" {
  value = module.asg.instance_group
}