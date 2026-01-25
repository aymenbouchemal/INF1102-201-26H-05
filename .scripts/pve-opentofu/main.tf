terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 2.9.0"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://10.7.237.16:8006/api2/json"
  pm_api_token_id = var.pm_token_id
  pm_api_token_secret = var.pm_token_secret
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "vm1" {
  name        = "tofu-vm01"
  target_node = "labinfo"
  clone       = "ubuntu-jammy-template"

  cores   = 2
  sockets = 1
  memory  = 2048

  scsihw = "virtio-scsi-pci"

  disk {
    size    = "20G"
    type    = "scsi"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  os_type = "cloud-init"

  ipconfig0 = "ip=dhcp"

  ciuser  = "ubuntu"
  sshkeys = file("~/.ssh/b300098957@ramena.pub")
}

