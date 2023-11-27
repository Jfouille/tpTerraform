data "terraform_remote_state" "gke" {
  backend = "local"

  config = {
    path = "./terraform.tfstate"
  }
}

data "google_container_cluster" "my_cluster" {
  name     = data.terraform_remote_state.gke.outputs.kubernetes_cluster_name
  location = var.region
}
