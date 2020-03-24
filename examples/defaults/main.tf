provider "google" {
  project = "insight-w3f"
  region  = "us-east1"
  zone    = "us-east1-b"
}

module "network" {
  source = "github.com/insight-infrastructure/terraform-polkadot-gcp-network.git?ref=master"
}

//module "lb" {
//  source = "github.com/insight-infrastructure/terraform-polkadot-azure-api-lb.git?ref=master"
//}

module "defaults" {
  source                 = "../.."
  relay_node_ip          = "1.2.3.4"
  relay_node_p2p_address = "1.2.3.4"
  chain                  = "dev"
  security_group_id      = module.network.sentry_security_group_id
  subnet_id              = module.network.public_subnets[0]
}
