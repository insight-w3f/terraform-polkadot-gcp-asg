# terraform-polkadot-gcp-asg

[![open-issues](https://img.shields.io/github/issues-raw/insight-w3f/terraform-polkadot-gcp-asg?style=for-the-badge)](https://github.com/insight-w3f/terraform-polkadot-gcp-asg/issues)
[![open-pr](https://img.shields.io/github/issues-pr-raw/insight-w3f/terraform-polkadot-gcp-asg?style=for-the-badge)](https://github.com/insight-w3f/terraform-polkadot-gcp-asg/pulls)
[![build-status](https://img.shields.io/circleci/build/github/insight-w3f/terraform-polkadot-gcp-asg?style=for-the-badge)](https://circleci.com/gh/insight-w3f/terraform-polkadot-gcp-asg)


## Features

This module...

## Terraform Versions

For Terraform v0.12.0+

## Usage

```hcl
module "network" {
  source   = "github.com/insight-w3f/terraform-polkadot-gcp-network.git?ref=master"
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
  public_key_path        = var.public_key_path
  use_lb                 = false

  zone    = var.gcp_zone
  region  = var.gcp_region
  project = var.gcp_project
}
```

## Examples

- [defaults](https://github.com/insight-w3f/terraform-polkadot-gcp-asg/tree/master/examples/defaults)

## Known  Issues
No issue is creating limit on this module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| google | n/a |
| google-beta | n/a |
| null | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| autoscale\_enabled | Do you want to use autoscaling? | `bool` | `false` | no |
| cluster\_name | The name of the k8s cluster | `string` | `""` | no |
| consul\_enabled | Bool to use when Consul is enabled | `bool` | `false` | no |
| create\_eip | Boolean to create elastic IP | `bool` | `false` | no |
| environment | The environment | `string` | `""` | no |
| instance\_type | Instance type | `string` | `"n1-standard-1"` | no |
| lb\_name | Name of the load balancer | `string` | `"lb"` | no |
| logging\_filter | String for polkadot logging filter | `string` | `"sync=trace,afg=trace,babe=debug"` | no |
| max\_instances | If autoscaling enabled; the maxiumum number of instances | `number` | `1` | no |
| min\_instances | If autoscaling enabled; the minimum number of instances | `number` | `1` | no |
| monitoring | Boolean for cloudwatch | `bool` | `false` | no |
| namespace | The namespace to deploy into | `string` | `""` | no |
| network\_name | The network name, ie kusama / mainnet | `string` | `"kusama"` | no |
| node\_exporter\_hash | SHA256 hash of Node Exporter binary | `string` | `"b2503fd932f85f4e5baf161268854bf5d22001869b84f00fd2d1f57b51b72424"` | no |
| node\_exporter\_password | Password for node exporter | `string` | `"node_exporter_password"` | no |
| node\_exporter\_url | URL to Node Exporter binary | `string` | `"https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz"` | no |
| node\_exporter\_user | User for node exporter | `string` | `"node_exporter_user"` | no |
| node\_name | Name of the node | `string` | n/a | yes |
| num\_instances | Number of instances for ASG | `number` | `1` | no |
| owner | Owner of the infrastructure | `string` | `""` | no |
| polkadot\_client\_hash | SHA256 hash of Polkadot client binary | `string` | `"c34d63e5d80994b2123a3a0b7c5a81ce8dc0f257ee72064bf06654c2b93e31c9"` | no |
| polkadot\_client\_url | URL to Polkadot client binary | `string` | `"https://github.com/w3f/polkadot/releases/download/v0.7.32/polkadot"` | no |
| private\_subnet\_id | The ID of the private subnet to join | `string` | n/a | yes |
| project | Name of the project for node name | `string` | `"project"` | no |
| prometheus\_enabled | Bool to use when Prometheus is enabled | `bool` | `false` | no |
| public\_key | The public ssh key | `string` | `""` | no |
| public\_key\_path | A path to the public key | `string` | `""` | no |
| public\_subnet\_id | The ID of the public subnet to join | `string` | n/a | yes |
| region | The GCP region to deploy in | `string` | `"us-east1"` | no |
| relay\_node\_ip | Internal IP of Polkadot relay node | `string` | `""` | no |
| relay\_node\_p2p\_address | P2P address of Polkadot relay node | `string` | `""` | no |
| root\_volume\_size | Root volume size | `string` | `0` | no |
| security\_group\_id | The id of the security group to run in | `string` | n/a | yes |
| ssh\_user | Username for SSH | `string` | `"ubuntu"` | no |
| stage | The stage of the deployment | `string` | `""` | no |
| telemetry\_url | WSS URL for telemetry | `string` | `""` | no |
| use\_external\_lb | Boolean to enable use of external load balancer | `bool` | `false` | no |
| use\_lb | Boolean to enable the use of a load balancer | `bool` | `false` | no |
| vpc\_id | The ID of the public VPC | `string` | n/a | yes |
| zone | The GCP zone to deploy in | `string` | `"us-east1-b"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cmd | n/a |
| instance\_group\_id | n/a |
| lb\_endpoint | n/a |
| target\_pool\_id | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Testing
This module has been packaged with terratest tests

To run them:

1. Install Go
2. Run `make test-init` from the root of this repo
3. Run `make test` again from root

## Authors

Module managed by [Richard Mah](https://github.com/shinyfoil)

## Credits

- [Anton Babenko](https://github.com/antonbabenko)

## License

Apache 2 Licensed. See LICENSE for full details.