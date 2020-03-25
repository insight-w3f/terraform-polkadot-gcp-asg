data "google_client_config" "this" {}

data "google_compute_image" "ubuntu" {
  family     = "polkadot-sentry"
  project    = var.project
  depends_on = [module.packer]
}