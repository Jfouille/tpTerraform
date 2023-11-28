/*module "name-deployment" {
  source = "./modules/k8s-deployment/"

  metadata_name   = ""
  label_app       = ""
  label_tier      = ""
  container_name  = ""
  container_image = ""
  container_port  = 
  volume          = {
      name       = ""
      empty_dir = ""
  }
  volume_mount    = {
      name       = ""
      mount_path = ""
  }

}*/

module "result-deployment" {
  source = "./modules/k8s-deployment/"

  metadata_name   = "result"
  label_app       = "result"
  label_tier      = ""
  container_name  = "result"
  container_image = "dockersamples/examplevotingapp_result"
  port = {
      name           = "result"
      container_port = 80
  }

  
}


module "redis-deployment" {
  source = "./modules/k8s-deployment/"

  metadata_name   = "redis"
  label_app       = "redis"
  label_tier      = ""
  container_name  = "redis"
  container_image = "redis:alpine"
  port            = {
      name       = "redis"
      container_port = 6379
  }

  volume_mount = {
            name       = "redis-data"
            mount_path = "/data"
          }

}


module "db-deployment" {
  source = "./modules/k8s-deployment/"

  metadata_name   = "db"
  label_app       = "db"
  label_tier      = "db"
  container_name  = "postgres"
  container_image = "postgres:15-alpine"
  port            = {
      name       = "postgres"
      container_port = 5432
  }
  volume          = {
      name       = "db-data"
  }
  volume_mount    = {
      name       = "db-data"
      mount_path = "/var/lib/postgresql/data"
  }

}


module "vote-deployment" {
  source = "./modules/k8s-deployment/"

  metadata_name   = "vote"
  label_app       = "vote"
  label_tier      = "vote"
  container_name  = "vote"
  container_image = "dockersamples/examplevotingapp_vote"
  port            = {
      name       = "vote"
      container_port = 80
  }
}

module "worker-deployment" {
  source = "./modules/k8s-deployment/"

  metadata_name   = "worker"
  label_app       = "worker"
  label_tier      = "worker"
  container_name  = "worker"
  container_image = "dockersamples/examplevotingapp_worker"
}


