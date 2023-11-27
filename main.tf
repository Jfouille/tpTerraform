terraform {
    required_providers {
        docker = {
            source  = "kreuzwerker/docker"
            version = "~> 3.0.2"
        }
    }
}

resource "docker_image" "redisImg" {
    name = "redis:alpine"
}

resource "docker_container" "redis" {
    name  = "redis"
    image = docker_image.redisImg.image_id
}

resource "docker_image" "vote-frontend" {
    name = "vote-frontend"
    build {
        context = "./example-voting-app-main/vote"
    }
}

resource "docker_container" "frontend" {
  name  = "vote_frontend"
  image = docker_image.vote-frontend.image_id
  ports {
    internal = "80"
    external = "5000"
  }
  env = [
    "GET_HOSTS_FROM=dns"
  ]
  host {
    host = "redis-leader"
    ip = docker_container.redis.network_data[0].ip_address
  }
  host {
    host = "redis-follower"
    ip = docker_container.redis.network_data[0].ip_address
  }
}

output "app_endpoint" {
  value = "http://localhost:${docker_container.frontend.ports[0].external}"
  description = "The URL endpoint to access the Guestbook application"
}

# SERVICES
    # vote => A front-end web app in Python which lets you vote between two options
    # redis => A Redis which collects new votes
    # worker => A .NET worker which consumes votes and stores them in…
    # db => A Postgres database backed by a Docker volume
    # result => A Node.js web app which shows the results of the voting in real time

#VOLUMES : use "docker_volume"
# back-tietr        # db-data 


# NETWORKS : use "docker_network"
    # front-tier
    # back-tier

#Images : 
