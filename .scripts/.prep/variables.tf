variable "proxmox_endpoint" {
  type      = string
  sensitive = true
}

variable "proxmox_api_token" {
  type      = string
  sensitive = true
}

variable "node_name" {
  default = "pve"
}

variable "vm_user" {
  default = "ubuntu"
}

variable "ssh_public_key" {
  type = string
}
