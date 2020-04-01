data "google_client_config" "this" {}

data "google_compute_image" "packer" {
  family     = "polkadot-sentry"
  project    = var.project
  depends_on = [module.packer]
}