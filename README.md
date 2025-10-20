# Terraforming VMs on Proxmox

Simple terraform configuration to deploy `cloud-init` based Ubuntu VMs on Proxmox for my k8s labs.

- Clones `ubuntu-cloud-init-template` (id: 9000)
- Can add multiple network interfaces to a VM. Adds a 2nd NIC if `enable_second_nic = true`
- Handle network config for IPv4 only, IPv6 only or Dual stack setups
- Inject SSH key and DNS servers
- Generate an output of all created VMs
