# ------------------------------------------------------------------- Data --- #

data "openstack_networking_network_v2" "ext_net" {
  name = var.ext_net_name
}

data "openstack_networking_subnet_v2" "ext_net_subet" {
  name = var.ext_net_subnet_name
}


# ----------------------------------------------------------------- Router --- #

resource "openstack_networking_router_v2" "router_external" {
  name                = "${var.project_name}-ext-router"
  admin_state_up      = true
  tenant_id           = openstack_identity_project_v3.project.id
  external_network_id = data.openstack_networking_network_v2.ext_net.id
  enable_snat         = true
  external_fixed_ip {
    subnet_id  = data.openstack_networking_subnet_v2.ext_net_subet.id
    ip_address = cidrhost("${var.ext_net_cidr}", 190)
  }
}


# ------------------------------------------------------------ Floating IP --- #

resource "openstack_networking_floatingip_v2" "floatingip" {
  for_each = toset([
    cidrhost("${var.ext_net_cidr}", 191),
    cidrhost("${var.ext_net_cidr}", 192),
    cidrhost("${var.ext_net_cidr}", 193),
    cidrhost("${var.ext_net_cidr}", 194),
    cidrhost("${var.ext_net_cidr}", 195),
    cidrhost("${var.ext_net_cidr}", 196),
    cidrhost("${var.ext_net_cidr}", 197),
    cidrhost("${var.ext_net_cidr}", 198),
    cidrhost("${var.ext_net_cidr}", 199),
  ])

  pool      = var.ext_net_name
  subnet_id = data.openstack_networking_subnet_v2.ext_net_subet.id
  address   = each.value
  tenant_id = openstack_identity_project_v3.project.id
}
