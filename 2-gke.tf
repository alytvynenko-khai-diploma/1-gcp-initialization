locals {
  cluster_name = "gke-main"
}

module "gke" {
  depends_on = [ module.vpc ]

  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 36.0"

  project_id                  = local.project_id
  name                        = local.cluster_name
  regional                    = true
  region                      = local.region
  network                     = local.vpc_basename
  subnetwork                  = local.vpc_subnet_basename
  ip_range_pods               = "${local.vpc_subnet_basename}-ip-range-pods"
  ip_range_services           = "${local.vpc_subnet_basename}-ip-range-services"
  create_service_account      = false
  # service_account             = var.compute_engine_service_account
  http_load_balancing = false
  network_policy = false
  horizontal_pod_autoscaling = false
  enable_cost_allocation      = false
  # enable_binary_authorization = false
  gcs_fuse_csi_driver         = true
  # fleet_project               = var.project_id
  deletion_protection         = false
  remove_default_node_pool = true
  # stateful_ha                 = true

  node_pools = [
    {
      name              = "pool-main"
      # machine_type      = "e2-highcpu-8" # Details: https://cloud.google.com/compute/docs/general-purpose-machines#e2-standard
      machine_type      = "e2-standard-4" # Details: https://cloud.google.com/compute/docs/general-purpose-machines#e2-standard
      node_count        = 1
      autoscaling = false
      auto_repair = false
      auto_upgrade = true
      node_locations              = join(",", local.zones)
      # min_count                   = 1
      # max_count                   = 5
      local_ssd_count             = 0
      spot                        = false
      disk_size_gb                = 50
      disk_type                   = "pd-standard"
      image_type                  = "COS_CONTAINERD"
      enable_gcfs                 = false
      enable_gvnic                = false
      logging_variant             = "DEFAULT"
      service_account             = "terraform-diploma@chrome-lane-454119-a6.iam.gserviceaccount.com"
      preemptible                 = false
      initial_node_count          = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}
