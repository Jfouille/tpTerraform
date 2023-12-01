variable "metadata_name" {
  type = string
}

variable "label_app" {
  type = string
}

variable "port" {
    type = object({
        name        = string
        port        = number
        target_port = number
        node_port   = optional(number)
    }) 
    default = null
}

variable "selector_app" {
  type = string
}

variable "service_type" {
    type = string
}