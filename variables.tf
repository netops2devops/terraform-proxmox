variable "pm_api_url" {}
variable "pm_api_token_id" {}
variable "pm_api_token_secret" {}
variable "pm_tls_insecure" {
  default = true
}

variable "template_vm" {
  default = "ubuntu-cloud-init-template"
}

variable "ciuser" {
  default = "ubuntu"
}

variable "cipassword" {
  default = "ubuntu"
}

variable "ssh_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

# Cloudflare DNS64
variable "nameserver" {
  default = "2606:4700:4700::64"
}

variable "vms" {
  description = "Map of VM configurations"
  type = map(object({
    target_node       = string
    bridge            = string
    vlan              = number
    ipv4              = string
    prefix4           = number
    gateway4          = string
    ipv6              = string
    prefix6           = number
    gateway6          = string
    storage           = string
    disk_size         = string
    cores             = number
    memory            = number
    enable_second_nic = bool
    bridge_2          = optional(string)
    vlan_2            = optional(number)
    ipv4_2            = optional(string)
    prefix4_2         = optional(number)
    gateway4_2        = optional(string)
    ipv6_2            = optional(string)
    prefix6_2         = optional(number)
    gateway6_2        = optional(string)
  }))
}
