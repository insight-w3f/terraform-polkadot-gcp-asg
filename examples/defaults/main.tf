variable "gcp_region" {
  default = "us-east1"
}

variable "gcp_project" {
  default = "project"
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

module "network" {
  source   = "github.com/insight-infrastructure/terraform-polkadot-gcp-network.git?ref=master"
  vpc_name = "cci-test"
}

module "defaults" {
  source                 = "../.."
  node_name              = "sentry"
  relay_node_ip          = "1.2.3.4"
  relay_node_p2p_address = "abcdefg"
  security_group_id      = module.network.sentry_security_group_id[0]
  vpc_id                 = module.network.vpc_id
  network_name           = "dev"
  private_subnet_id      = module.network.private_subnets[0]
  public_subnet_id       = module.network.public_subnets[0]
}
