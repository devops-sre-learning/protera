variable "project" {}
variable "region" {}
variable "network" {}
variable "db_tier" { default = "db-f1-micro" }
variable "labels" { type = map(string) }
variable "env" { default = "dev" }
variable "network_ready" {}


resource "google_sql_database_instance" "postgres" {
  name             = "pg-${var.env}"
  project          = var.project
  database_version = "POSTGRES_13"
  region           = var.region

  settings {
    tier = var.db_tier
    ip_configuration {
      ipv4_enabled     = false
      private_network  = var.network
    }
    backup_configuration { enabled = true }
  }

  deletion_protection = false
  depends_on = [
    var.network_ready
  ]
}

resource "google_sql_database" "appdb" {
  name     = "appdb"
  instance = google_sql_database_instance.postgres.name
}

output "db_private_ip" {
  value = google_sql_database_instance.postgres.first_ip_address
}
