# ----------------------------------------------------------------- Locals --- #

locals {
  user_data_ssh_keys = <<EOF
#cloud-config

ssh_authorized_keys:
  - ${openstack_compute_keypair_v2.kp_alexis_boissiere.public_key}
EOF

  user_data_cluster = templatefile("${path.module}/cloud-init.yml.tftpl", { user_data_ssh_keys = local.user_data_ssh_keys })
}

# ----------------------------------------------------- Availability zones --- #

data "openstack_compute_availability_zones_v2" "zones" {}


# ------------------------------------------------------------------ Image --- #

data "openstack_images_image_v2" "ubuntu" {
  name        = "ubuntu-20.04-2022"
  most_recent = true
}


# ---------------------------------------------------------------- Bastion --- #

resource "openstack_compute_instance_v2" "bastion" {
  name        = "${var.project_name}-bastion"
  flavor_name = "m1.tiny"
  user_data   = local.user_data_ssh_keys

  security_groups = [
    module.sg_egress_default.security_group_name,
    module.sg_ingress_icmp.security_group_name,
    module.sg_ingress_bastion.security_group_name,
  ]

  network {
    name        = openstack_networking_network_v2.internal-network.name
    fixed_ip_v4 = cidrhost("${var.network_cidr}", 4)
  }

  block_device {
    uuid                  = data.openstack_images_image_v2.ubuntu.id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = 5
    delete_on_termination = "true"
  }

  depends_on = [
    openstack_networking_subnet_v2.internal-network-subnet,
    openstack_networking_router_interface_v2.internal_router_interface,
  ]

  lifecycle {
    ignore_changes = [
      user_data,
    ]
  }

  tags = [
    "Created_by_terraform",
  ]
}


# --------------------------------------------------------- k8s Controller --- #

resource "openstack_compute_instance_v2" "k8s-controllers" {
  count       = var.controller_number
  name        = "${var.project_name}-controller-${count.index}"
  flavor_name = var.controller_flavor
  user_data   = local.user_data_cluster

  security_groups = [
    module.sg_egress_default.security_group_name,
    module.sg_ingress_icmp.security_group_name,
    module.sg_ingress_ssh.security_group_name,
    module.sg_k8s_rke_node.security_group_name,
    module.sg_k8s_etcd_nodes.security_group_name,
    module.sg_k8s_controlplane_nodes.security_group_name,
  ]

  network {
    name        = openstack_networking_network_v2.internal-network.name
    fixed_ip_v4 = cidrhost("${var.network_cidr}", 31 + count.index)
  }

  availability_zone = data.openstack_compute_availability_zones_v2.zones.names[
    (count.index) % length(data.openstack_compute_availability_zones_v2.zones.names)
  ]

  block_device {
    uuid                  = data.openstack_images_image_v2.ubuntu.id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = var.controller_volume_size
    delete_on_termination = "true"
  }

  depends_on = [
    openstack_networking_subnet_v2.internal-network-subnet,
    openstack_networking_router_interface_v2.internal_router_interface,
  ]

  lifecycle {
    ignore_changes = [
      user_data,
    ]
  }

  tags = [
    "Created_by_terraform",
  ]
}


# ------------------------------------------------------------- k8s Worker --- #

resource "openstack_compute_instance_v2" "k8s-workers" {
  count       = var.worker_number
  name        = "${var.project_name}-worker-${count.index}"
  flavor_name = var.worker_flavor
  user_data   = local.user_data_cluster

  security_groups = [
    module.sg_egress_default.security_group_name,
    module.sg_ingress_icmp.security_group_name,
    module.sg_ingress_ssh.security_group_name,
    module.sg_k8s_rke_node.security_group_name,
    module.sg_k8s_worker_nodes.security_group_name,
    module.sg_ingress_portainer.security_group_name,
  ]

  network {
    name        = openstack_networking_network_v2.internal-network.name
    fixed_ip_v4 = cidrhost("${var.network_cidr}", 51 + count.index)
  }

  availability_zone = data.openstack_compute_availability_zones_v2.zones.names[
    (var.controller_number + count.index) % length(data.openstack_compute_availability_zones_v2.zones.names)
  ]

  block_device {
    uuid                  = data.openstack_images_image_v2.ubuntu.id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = var.worker_volume_size
    delete_on_termination = "true"
  }

  depends_on = [
    openstack_networking_subnet_v2.internal-network-subnet,
    openstack_networking_router_interface_v2.internal_router_interface,
  ]

  lifecycle {
    ignore_changes = [
      user_data,
    ]
  }

  tags = [
    "Created_by_terraform",
  ]
}
