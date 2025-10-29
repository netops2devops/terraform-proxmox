terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc05"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = var.pm_tls_insecure
}

resource "proxmox_vm_qemu" "ubuntu24" {
  for_each = var.vms

  name        = each.key
  target_node = each.value.target_node
  clone       = var.template_vm
  full_clone  = true
  agent       = 0
  onboot      = true
  scsihw      = "virtio-scsi-pci"
  os_type     = "cloud-init"
  qemu_os     = "l26"
  memory      = each.value.memory

  # --- CPU ---
  cpu {
    cores   = each.value.cores
    sockets = 1
  }

  # --- Storage ---
  disks {
    scsi {
      scsi0 {
        disk {
          storage = var.disk_storage
          size    = "32G"
        }
      }
    }
    ide {
      ide2 {
        cloudinit {
          storage = var.cloud_init_storage
        }
      }
    }
  }

  # --- Primary NIC ---
  network {
    id     = 0
    model  = "virtio"
    bridge = each.value.bridge
    tag    = each.value.vlan
  }

  # --- Optional Secondary NIC ---
  dynamic "network" {
    for_each = each.value.enable_second_nic ? [each.value] : []
    content {
      id     = 1
      model  = "virtio"
      bridge = each.value.bridge_2
      tag    = each.value.vlan_2
    }
  }

  # --- Cloud-init network config ---
  nameserver = var.nameserver

  # Construct ipconfig strings for Cloud-Init
  # Set IPv4 values = null in tfvars to create IPv6 only VMs
  ipconfig0 = join(",", compact([
    each.value.ipv4 != null ? "ip=${each.value.ipv4}/${each.value.prefix4}" : null,
    each.value.gateway4 != null ? "gw=${each.value.gateway4}" : null,
    each.value.ipv6 != null ? "ip6=${each.value.ipv6}/${each.value.prefix6}" : null,
    each.value.gateway6 != null ? "gw6=${each.value.gateway6}" : null,
  ]))

  ipconfig1 = each.value.enable_second_nic ? join(",", compact([
    each.value.ipv4_2 != null ? "ip=${each.value.ipv4_2}/${each.value.prefix4_2}" : null,
    each.value.gateway4_2 != null ? "gw=${each.value.gateway4_2}" : null,
    each.value.ipv6_2 != null ? "ip6=${each.value.ipv6_2}/${each.value.prefix6_2}" : null,
    each.value.gateway6_2 != null ? "gw6=${each.value.gateway6_2}" : null,

  ])) : null

  # --- User Account ---
  ciuser     = var.ciuser
  cipassword = var.cipassword
  sshkeys    = file(var.ssh_key_path)

  lifecycle {
    ignore_changes = [
      network,
      disk,
    ]
  }
}
