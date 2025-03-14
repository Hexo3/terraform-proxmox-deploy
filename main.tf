
provider "proxmox" {
  endpoint = var.proxmox_endpoint
  # api_token = var.virtual_environment_api_token
  username = "root@pam"
  password = var.proxmox_password
  insecure = true
}

resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.proxmox_host

  url = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

resource "proxmox_virtual_environment_vm" "ubuntu" {
  count = 1
  name      = "test-0${count.index + 1}"
  node_name = var.proxmox_host

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
    datastore_id = "local-lvm"
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

