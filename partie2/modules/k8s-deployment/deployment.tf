resource "kubernetes_deployment_v1" "deplt" {
  metadata {
    name = var.metadata_name
    labels = {
      App = var.label_app
      Tier = var.label_tier
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        App = var.label_app
      }
    }
    template {
      metadata {
        labels = {
          App = var.label_app
          Tier = var.label_tier
        }
      }
      spec {

        dynamic "volume" {
            for_each = var.volume == null ? [] : [1]
            
            content {
                name = var.volume.name
                #empty_dir  = var.volume.empty_dir
            } 
        }

        container {

          name  = var.container_name
          image = var.container_image

          resources {
            requests = var.resources_requests
          }

          dynamic "env" {
            for_each = var.env == null ? [] : var.env
            iterator = item   #optional
            content {
                name = item.value.name
                value = item.value.value
            }       
          }

          dynamic "port" {
            for_each = var.port == null ? [] : [1]
            content {
                name           = var.port.name
                container_port = var.port.container_port
            } 
        }

          ## GESTION ENV POSTRGRES !!!

          

          dynamic "volume_mount" {
            for_each = var.volume_mount == null ? [] : [1]
            content {
                name = var.volume_mount.name
                mount_path = var.volume_mount.mount_path
            }       
          }



        }
      }
    }
  }
}