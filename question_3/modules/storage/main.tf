variable "project" {}
variable "region" {}
variable "labels" { type = map(string) }
variable "env" { default = "dev" }

resource "google_storage_bucket" "logs" {
  provider = google-beta
  name     = "gcp-webstack-logs-${var.project}-${var.env}"
  project  = var.project
  location = var.region

  versioning {
    enabled = true
  }

  force_destroy = false

  uniform_bucket_level_access = true
  public_access_prevention   = "enforced"

 
}

output "bucket_name" { value = google_storage_bucket.logs.name }
