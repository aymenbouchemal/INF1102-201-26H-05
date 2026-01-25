

```terraform
tofu apply

OpenTofu used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  + create

OpenTofu will perform the following actions:

  # proxmox_vm_qemu.vm1 will be created
  + resource "proxmox_vm_qemu" "vm1" {
      + additional_wait           = 5
      + automatic_reboot          = true
      + balloon                   = 0
      + bios                      = "seabios"
      + boot                      = (known after apply)
      + bootdisk                  = (known after apply)
      + ciuser                    = "ubuntu"
      + clone                     = "ubuntu-jammy-template"
      + clone_wait                = 10
      + cores                     = 2
      + cpu                       = "host"
      + default_ipv4_address      = (known after apply)
      + define_connection_info    = true
      + force_create              = false
      + full_clone                = true
      + guest_agent_ready_timeout = 100
      + hotplug                   = "network,disk,usb"
      + id                        = (known after apply)
      + ipconfig0                 = "ip=dhcp"
      + kvm                       = true
      + memory                    = 2048
      + name                      = "tofu-vm01"
      + nameserver                = (known after apply)
      + onboot                    = false
      + oncreate                  = true
      + os_type                   = "cloud-init"
      + preprovision              = true
      + reboot_required           = (known after apply)
      + scsihw                    = "virtio-scsi-pci"
      + searchdomain              = (known after apply)
      + sockets                   = 1
      + ssh_host                  = (known after apply)
      + ssh_port                  = (known after apply)
      + sshkeys                   = <<-EOT
            ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD2pLhMqFGKffSdYvNCMAyM7598oBY+m/3q5AMXmb7IE6vq42+yGzqEUzZu9WrFckFD4Hq52rIU5DeOvi83DCF3uroXjNTEtCKdi+tY7cV18bHmsDsBHMqTnpuvroofgFWA0Pi++b2kGW2I5eyy1Qjv5rOp7y11Xe6XeZFEz7qQO1/xNiBMJEruG9Xldgooe4hkaOF39qnbqD4ui3LxYaTUTEulstw4wN70dSB8Zu9YQP7A7KU2zIEwJ1aw8whfO1CAM/AVvoDyqMtV8VXoaZSHOBgluMtinQfyyt473S2ZZeJlnmhK0F1gdOhO4SVZNRMj96m30ryYkYBFWvvLRP5N b300098957@ramena
        EOT
      + tablet                    = true
      + target_node               = "labinfo"
      + unused_disk               = (known after apply)
      + vcpus                     = 0
      + vlan                      = -1
      + vmid                      = (known after apply)

      + disk {
          + backup             = true
          + cache              = "none"
          + file               = (known after apply)
          + format             = (known after apply)
          + iops               = 0
          + iops_max           = 0
          + iops_max_length    = 0
          + iops_rd            = 0
          + iops_rd_max        = 0
          + iops_rd_max_length = 0
          + iops_wr            = 0
          + iops_wr_max        = 0
          + iops_wr_max_length = 0
          + iothread           = 0
          + mbps               = 0
          + mbps_rd            = 0
          + mbps_rd_max        = 0
          + mbps_wr            = 0
          + mbps_wr_max        = 0
          + media              = (known after apply)
          + replicate          = 0
          + size               = "20G"
          + slot               = (known after apply)
          + ssd                = 0
          + storage            = "local-lvm"
          + storage_type       = (known after apply)
          + type               = "scsi"
          + volume             = (known after apply)
        }

      + network {
          + bridge    = "vmbr0"
          + firewall  = false
          + link_down = false
          + macaddr   = (known after apply)
          + model     = "virtio"
          + queues    = (known after apply)
          + rate      = (known after apply)
          + tag       = -1
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  OpenTofu will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

proxmox_vm_qemu.vm1: Creating...
proxmox_vm_qemu.vm1: Still creating... [10s elapsed]
proxmox_vm_qemu.vm1: Still creating... [20s elapsed]
proxmox_vm_qemu.vm1: Still creating... [30s elapsed]
proxmox_vm_qemu.vm1: Still creating... [40s elapsed]
proxmox_vm_qemu.vm1: Still creating... [50s elapsed]
proxmox_vm_qemu.vm1: Still creating... [1m0s elapsed]
proxmox_vm_qemu.vm1: Still creating... [1m10s elapsed]
proxmox_vm_qemu.vm1: Still creating... [1m20s elapsed]
proxmox_vm_qemu.vm1: Still creating... [1m30s elapsed]
proxmox_vm_qemu.vm1: Still creating... [1m40s elapsed]
proxmox_vm_qemu.vm1: Still creating... [1m50s elapsed]
proxmox_vm_qemu.vm1: Still creating... [2m0s elapsed]
proxmox_vm_qemu.vm1: Still creating... [2m10s elapsed]
proxmox_vm_qemu.vm1: Still creating... [2m20s elapsed]
proxmox_vm_qemu.vm1: Still creating... [2m30s elapsed]
proxmox_vm_qemu.vm1: Still creating... [2m40s elapsed]
proxmox_vm_qemu.vm1: Still creating... [2m50s elapsed]
proxmox_vm_qemu.vm1: Still creating... [3m0s elapsed]
proxmox_vm_qemu.vm1: Still creating... [3m10s elapsed]
proxmox_vm_qemu.vm1: Still creating... [3m20s elapsed]
proxmox_vm_qemu.vm1: Still creating... [3m30s elapsed]
proxmox_vm_qemu.vm1: Still creating... [3m40s elapsed]
proxmox_vm_qemu.vm1: Still creating... [3m50s elapsed]
proxmox_vm_qemu.vm1: Still creating... [4m0s elapsed]
proxmox_vm_qemu.vm1: Still creating... [4m10s elapsed]
proxmox_vm_qemu.vm1: Still creating... [4m20s elapsed]
proxmox_vm_qemu.vm1: Still creating... [4m30s elapsed]
proxmox_vm_qemu.vm1: Still creating... [4m41s elapsed]
proxmox_vm_qemu.vm1: Still creating... [4m51s elapsed]
proxmox_vm_qemu.vm1: Still creating... [5m1s elapsed]
proxmox_vm_qemu.vm1: Still creating... [5m11s elapsed]
proxmox_vm_qemu.vm1: Still creating... [5m21s elapsed]
proxmox_vm_qemu.vm1: Still creating... [5m31s elapsed]
proxmox_vm_qemu.vm1: Still creating... [5m41s elapsed]
proxmox_vm_qemu.vm1: Still creating... [5m51s elapsed]
proxmox_vm_qemu.vm1: Still creating... [6m1s elapsed]
proxmox_vm_qemu.vm1: Still creating... [6m11s elapsed]
proxmox_vm_qemu.vm1: Still creating... [6m21s elapsed]
proxmox_vm_qemu.vm1: Still creating... [6m31s elapsed]
proxmox_vm_qemu.vm1: Still creating... [6m41s elapsed]
proxmox_vm_qemu.vm1: Still creating... [6m51s elapsed]
proxmox_vm_qemu.vm1: Still creating... [7m1s elapsed]
proxmox_vm_qemu.vm1: Still creating... [7m11s elapsed]
proxmox_vm_qemu.vm1: Still creating... [7m21s elapsed]
proxmox_vm_qemu.vm1: Still creating... [7m31s elapsed]
proxmox_vm_qemu.vm1: Still creating... [7m41s elapsed]
proxmox_vm_qemu.vm1: Still creating... [7m51s elapsed]
proxmox_vm_qemu.vm1: Still creating... [8m1s elapsed]
proxmox_vm_qemu.vm1: Still creating... [8m11s elapsed]
proxmox_vm_qemu.vm1: Still creating... [8m21s elapsed]
proxmox_vm_qemu.vm1: Still creating... [8m31s elapsed]
proxmox_vm_qemu.vm1: Still creating... [8m41s elapsed]
proxmox_vm_qemu.vm1: Still creating... [8m51s elapsed]
proxmox_vm_qemu.vm1: Still creating... [9m1s elapsed]
proxmox_vm_qemu.vm1: Still creating... [9m11s elapsed]
proxmox_vm_qemu.vm1: Still creating... [9m21s elapsed]
proxmox_vm_qemu.vm1: Still creating... [9m31s elapsed]
proxmox_vm_qemu.vm1: Still creating... [9m41s elapsed]
proxmox_vm_qemu.vm1: Still creating... [9m51s elapsed]
proxmox_vm_qemu.vm1: Still creating... [10m1s elapsed]
proxmox_vm_qemu.vm1: Still creating... [10m11s elapsed]
proxmox_vm_qemu.vm1: Still creating... [10m21s elapsed]
proxmox_vm_qemu.vm1: Still creating... [10m31s elapsed]
proxmox_vm_qemu.vm1: Creation complete after 10m36s [id=labinfo/qemu/100]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```
