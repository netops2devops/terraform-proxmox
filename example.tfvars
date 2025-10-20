pm_api_url          = "https://proxmox.example.com:8006/api2/json"
pm_api_token_id     = "terraform@pve!token-id"
pm_api_token_secret = "your-secret"

vms = {
  # dual stack VM with single interface
  "ubuntu24-1" = {
    target_node       = "pve1"
    bridge            = "vmbr0"
    vlan              = 10
    ipv4              = "192.168.100.101"
    prefix4           = 24
    gateway4          = "192.168.100.1"
    ipv6              = "fd00::101"
    prefix6           = 64
    gateway6          = "fd00::1"
    storage           = "local-lvm"
    disk_size         = "20G"
    cores             = 2
    memory            = 4096
    enable_second_nic = false
  }

  # Primary interface is IPv6 only
  # Secondary interface has no default route
  "ubuntu24-2" = {
    target_node       = "pve2"
    bridge            = "vmbr1"
    vlan              = 200
    ipv4              = null
    prefix4           = null
    gateway4          = null
    ipv6              = "2001:db8::a"
    prefix6           = 64
    gateway6          = "2001:db8::1"
    storage           = "local-lvm"
    disk_size         = "40G"
    cores             = 2
    memory            = 4096
    enable_second_nic = true
    bridge_2          = "vmbr0"
    vlan_2            = 300
    ipv4_2            = "10.10.10.10"
    prefix4_2         = 24
    gateway4_2        = null
    ipv6_2            = "fd00::a"
    prefix6_2         = 56
    gateway6_2        = null
  }
}
