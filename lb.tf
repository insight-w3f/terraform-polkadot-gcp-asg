resource "google_compute_http_health_check" "rpc-hc" {
  count = var.use_lb ? 1 : 0
  name  = "rpc-health"
  port  = 5500
}

resource "google_compute_target_pool" "this" {
  count = var.use_lb && var.use_external_lb ? 1 : 0
  name  = "rpc-target"

  health_checks = [join(",", google_compute_http_health_check.rpc-hc.*.self_link)]
}

resource "google_compute_region_backend_service" "this" {
  count         = var.use_lb && ! var.use_external_lb ? 1 : 0
  health_checks = [join(",", google_compute_http_health_check.rpc-hc.*.self_link)]
  name          = "rpc-target"
  region        = var.region
  backend {
    group = module.asg.instance_group
  }
}

resource "google_compute_forwarding_rule" "external" {
  count    = var.use_lb && var.use_external_lb ? 1 : 0
  provider = google-beta

  name                  = var.lb_name
  target                = google_compute_target_pool.this[0].self_link
  load_balancing_scheme = "EXTERNAL"
  ip_protocol           = "TCP"
  port_range            = ["9933", "9944"]
}

resource "google_compute_forwarding_rule" "internal" {
  count    = var.use_lb && ! var.use_external_lb ? 1 : 0
  provider = google-beta

  name                  = var.lb_name
  backend_service       = google_compute_region_backend_service.this[0].self_link
  load_balancing_scheme = "INTERNAL"
  ip_protocol           = "TCP"
  all_ports             = true
  region                = var.region
  network               = var.vpc_id
  subnetwork            = var.public_subnet_id
  service_label         = "api-internal"
}
