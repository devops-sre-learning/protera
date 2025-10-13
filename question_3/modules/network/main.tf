variable "project" {}
variable "region" {}
variable "vpc_cidr" {}
variable "private_subnet_cidrs" { type = map(string) }
variable "public_subnet_cidrs" { type = map(string) }
variable "labels" { type = map(string) }
variable "env" { default = "dev" }

# Enable the Service Networking API (only needed once)
resource "google_project_service" "service_networking" {
  project = var.project
  service = "servicenetworking.googleapis.com"
}

# Reserve a range for private service connection
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "google-managed-services-${var.project}"
  project       = var.project
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.self_link
}

# Establish the private service connection
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]

  depends_on = [google_project_service.service_networking]
}


resource "google_compute_network" "vpc" {
  name                    = "gcp-webstack-${var.env}-vpc"
  auto_create_subnetworks = false
  project                 = var.project
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "public" {
  for_each = var.public_subnet_cidrs
  name          = "public-${each.key}"
  ip_cidr_range = each.value
  region        = var.region
  network       = google_compute_network.vpc.self_link
  private_ip_google_access = true
  project = var.project
  #labels = var.labels
}

resource "google_compute_subnetwork" "private" {
  for_each = var.private_subnet_cidrs
  name          = "private-${each.key}"
  ip_cidr_range = each.value
  region        = var.region
  network       = google_compute_network.vpc.self_link
  private_ip_google_access = true
  project = var.project
  #labels = var.labels
}

resource "google_compute_router" "nat_router" {
  name    = "nat-router-${var.env}"
  network = google_compute_network.vpc.self_link
  region  = var.region
  project = var.project
}

resource "google_compute_router_nat" "nat" {
  name                               = "cloudnat-${var.env}"
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  project                            = var.project
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

output "vpc_self_link" { value = google_compute_network.vpc.self_link }
output "vpc_name" { value = google_compute_network.vpc.name }
output "private_subnet_self_links" { value = [for s in google_compute_subnetwork.private: s.self_link] }
output "public_subnet_self_links" { value = [for s in google_compute_subnetwork.public: s.self_link] }
output "service_networking_connection_id" {
  value = google_service_networking_connection.private_vpc_connection.id
}

