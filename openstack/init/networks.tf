# --------------------------------------------------------------- Networks --- #

resource "openstack_networking_network_v2" "network_external" {
  name           = "ext-net"
  admin_state_up = "true"
  external       = "true"
  shared         = "false"
  segments {
    physical_network = "physnet1"
    network_type     = "flat"
  }
}

resource "openstack_networking_subnet_v2" "subnet_external_network" {
  name            = "ext-net-subnet"
  network_id      = openstack_networking_network_v2.network_external.id
  cidr            = var.ext_net_cidr
  ip_version      = 4
  gateway_ip      = cidrhost("${var.ext_net_cidr}", 1)
  enable_dhcp     = false
  dns_nameservers = [cidrhost("${var.ext_net_cidr}", 1)]

  allocation_pool {
    start = cidrhost("${var.ext_net_cidr}", 80)
    end   = cidrhost("${var.ext_net_cidr}", 240)
  }
}


# ------------------------------------------------------------------- RBAC --- #

data "openstack_identity_project_v3" "admin_project" {
  name = "admin"
}

resource "openstack_networking_rbac_policy_v2" "rbac_policy_ext_net" {
  action        = "access_as_external"
  object_id     = openstack_networking_network_v2.network_external.id
  object_type   = "network"
  target_tenant = data.openstack_identity_project_v3.admin_project.id
}

data "openstack_networking_network_v2" "lb-mgmt-net" {
  name = "lb-mgmt-net"
}

resource "openstack_networking_rbac_policy_v2" "lb-mgmt-net_rbac_policy" {
  action        = "access_as_external"
  object_id     = data.openstack_networking_network_v2.lb-mgmt-net.id
  object_type   = "network"
  target_tenant = data.openstack_identity_project_v3.admin_project.id
}
