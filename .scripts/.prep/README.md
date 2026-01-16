Below is a **minimal, practical guide** to launching a **Linux VM on Proxmox using OpenTofu** (Terraform-compatible).

I’ll assume:

* You already have **Proxmox VE running**
* You have an **API token** (user@realm!token)
* You want to clone from a **Linux cloud-init template** (Ubuntu/Debian/etc.)

---

## 1️⃣ Prerequisites on Proxmox

### A. Create a Linux cloud-init template (once)

Example (Ubuntu 22.04):

```bash
# Download cloud image
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img

# Create VM
qm create 9000 --name ubuntu-jammy-template --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0

# Import disk
qm importdisk 9000 jammy-server-cloudimg-amd64.img local-lvm

# Attach disk
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0

# Cloud-init disk
qm set 9000 --ide2 local-lvm:cloudinit

# Boot settings
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --serial0 socket --vga serial0

# Convert to template
qm template 9000
```

---

## 2️⃣ Install OpenTofu

```bash
brew install opentofu        # macOS
# or
sudo snap install opentofu   # Linux
```

Verify:

```bash
tofu version
```

---

## 3️⃣ Provider Configuration (`provider.tf`)

```hcl
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.47"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://proxmox.example.com:8006/api2/json"
  api_token = var.proxmox_api_token
  insecure  = true
}
```

---

## 4️⃣ Variables (`variables.tf`)

```hcl
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
```

---

## 5️⃣ Linux VM Definition (`vm.tf`)

```hcl
resource "proxmox_virtual_environment_vm" "linux_vm" {
  name      = "linux-vm-01"
  node_name = var.node_name

  clone {
    vm_id = 9000 # template ID
  }

  agent {
    enabled = true
  }

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 2048
  }

  disk {
    interface = "scsi0"
    size      = 20
  }

  network_device {
    bridge = "vmbr0"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = var.vm_user
      keys     = [var.ssh_public_key]
    }
  }
}
```

---

## 6️⃣ Secrets (`terraform.tfvars`)

```hcl
proxmox_api_token = "root@pam!tofu=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
ssh_public_key    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI..."
```

---

## 7️⃣ Launch the VM 🚀

```bash
tofu init
tofu plan
tofu apply
```

After ~30 seconds, the VM will:

* Be cloned from the template
* Boot automatically
* Get DHCP IP
* Allow SSH via your key

---

## 8️⃣ Verify

```bash
ssh ubuntu@<vm-ip>
```

or check in Proxmox UI:

```
Datacenter → Node → VM → Console
```

---

## 🧠 Common Gotchas

| Issue              | Fix                                                                   |
| ------------------ | --------------------------------------------------------------------- |
| VM boots but no IP | Cloud-init disk missing                                               |
| SSH not working    | SSH key format wrong                                                  |
| Clone fails        | Template must be **stopped**                                          |
| Permissions error  | Token role needs `VM.Allocate`, `VM.Clone`, `Datastore.AllocateSpace` |

---

## 9️⃣ Want more?

I can show you:

* 🔁 Multiple VMs with `for_each`
* 🌐 Static IP configuration
* 📦 Ansible + OpenTofu combo
* 🧩 OpenTofu module layout
* 🛡️ Least-privilege Proxmox roles

Just tell me what you want next.

