# Homelab

This repository contains the majority of the configuration and scripts for my
home servers.

## Physical Nodes

- `archimedes`: A Supermicro X9SCM-F with an Intel Xeon CPU E31225 @ 3.10GHz
  and 32GB of ECC RAM that acts as an NFS and SMB fileserver for the data array.
- `pythagoras`: An Intel S2600GZ with an Intel Xeon CPU E5-2620 @ 2.00GHz
  and 64GB of ECC RAM running Proxmox.
- `euclid`: An Intel S2600GZ with an Intel Xeon CPU E5-2620 @ 2.00GHz and 64GB
  of ECC RAM running Proxmox.
- `coxeter`: An ASUS RAMPAGE V EDITION 10 with 64GB of non-ECC DDR4 RAM running
  Proxmox.
- `newton`: An M1 Mac Mini with 16GB of RAM running macOS 14.


## Configuration

### `ansible/`

Ansible playbooks and hosts for configuring `archimedes`, `pythagoras`, and
`euclid`.

### `cloud/`

Terraform code for public cloud resources that augment the homelab (things like
DNS, site-to-site VPN gateways, etc.)

### `containers/`

Dockerfiles for custom containers that aren't, for whatever reason, already on
Dockerhub.

### `scripts/`

A collection of random scripts useful when administering the lab.

### `stacks/`

Docker Swarm stacks for all the different applications running on the Swarm.
