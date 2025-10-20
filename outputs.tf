output "vm_summary" {
  description = "List of created VMs"
  value = {
    for k, v in proxmox_vm_qemu.ubuntu24 :
    k => {
      vmid = v.vmid
      node = v.target_node
      name = v.name
    }
  }
}
