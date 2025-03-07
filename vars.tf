variable "ssh_key" {
  default = ""
}
variable "proxmox_host" {
  default = "tiim1"
}
variable "template_id" {
  default = "8000"
}

variable "virtual_environment_api_token" {
    default = ""
}

variable "proxmox_endpoint" {
    default = "https://192.168.111.161:8006/api2/json"
}