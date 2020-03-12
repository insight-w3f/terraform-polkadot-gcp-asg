data "google_client_config" "this" {}

data "google_compute_image" "ubuntu" {
  family  = "ubuntu-minimal-1804-lts"
  project = "ubuntu-os-cloud"
}