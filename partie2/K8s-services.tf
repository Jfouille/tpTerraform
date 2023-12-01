module "redis-service" {
  source = "./modules/k8s-service/"

  metadata_name   = "redis"
  label_app       = "redis"
  selector_app    = "redis"
  service_type    = "ClusterIP"
  port            = {
      name        = "redis-service"
      port        = 6379
      target_port = 6379
  }
}

module "db-service" {
  source = "./modules/k8s-service/"

  metadata_name   = "db"
  label_app       = "db"
  selector_app    = "db"
  service_type    = "ClusterIP"
  port            = {
      name        = "db-service"
      port        = 5432
      target_port = 5432
  }
}

module "result-service" {
  source = "./modules/k8s-service/"

  metadata_name   = "result"
  label_app       = "result"
  selector_app    = "result"
  service_type    = "NodePort"
  port            = {
      name        = "result-service"
      port        = 5001
      target_port = 80
      node_port   = 31001
  }
}

module "vote-service" {
  source = "./modules/k8s-service/"

  metadata_name   = "vote"
  label_app       = "vote"
  selector_app    = "vote"
  service_type    = "NodePort"
  port            = {
      name        = "vote-service"
      port        = 5000
      target_port = 80
      node_port   = 31000
  }
}
