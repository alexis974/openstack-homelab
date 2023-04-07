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

data "openstack_images_image_v2" "ubuntu_22_04_2022" {
  name        = "ubuntu-22.04-2022"
  most_recent = true
}


# ------------------------------------------------------------------- Mail --- #

resource "openstack_compute_instance_v2" "mail" {
  name        = "${var.project_name}-mail"
  flavor_name = "m1.large"
  user_data   = local.user_data_ssh_keys

  security_groups = [
    module.sg_egress_default.security_group_name,
    module.sg_ingress_icmp.security_group_name,
    module.sg_ingress_ssh.security_group_name,
    module.sg_ingress_mailcow.security_group_name,
  ]

  network {
    name = openstack_networking_network_v2.internal-network.name
  }

  block_device {
    uuid                  = data.openstack_images_image_v2.ubuntu_22_04_2022.id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = 50
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

data "openstack_networking_floatingip_v2" "mail" {
  address = "192.168.30.104"
}

resource "openstack_compute_floatingip_associate_v2" "mail" {
  floating_ip = data.openstack_networking_floatingip_v2.mail.address
  instance_id = openstack_compute_instance_v2.mail.id
}


# ------------------------------------------------------------------ Gatus --- #

resource "openstack_compute_instance_v2" "gatus" {
  name        = "${var.project_name}-gatus"
  flavor_name = "m1.tiny"
  user_data   = local.user_data_ssh_keys

  security_groups = [
    module.sg_egress_default.security_group_name,
    module.sg_ingress_icmp.security_group_name,
    module.sg_ingress_ssh.security_group_name,
    module.sg_ingress_http.security_group_name,
    module.sg_ingress_https.security_group_name,
  ]

  network {
    name = openstack_networking_network_v2.internal-network.name
  }

  block_device {
    uuid                  = data.openstack_images_image_v2.ubuntu_22_04_2022.id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = 10
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

data "openstack_networking_floatingip_v2" "gatus" {
  address = "192.168.30.109"
}

resource "openstack_compute_floatingip_associate_v2" "gatus" {
  floating_ip = data.openstack_networking_floatingip_v2.gatus.address
  instance_id = openstack_compute_instance_v2.gatus.id
}


# -------------------------------------------------------------- Minecraft --- #

resource "openstack_compute_instance_v2" "minecraft" {
  name        = "${var.project_name}-minecraft"
  flavor_name = "mc.large"
  user_data   = local.user_data_ssh_keys

  security_groups = [
    module.sg_egress_default.security_group_name,
    module.sg_ingress_icmp.security_group_name,
    module.sg_ingress_ssh.security_group_name,
    module.sg_ingress_minecraft.security_group_name,
  ]

  network {
    name = openstack_networking_network_v2.internal-network.name
  }

  block_device {
    uuid                  = data.openstack_images_image_v2.ubuntu.id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = 50
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

data "openstack_networking_floatingip_v2" "minecraft" {
  address = "192.168.30.105"
}

resource "openstack_compute_floatingip_associate_v2" "minecraft" {
  floating_ip = data.openstack_networking_floatingip_v2.minecraft.address
  instance_id = openstack_compute_instance_v2.minecraft.id
}


# ------------------------------------------------------------------ Nginx --- #

resource "openstack_compute_instance_v2" "reverse-proxy" {
  name        = "${var.project_name}-reverse-proxy"
  flavor_name = "m1.tiny"
  user_data   = local.user_data_ssh_keys

  security_groups = [
    module.sg_egress_default.security_group_name,
    module.sg_ingress_icmp.security_group_name,
    module.sg_ingress_ssh.security_group_name,
    module.sg_ingress_ssh_external.security_group_name,
    module.sg_ingress_http.security_group_name,
    module.sg_ingress_https.security_group_name,
  ]

  network {
    name = openstack_networking_network_v2.internal-network.name
  }

  block_device {
    uuid                  = data.openstack_images_image_v2.ubuntu_22_04_2022.id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = 10
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

data "openstack_networking_floatingip_v2" "reverse-proxy" {
  address = "192.168.30.101"
}

resource "openstack_compute_floatingip_associate_v2" "reverse-proxy" {
  floating_ip = data.openstack_networking_floatingip_v2.reverse-proxy.address
  instance_id = openstack_compute_instance_v2.reverse-proxy.id
}