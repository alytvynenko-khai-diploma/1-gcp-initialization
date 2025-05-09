locals {
  vpc_basename = "gke-vpc"
  vpc_subnet_basename = "gke-subnet-01"
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version      = "~> 10.0"
  project_id   = local.project_id
  network_name = local.vpc_basename

  subnets = [
    {
      subnet_name   = local.vpc_subnet_basename
      subnet_ip     = "10.0.1.0/24"
      subnet_region = local.region
    }
  ]

  secondary_ranges = {
    "${local.vpc_subnet_basename}" = [
      {
        range_name = "${local.vpc_subnet_basename}-ip-range-pods"
        ip_cidr_range = "192.168.1.0/24"
      },
      {
        range_name = "${local.vpc_subnet_basename}-ip-range-services"
        ip_cidr_range = "192.168.2.0/24"
      }
    ]
  }
}
