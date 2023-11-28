variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "zone" {
  description = "zone"
}

variable "file_path" {
  description = "file_path"
}

terraform {

  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.6.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }

    
  }
}


provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
  credentials = file(var.file_path)
}






# Configure kubernetes provider with Oauth2 access token.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config
# This fetches a new token, which will expire in 1 hour.
data "google_client_config" "default" {}

provider "kubernetes" {
  host  = "https://${google_container_cluster.mycluster.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.mycluster.master_auth[0].cluster_ca_certificate,
  )
}