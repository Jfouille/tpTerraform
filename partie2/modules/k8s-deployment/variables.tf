variable "metadata_name" {
  type = string
}

variable "label_app" {
  type = string
}

variable "label_tier" {
  type = string
}

variable "container_name" {
  type = string
}

variable "container_image" {
  type = string
}

variable "resources_requests" {
  type = map(any)
  default = {
    cpu = "100m"
    memory = "100Mi"
  }
}

variable "volume_mount" {
    type = object({
        name       = string
        mount_path = string
    }) 
    default = null
}

/*variable "volume_mount" {
    type = map
    default = null
}*/


variable "volume" {
    type = object({
        name       = string
        #empty_dir  = list(string)
    }) 
    default = null
}


variable "port" {
    type = object({
        name       = string
        container_port = number
    }) 
    default = null
}