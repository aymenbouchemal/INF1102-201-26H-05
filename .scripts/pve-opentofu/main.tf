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

  # ipconfig0 = "ip=dhcp"
  ipconfig0 = "ip=10.7.237.193/23,gw=10.7.237.1"
  nameserver = "10.7.237.3"


  ciuser  = "ubuntu"
  sshkeys = <<EOF
   ${file("~/.ssh/github.com-setrar.pub")}
   ${file("~/.ssh/b300098957@ramena.pub")}
  EOF
  # sshkeys = file("~/.ssh/b300098957@ramena.pub")
}

