locals {
  project_id = "chrome-lane-454119-a6"
  region  = "us-central1" # The cheapest region: https://cloudprice.net/gcp/regions
  zones    = ["${local.region}-a"]
  # zones    = [
  #   "${local.region}-a", "${local.region}-b", "${local.region}-c",
  # ]
}

terraform {
  required_version = ">= 1.10.5"

  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 6.20.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = ">= 4.64.0"
    }
  }
}

provider "google" {
  credentials = "${file("account.json")}"
  project     = local.project_id
  region      = local.region
  zone        = local.zones[0]
}

# Used for VPC module
provider "google-beta" {
  credentials = "${file("account.json")}"
  project     = local.project_id
  region      = local.region
  zone        = local.zones[0]
}