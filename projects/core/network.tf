# ---------------------------------------------------------------- Routers --- #

data "openstack_networking_router_v2" "ext-router" {
  name = "${var.project_name}-ext-router"
}


# --------------------------------------------------------------- Networks --- #

resource "openstack_networking_network_v2" "internal-network" {
  name           = "${var.project_name}-network"
  admin_state_up = "true"
  shared         = "false"
  external       = "false"

  tags = [
    "Created_by_terraform",
  ]
}

resource "openstack_networking_subnet_v2" "internal-network-subnet" {
  name            = "${var.project_name}-subnet-one"
  network_id      = openstack_networking_network_v2.internal-network.id
  cidr            = var.network_cidr
  ip_version      = 4
  gateway_ip      = cidrhost("${var.network_cidr}", 1)
  enable_dhcp     = "true"
  dns_nameservers = [cidrhost("${var.network_cidr}", 1)]

  allocation_pool {
    start = cidrhost("${var.network_cidr}", 2)
    end   = cidrhost("${var.network_cidr}", 254)
  }

  tags = [
    "Created_by_terraform",
  ]
}

resource "openstack_networking_router_interface_v2" "internal_router_interface" {
  router_id = data.openstack_networking_router_v2.ext-router.id
  subnet_id = openstack_networking_subnet_v2.internal-network-subnet.id
}
