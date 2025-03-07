
provider "proxmox" {
  endpoint          = var.proxmox_endpoint
  api_token = var.virtual_environment_api_token
  insecure = true
}
resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  count = 1
  name      = "test-0${count.index + 1}"
  node_name = var.proxmox_host

  # clone {
  #   vm_id = var.template_id
  # }

  initialization {
    dns {
      servers = ["1.1.1.1"]
    }
    ip_config {
      ipv4 {
        address = "192.168.111.16${1 + count.index + 1}/24"
        gateway = "192.168.111.1"
      }
    }

    user_account {
      username = "ubuntu"
      keys     = [var.ssh_key]
    }
  }

  disk {
    datastore_id = "local"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  network_device {
    bridge = "vmbr0"
  }
}

resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.proxmox_host

  url = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}