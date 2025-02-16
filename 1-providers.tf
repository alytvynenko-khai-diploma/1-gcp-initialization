terraform {
  required_version = ">= 1.10.5"

  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 6.20.0"
    }
  }
}

provider "google" {
  #   credentials = "${file("account.json")}"
  project     = "university-diploma"
  region      = "northamerica-south1"# The cheapest region: https://cloudprice.net/gcp/regions
  zone        = "" # TODO: select zone
}
