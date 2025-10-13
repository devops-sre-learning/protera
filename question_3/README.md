# Prerequisites

Terraform: v1.3.0 or later

GCP SDK (gcloud) for authentication and IAP access

GCP Project: with billing enabled

Permissions: Service account or user with Editor or equivalent permissions during provisioning

# Authentication setup

gcloud auth application-default login
gcloud config set project <your-gcp-project-id>

# Provider configuration

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}


# How to Run

1. Initialize providers and modules:

terraform init

2. Preview the plan:

terraform plan -out=tfplan

3. Apply changes (deploy):

terraform apply tfplan

4. Destroy when done (cleanup):

terraform destroy -auto-approve


# Sample terraform.tfvars

project = "my-gcp-project-id"
region  = "us-central1"
zone    = "us-central1-a"
env     = "dev"
instance_machine_type = "e2-micro"
instance_count = 2
db_tier = "db-f1-micro"


# Architecture Overview

Components

VPC — custom network with public & private subnets in multiple zones

App Instances — e2-micro VMs in private subnets, no public IPs

Load Balancer — HTTP LB fronting the instance group

Cloud SQL — PostgreSQL with private IP

Cloud NAT — outbound access without exposing VMs

GCS Bucket — logs / artifacts with versioning and blocked public access

IAP — secure admin access without SSH exposure


# Module Layout

| Module       | Path              | Description                                 |
| ------------ | ----------------- | ------------------------------------------- |
| **Network**  | `modules/network` | VPC, subnets, router, NAT                   |
| **Compute**  | `modules/compute` | Instance template & regional MIG            |
| **LB**       | `modules/lb`      | HTTP load balancer & backend service        |
| **DB**       | `modules/db`      | Private Cloud SQL PostgreSQL                |
| **Storage**  | `modules/storage` | GCS bucket with versioning                  |
| **Security** | inline            | IAM, firewall, service accounts, IAP access |


# Expected Terraform Outputs

Outputs:

app_instance_group        = "https://www.googleapis.com/compute/v1/..."
db_private_ip             = "10.10.3.5"
load_balancer_ip_or_dns   = "34.xxx.xxx.xxx"
logs_bucket               = "gcp-webstack-logs-my-gcp-project-dev"
vpc_id                    = "gcp-webstack-dev-vpc"


# Design Choices & Trade-offs

This was designed to test in GCP Free tier but can easily be more production ready by adding instances and uncommenting the load balancer sections.  
I did not test the LB because I did not want to incur charges. I did change the default instances back to 2 but I tested with only 1. 


| Area          | Choice                     | Trade-off                                       |
| ------------- | -------------------------- | ----------------------------------------------- |
| Load Balancer | Enabled                    | Realistic architecture but may incur small cost |
| DB Tier       | `db-f1-micro`, single zone | Free-tier friendly but no HA                    |
| TLS           | Disabled by default        | Simpler & cheaper; can add Cert Manager later   |
| Egress        | Cloud NAT                  | Secure and minimal cost                         |
| Access        | IAP tunnel only            | Secure, but requires gcloud                     |
| Scaling       | 2 instances                | Meets HA; can lower to 1 for free tier          |
| Security      | Least privilege IAM        | More secure but stricter permissions            |
| Cost          | Free-tier defaults         | Easy to scale to production later               |
