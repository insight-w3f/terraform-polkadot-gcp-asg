module "label" {
  source = "github.com/robc-io/terraform-null-label.git?ref=0.16.1"
  tags = {
    NetworkName = var.network_name
    Owner       = var.owner
    Terraform   = true
    VpcType     = "main"
  }

  environment = var.environment
  namespace   = var.namespace
  stage       = var.stage
}

resource "null_resource" "requirements" {
  triggers = {
    time = timestamp()
  }

  provisioner "local-exec" {
    command = "ansible-galaxy install -r ${path.module}/ansible/requirements.yml"
  }
}

module "packer" {
  source = "github.com/insight-infrastructure/terraform-packer-build.git"

  packer_config_path = "${path.module}/packer.json"
  timestamp_ui       = true
  vars = {
    module_path : path.module,
    vpc : var.vpc_id,
    subnet : var.public_subnet_id,
    node_exporter_user : var.node_exporter_user,
    node_exporter_password : var.node_exporter_password,
    network_name : var.network_name,
    security_group_id : var.security_group_id,
    ssh_user : var.ssh_user,
    project : var.project,
    region : var.region,
    consul_datacenter : var.region,
    zone : var.zone,
    polkadot_binary_url : var.polkadot_client_url,
    polkadot_binary_checksum : "sha256:${var.polkadot_client_hash}",
    node_exporter_binary_url : var.node_exporter_url,
    node_exporter_binary_checksum : "sha256:${var.node_exporter_hash}",
    polkadot_restart_enabled : true,
    polkadot_restart_minute : "50",
    polkadot_restart_hour : "10",
    polkadot_restart_day : "1",
    polkadot_restart_month : "*",
    polkadot_restart_weekday : "*",
    telemetry_url : var.telemetry_url,
    logging_filter : var.logging_filter,
    relay_ip_address : var.relay_node_ip,
    relay_p2p_address : var.relay_node_p2p_address,
    consul_enabled : var.consul_enabled,
    prometheus_enabled : var.prometheus_enabled,
    retry_join : "\"provider=gce tag_value=gke-${var.cluster_name}\""

  }
}

locals {
  public_key = var.public_key != "" ? var.public_key : file(var.public_key_path)
}

module "user_data" {
  source              = "github.com/insight-w3f/terraform-polkadot-user-data.git?ref=master"
  cloud_provider      = "gcp"
  type                = "library"
  consul_enabled      = var.consul_enabled
  prometheus_enabled  = var.prometheus_enabled
  prometheus_user     = var.node_exporter_user
  prometheus_password = var.node_exporter_password
}

resource "google_compute_instance_template" "this" {
  # tags = module.label.tags
  labels = {
    environment = module.label.environment,
    namespace   = module.label.namespace,
    stage       = module.label.stage
  }

  machine_type = var.instance_type
  name_prefix  = var.node_name != "" ? "${var.node_name}-" : "sentry-"

  service_account {
    email  = var.security_group_id
    scopes = ["cloud-platform"]
  }

  network_interface {
    subnetwork = var.public_subnet_id
    access_config {

    }
  }

  network_interface {
    subnetwork = var.private_subnet_id
  }

  metadata = {
    ssh-keys = "ubuntu:${local.public_key}"
  }

  metadata_startup_script = module.user_data.user_data

  disk {
    boot         = true
    auto_delete  = true
    disk_size_gb = var.root_volume_size
    disk_type    = "pd-standard"
    source_image = data.google_compute_image.packer.self_link
    type         = "PERSISTENT"
  }

  disk {
    boot         = false
    disk_size_gb = "375"
    interface    = "NVME"
    type         = "SCRATCH"
    disk_type    = "local-ssd"
  }
}

module "asg" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "2.1.0"

  instance_template = google_compute_instance_template.this.self_link
  region            = var.region

  autoscaling_enabled = var.autoscale_enabled
  min_replicas        = var.autoscale_enabled ? var.min_instances : null
  max_replicas        = var.autoscale_enabled ? var.max_instances : null
  target_size         = var.autoscale_enabled ? null : var.num_instances

  target_pools = var.use_external_lb ? [join(",", google_compute_target_pool.this.*.self_link)] : null
}