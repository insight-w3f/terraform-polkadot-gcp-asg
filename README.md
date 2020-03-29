# terraform-polkadot-gcp-asg

[![open-issues](https://img.shields.io/github/issues-raw/insight-w3f/terraform-polkadot-gcp-asg?style=for-the-badge)](https://github.com/insight-w3f/terraform-polkadot-gcp-asg/issues)
[![open-pr](https://img.shields.io/github/issues-pr-raw/insight-w3f/terraform-polkadot-gcp-asg?style=for-the-badge)](https://github.com/insight-w3f/terraform-polkadot-gcp-asg/pulls)
[![build-status](https://circleci.com/gh/insight-w3f/terraform-polkadot-gcp-asg.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-gcp-asg)


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
## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| create\_eip | Boolean to create elastic IP | `bool` | `false` | no |
| environment | The environment | `string` | `""` | no |
| instance\_type | Instance type | `string` | `"n1-standard-1"` | no |
| key\_name | The name of the preexisting key to be used instead of the local public\_key\_path | `string` | `""` | no |
| logging\_filter | String for polkadot logging filter | `string` | `"sync=trace,afg=trace,babe=debug"` | no |
| monitoring | Boolean for cloudwatch | `bool` | `false` | no |
| namespace | The namespace to deploy into | `string` | `""` | no |
| network\_name | The network name, ie kusama / mainnet | `string` | `"kusama"` | no |
| node\_exporter\_password | Password for node exporter | `string` | `"node_exporter_password"` | no |
| node\_exporter\_user | User for node exporter | `string` | `"node_exporter_user"` | no |
| node\_name | Name of the node | `string` | n/a | yes |
| num\_instances | Number of instances for ASG | `number` | `1` | no |
| owner | Owner of the infrastructure | `string` | `""` | no |
| private\_subnet\_id | The ID of the private subnet to join | `string` | n/a | yes |
| project | Name of the project for node name | `string` | `"project"` | no |
| public\_key\_path | The path to the public ssh key | `string` | `""` | no |
| public\_subnet\_id | The ID of the public subnet to join | `string` | n/a | yes |
| region | The GCP region to deploy in | `string` | `"us-east1"` | no |
| relay\_node\_ip | Internal IP of Polkadot relay node | `string` | n/a | yes |
| relay\_node\_p2p\_address | P2P address of Polkadot relay node | `string` | n/a | yes |
| root\_volume\_size | Root volume size | `string` | `0` | no |
| security\_group\_id | The id of the security group to run in | `string` | n/a | yes |
| ssh\_user | Username for SSH | `string` | `"ubuntu"` | no |
| stage | The stage of the deployment | `string` | `""` | no |
| target\_pool\_id | The ID of the target pool for the load balancer | `string` | `""` | no |
| telemetry\_url | WSS URL for telemetry | `string` | `"wss://mi.private.telemetry.backend/"` | no |
| use\_lb | Boolean to enable use of load balancer | `bool` | `false` | no |
| vpc\_id | The ID of the VPC | `string` | n/a | yes |
| zone | The GCP zone to deploy in | `string` | `"us-east1-b"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cmd | n/a |

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