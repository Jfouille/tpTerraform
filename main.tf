# SERVICES
    # vote => A front-end web app in Python which lets you vote between two options
    # redis => A Redis which collects new votes
    # worker => A .NET worker which consumes votes and stores them in…
    # db => A Postgres database backed by a Docker volume
    # result => A Node.js web app which shows the results of the voting in real time

#VOLUMES : use "docker_volume"
    # back-tier        
    # db-data 

# NETWORKS : use "docker_network"
    # front-tier
    # back-tier



terraform {
    required_providers {
        docker = {
            source  = "kreuzwerker/docker"
            version = "~> 3.0.2"
        }
    }
}


# =======================
# NETWORKS
# =======================


resource "docker_network" "front-tier-network" {
  name = "front-tier"
}

resource "docker_network" "back-tier-network" {
  name = "back-tier"
}

# =======================
# VOLUMES
# =======================

resource "docker_volume" "db-data" {
  name = "db-data"
}

resource "docker_volume" "back-tier" {
  name = "back-tier"
}



# =======================
# REDIS
# =======================
resource "docker_image" "redisImg" {
    name = "redis:alpine"
}

resource "docker_container" "redis" {
    name  = "redis"
    image = docker_image.redisImg.image_id
}


# =======================
# POSTGRES 
# =======================
resource "docker_image" "postgresImg" {
    name = "postgres:15-alpine"
}

resource "docker_container" "db" {
    name  = "db"
    image = docker_image.postgresImg.image_id
    env = ["POSTGRES_USER=postgres", "POSTGRES_PASSWORD=postgres"]

    volumes {
        volume_name = docker_volume.db-data.name
        container_path = "/var/lib/postgresql/data"
    }

    healthcheck {
      test = ["/healthchecks/postgres.sh"]
      interval = "5s"
    }

    networks_advanced {
        name = "back-tier"
    }
}




# =======================
# FRONTEND
# =======================
resource "docker_image" "vote-frontend" {
    name = "vote-frontend"
    build {
        context = "./example-voting-app-main/vote"
    }
}

resource "docker_container" "vote" {
    name  = "vote"
    image = docker_image.vote-frontend.image_id
    ports {
        internal = "80"
        external = "5000"
    }
    env = [
        "GET_HOSTS_FROM=dns"
    ]
    healthcheck {
        test = ["CMD", "curl", "-f", "http://localhost"]
        interval = "15s"
        retries = 3
        timeout = "5s"
        start_period = "10s"
    }
    volumes {
        name = "vote"
        host_path =  = "./vote:/usr/local/app"

        # volume_name = docker_volume.db-data.name
        # container_path = "./vote:/usr/local/app"
    }

    networks_advanced {
        name = "back-tier"
    }

    networks_advanced {
        name = "front-tier"
    }

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
    value = "http://localhost:${docker_container.vote.ports[0].external}"
    description = "The URL endpoint to access the vote application"
}


# =======================
# WORKER
# =======================
resource "docker_image" "vote-worker" {
    name = "vote-worker"
    build {
        context = "./example-voting-app-main/worker"
    }
}

resource "docker_container" "worker" {
    name  = "vote_worker"
    image = docker_image.vote-worker.image_id
    env = [
        "GET_HOSTS_FROM=dns"
    ]
    host {
        host = "db"
        ip = docker_container.db.network_data[0].ip_address
    }
}

# =======================
# RESULT
# =======================
resource "docker_image" "vote-result" {
    name = "vote-result"
    build {
        context = "./example-voting-app-main/result"
    }
}

resource "docker_container" "result" {
    name  = "vote_result"
    image = docker_image.vote-result.image_id
    
    ports {
        internal = "80"
        external = "5001"
    }

    env = [
        "GET_HOSTS_FROM=dns"
    ]

    host {
        host = "db"
        ip = docker_container.db.network_data[0].ip_address
    }
}
