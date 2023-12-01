resource "kubernetes_ingress_v1" "result-ingess" {
  metadata {
    name = "result-ingress"
  }
  spec {
    default_backend {
      service {
        name = "result"
        port {
          number = 5001
        }
      }
    }
  }
}


resource "kubernetes_ingress_v1" "vote-ingess" {
  metadata {
    name      = "vote-ingress"
  }

  spec {
    default_backend {
      service {
        name = "vote"
        port {
          number = 5000
        }
      }
    }
  }
}