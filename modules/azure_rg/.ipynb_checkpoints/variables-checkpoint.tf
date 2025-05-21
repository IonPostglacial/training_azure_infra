variable "subscription_id" {
  type = string
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
}

variable "vnet_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "vnet_address_space" {
  type = string
}

variable "subnet_address_prefix" {
  type = string
}

variable "open_ports" {
  type = list(string)
}