variable "registry" {
  description = "Registry used by ECS to pull the image. If the image is hosted on docker.hub you can specify the image name only."
  type = string
}

variable "image_version" {
  description = "Version of the image used by ECS."
  type = string
}