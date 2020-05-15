########
# Label
########
variable "environment" {
  description = "The environment"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "The namespace to deploy into"
  type        = string
  default     = ""
}

variable "stage" {
  description = "The stage of the deployment"
  type        = string
  default     = ""
}

variable "network_name" {
  description = "The network name, ie kusama / mainnet"
  type        = string
  default     = "kusama"
}

variable "owner" {
  description = "Owner of the infrastructure"
  type        = string
  default     = ""
}

variable "region" {
  description = "The GCP region to deploy in"
  type        = string
  default     = "us-east1"
}

variable "zone" {
  description = "The GCP zone to deploy in"
  type        = string
  default     = "us-east1-b"
}

#########
# Network
#########
variable "vpc_id" {
  description = "The ID of the public VPC"
  type        = string
}

variable "public_subnet_id" {
  description = "The ID of the public subnet to join"
  type        = string
}

variable "private_subnet_id" {
  description = "The ID of the private subnet to join"
  type        = string
}

variable "security_group_id" {
  description = "The id of the security group to run in"
  type        = string
}

#####
# Load Balancer
#####

variable "lb_name" {
  description = "Name of the load balancer"
  type        = string
  default     = "lb"
}

variable "use_lb" {
  description = "Boolean to enable the use of a load balancer"
  type        = bool
  default     = false
}

variable "use_external_lb" {
  description = "Boolean to enable use of external load balancer"
  type        = bool
  default     = false
}


#####
# instance
#####
variable "node_name" {
  description = "Name of the node"
  type        = string
}

variable "monitoring" {
  description = "Boolean for cloudwatch"
  type        = bool
  default     = false
}

variable "create_eip" {
  description = "Boolean to create elastic IP"
  type        = bool
  default     = false
}

variable "root_volume_size" {
  description = "Root volume size"
  type        = string
  default     = 0
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "n1-standard-1"
}

variable "public_key" {
  description = "The public ssh key"
  type        = string
}

variable "num_instances" {
  description = "Number of instances for ASG"
  type        = number
  default     = 1
}

variable "autoscale_enabled" {
  description = "Do you want to use autoscaling?"
  type        = bool
  default     = false
}

variable "min_instances" {
  description = "If autoscaling enabled; the minimum number of instances"
  type        = number
  default     = 1
}

variable "max_instances" {
  description = "If autoscaling enabled; the maxiumum number of instances"
  type        = number
  default     = 1
}

#####
# packer
#####

variable "polkadot_client_url" {
  description = "URL to Polkadot client binary"
  type        = string
  default     = "https://github.com/w3f/polkadot/releases/download/v0.7.32/polkadot"
}

variable "polkadot_client_hash" {
  description = "SHA256 hash of Polkadot client binary"
  type        = string
  default     = "c34d63e5d80994b2123a3a0b7c5a81ce8dc0f257ee72064bf06654c2b93e31c9"
}

variable "node_exporter_url" {
  description = "URL to Node Exporter binary"
  type        = string
  default     = "https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz"
}

variable "node_exporter_hash" {
  description = "SHA256 hash of Node Exporter binary"
  type        = string
  default     = "b2503fd932f85f4e5baf161268854bf5d22001869b84f00fd2d1f57b51b72424"
}

variable "node_exporter_user" {
  description = "User for node exporter"
  type        = string
  default     = "node_exporter_user"
}

variable "node_exporter_password" {
  description = "Password for node exporter"
  type        = string
  default     = "node_exporter_password"
}

variable "project" {
  description = "Name of the project for node name"
  type        = string
  default     = "project"
}

variable "ssh_user" {
  description = "Username for SSH"
  type        = string
  default     = "ubuntu"
}

variable "telemetry_url" {
  description = "WSS URL for telemetry"
  type        = string
  default     = "wss://mi.private.telemetry.backend/"
}

variable "logging_filter" {
  description = "String for polkadot logging filter"
  type        = string
  default     = "sync=trace,afg=trace,babe=debug"
}

variable "relay_node_ip" {
  description = "Internal IP of Polkadot relay node"
  type        = string
  default     = ""
}

variable "relay_node_p2p_address" {
  description = "P2P address of Polkadot relay node"
  type        = string
  default     = ""
}

variable "consul_enabled" {
  description = "Bool to use when Consul is enabled"
  type        = bool
  default     = false
}

variable "prometheus_enabled" {
  description = "Bool to use when Prometheus is enabled"
  type        = bool
  default     = false
}

variable "cluster_name" {
  description = "The name of the k8s cluster"
  type        = string
  default     = ""
}