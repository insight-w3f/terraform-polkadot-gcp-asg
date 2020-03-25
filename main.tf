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

module "packer" {
  source = "github.com/insight-infrastructure/terraform-aws-packer-ami.git"

  packer_config_path = "${path.module}/packer.json"
  timestamp_ui       = true
  vars = {
    module_path : path.module,
    vpc : var.vpc_id,
    subnet : var.public_subnet_id,
    node_exporter_user : var.node_exporter_user,
    node_exporter_password : var.node_exporter_password,
    network_name : var.network_name,
    ssh_user : var.ssh_user,
    project : var.project,
    zone : var.zone,
    polkadot_binary_url : "https://github.com/w3f/polkadot/releases/download/v0.7.21/polkadot",
    polkadot_binary_checksum : "sha256:af561dc3447e8e6723413cbeed0e5b1f0f38cffaa408696a57541897bf97a34d",
    node_exporter_binary_url : "https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz",
    node_exporter_binary_checksum : "sha256:b2503fd932f85f4e5baf161268854bf5d22001869b84f00fd2d1f57b51b72424",
    polkadot_restart_enabled : true,
    polkadot_restart_minute : "50",
    polkadot_restart_hour : "10",
    polkadot_restart_day : "1",
    polkadot_restart_month : "*",
    polkadot_restart_weekday : "*",
    telemetry_url : var.telemetry_url,
    logging_filter : var.logging_filter,
    relay_ip_address : var.relay_node_ip,
    relay_p2p_address : var.relay_node_p2p_address
  }
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
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  metadata_startup_script = <<-EOT
    mkfs.ext4 -F /dev/nvme0n1
    mkdir -p /mnt/disks/nvme
    mount /dev/nvme0n1 /mnt/disks/nvme
    chmod a+w /mnt/disks/nvme

    systemctl stop polkadot
    mkdir /mnt/disks/nvme/polkadot
    chown polkadot:polkadot /mnt/disks/nvme/polkadot
    mv /home/polkadot/.local/share/polkadot/chains /mnt/disks/nvme/polkadot/
    ln -s /mnt/disks/nvme/polkadot /home/polkadot/.local/share/polkadot
    systemctl start polkadot
  EOT

  disk {
    boot         = true
    auto_delete  = true
    disk_size_gb = var.root_volume_size
    disk_type    = "pd-standard"
    source_image = data.google_compute_image.ubuntu.self_link
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

resource "google_compute_instance_group_manager" "this" {
  base_instance_name = var.node_name
  name               = "${var.node_name}-group-manager"

  target_size = var.num_instances

  version {
    instance_template = google_compute_instance_template.this.self_link
    name              = var.node_name
  }
}