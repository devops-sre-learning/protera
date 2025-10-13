variable "project" {}
variable "region" {}
variable "zone" {}
variable "instance_count" {}
variable "machine_type" {}
variable "network_self_link" {}
variable "subnetwork_self_links" { type = list(string) }
variable "service_account_email" {}
variable "startup_script" {}
variable "labels" { type = map(string) }
variable "env" { default = "dev" }

resource "google_compute_instance_template" "app_template" {
  name_prefix = "app-template-${var.env}-"
  project = var.project
  machine_type = var.machine_type
  service_account {
    email  = var.service_account_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  network_interface {
    subnetwork = element(var.subnetwork_self_links, 0)
  }

  metadata_startup_script = var.startup_script
  tags = ["app-server-${var.env}"]
  labels = var.labels

  disk {
    boot = true
    source_image = "projects/debian-cloud/global/images/family/debian-11"
  }
}

resource "google_compute_region_instance_group_manager" "app_mig" {
  name               = "app-mig-${var.env}"
  project            = var.project
  region             = var.region
  base_instance_name = "app-${var.env}"
  version {
    instance_template = google_compute_instance_template.app_template.self_link
  }
  target_size = var.instance_count
  named_port {
    name = "http"
    port = 80
  }
}

output "instance_group" {
  value = google_compute_region_instance_group_manager.app_mig.instance_group
}
