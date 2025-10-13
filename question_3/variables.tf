variable "project" {}
variable "region" { default = "us-central1" }
variable "zone" { default = "us-central1-a" }
variable "env" { default = "dev" }

variable "vpc_cidr" { default = "10.10.0.0/16" }
variable "private_subnet_cidrs" {
  type = map(string)
  default = {
    "us-central1-a" = "10.10.1.0/24"
    "us-central1-b" = "10.10.2.0/24"
  }
}
variable "public_subnet_cidrs" {
  type = map(string)
  default = {
    "us-central1-a" = "10.10.100.0/24"
  }
}

variable "instance_count" { default = 2 }
variable "instance_machine_type" { default = "e2-micro" }
variable "db_tier" { default = "db-f1-micro" }
variable "owner" { default = "ryan.lukasik@gmail.com" }
variable "cost_center" { default = "protera-01" }
