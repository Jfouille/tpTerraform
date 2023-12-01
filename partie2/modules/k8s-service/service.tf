resource "kubernetes_service_v1" "srv" {
  metadata {
    name = var.metadata_name

    labels = {
      App = var.label_app
    }
  }

  spec {
    port {
      name        = var.port.name
      port        = var.port.port
      target_port = var.port.target_port
      node_port   = var.port.node_port
    }

    selector = {
      App = var.selector_app
    }

    type = var.service_type
  }
}