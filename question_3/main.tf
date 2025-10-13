module "network" {
  source = "./modules/network"
  project = var.project
  region  = var.region
  vpc_cidr = var.vpc_cidr
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  labels = {
    project = var.project
    env = var.env
    owner = var.owner
    costCenter = var.cost_center
  }
}

module "storage" {
  source = "./modules/storage"
  project = var.project
  region  = var.region
  labels = {
    project = var.project
    env = var.env
  }
}

module "db" {
  source = "./modules/db"
  project = var.project
  region  = var.region
  network = module.network.vpc_self_link
  db_tier = var.db_tier
  network_ready = module.network.service_networking_connection_id
  labels = {
    project = var.project
    env = var.env
  }
}

module "compute" {
  source = "./modules/compute"
  project = var.project
  region  = var.region
  zone    = var.zone
  env = var.env
  instance_count = var.instance_count
  machine_type = var.instance_machine_type
  network_self_link = module.network.vpc_self_link
  subnetwork_self_links = module.network.private_subnet_self_links
  service_account_email = google_service_account.instance_sa.email
  startup_script = file("./scripts/startup.sh")
  labels = {
    project = var.project
    env = var.env
  }
}

# Load balancer is optional to avoid LB cost during testing.
# Uncomment to enable a public-facing HTTP load balancer.
# module "lb" {
#   source = "./modules/lb"
#   project = var.project
#   region  = var.region
#   network = module.network.vpc_self_link
#   backend_instance_group = module.compute.instance_group
#   health_check_path = "/"
#   labels = {
#     project = var.project
#     env = var.env
#   }
# }

resource "google_service_account" "instance_sa" {
  account_id   = "app-instance-sa-${var.env}"
  display_name = "App instances service account"
}

resource "google_project_iam_member" "sa_compute_access" {
  project = var.project
  role    = "roles/compute.instanceAdmin.v1"
  member  = "serviceAccount:${google_service_account.instance_sa.email}"
}

resource "google_project_iam_member" "sa_logging" {
  project = var.project
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.instance_sa.email}"
}

resource "google_project_iam_member" "sa_cloudsql_client" {
  project = var.project
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.instance_sa.email}"
}
