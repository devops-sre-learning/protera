variable "project" {}
variable "region" {}
variable "env" { default = "dev" }
variable "backend_instance_group" {}
variable "health_check_path" { default = "/" }
variable "labels" { type = map(string) }

resource "google_compute_health_check" "http_hc" {
  name = "app-hc-${var.env}"
  check_interval_sec = 10
  timeout_sec = 5
  healthy_threshold = 2
  unhealthy_threshold = 3

  http_health_check {
    port = 80
    request_path = var.health_check_path
  }
  project = var.project
}

resource "google_compute_backend_service" "default" {
  name = "app-backend-${var.env}"
  project = var.project
  protocol = "HTTP"
  health_checks = [google_compute_health_check.http_hc.self_link]
  backend {
    group = var.backend_instance_group
  }
  timeout_sec = 30
  port_name = "http"
  enable_cdn = false
}

resource "google_compute_url_map" "lb_map" {
  name = "lb-map-${var.env}"
  default_service = google_compute_backend_service.default.self_link
  project = var.project
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name = "http-proxy-${var.env}"
  url_map = google_compute_url_map.lb_map.self_link
  project = var.project
}

resource "google_compute_global_forwarding_rule" "http_forward" {
  name = "http-forward-${var.env}"
  target = google_compute_target_http_proxy.http_proxy.self_link
  port_range = "80"
  project = var.project
  ip_protocol = "TCP"
}

output "lb_ip" {
  value = google_compute_global_forwarding_rule.http_forward.ip_address
}