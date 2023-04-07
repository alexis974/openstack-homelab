# ----------------------------------------------------------------- Locals --- #

locals {
  lb_floatingip = "192.168.30.191"

  listener_port_bastion = "22"
  listener_port_k8s     = "6443"

  port_bastion = "22"
  port_k8s     = "6443"

  default_timeout = 60
}


# ----------------------------------------------------------- LoadBalancer --- #

data "openstack_networking_floatingip_v2" "lb-floatip" {
  address = local.lb_floatingip
}

resource "openstack_lb_loadbalancer_v2" "lb" {
  name        = "${var.project_name}-lb"
  description = "Network Load Balancer"

  vip_subnet_id  = openstack_networking_subnet_v2.internal-network-subnet.id
  admin_state_up = true

  depends_on = [
    openstack_networking_subnet_v2.internal-network-subnet,
  ]
}

resource "openstack_networking_floatingip_associate_v2" "float_associate_lb" {
  floating_ip = data.openstack_networking_floatingip_v2.lb-floatip.address
  port_id     = openstack_lb_loadbalancer_v2.lb.vip_port_id
}


# ---------------------------------------------------------------- Bastion --- #

resource "openstack_lb_listener_v2" "lb_ssh_listener" {
  name                   = "${var.project_name}-lb_ssh_listener"
  description            = "Listener for bastion connection"
  loadbalancer_id        = openstack_lb_loadbalancer_v2.lb.id
  protocol               = "TCP"
  protocol_port          = local.listener_port_bastion
  timeout_client_data    = local.default_timeout * 60000 # min to ms
  timeout_member_data    = local.default_timeout * 60000 # min to ms
  timeout_member_connect = 1 * 60000                     # min to ms
}

resource "openstack_lb_pool_v2" "lb_ssh_pool" {
  name        = "${var.project_name}-lb_ssh_pool"
  description = "Pool for SSH connection"
  listener_id = openstack_lb_listener_v2.lb_ssh_listener.id
  protocol    = "TCP"
  lb_method   = "LEAST_CONNECTIONS"

  persistence {
    type = "SOURCE_IP"
  }
}

resource "openstack_lb_members_v2" "lb_ssh_members" {
  pool_id = openstack_lb_pool_v2.lb_ssh_pool.id

  member {
    name          = openstack_compute_instance_v2.bastion.name
    address       = openstack_compute_instance_v2.bastion.network[0].fixed_ip_v4
    protocol_port = local.port_bastion
  }
}


# -------------------------------------------------------------------- k8s --- #

resource "openstack_lb_listener_v2" "lb_k8s_listener" {
  name                   = "${var.project_name}-lb_k8s_listener"
  description            = "Listener for k8s connection"
  loadbalancer_id        = openstack_lb_loadbalancer_v2.lb.id
  protocol               = "TCP"
  protocol_port          = local.listener_port_k8s
  timeout_client_data    = local.default_timeout * 60000 # min to ms
  timeout_member_data    = local.default_timeout * 60000 # min to ms
  timeout_member_connect = 1 * 60000                     # min to ms
}

resource "openstack_lb_pool_v2" "lb_k8s_pool" {
  name        = "${var.project_name}-lb_k8s_pool"
  description = "Pool for k8s connection"
  listener_id = openstack_lb_listener_v2.lb_k8s_listener.id
  protocol    = "TCP"
  lb_method   = "LEAST_CONNECTIONS"

  persistence {
    type = "SOURCE_IP"
  }
}

resource "openstack_lb_members_v2" "lb_k8s_members-controllers" {
  pool_id = openstack_lb_pool_v2.lb_k8s_pool.id

  dynamic "member" {
    for_each = openstack_compute_instance_v2.k8s-controllers
    content {
      address       = member.value.network[0].fixed_ip_v4
      protocol_port = local.port_k8s
    }
  }

  depends_on = [
    openstack_compute_instance_v2.k8s-controllers,
  ]
}


# --------------------------------------------------------- Http and https --- #

resource "openstack_lb_listener_v2" "lb_http_listener" {
  name                   = "${var.project_name}-lb_http_listener"
  description            = "Listener for http connection"
  loadbalancer_id        = openstack_lb_loadbalancer_v2.lb.id
  protocol               = "TCP"
  protocol_port          = 80
  timeout_client_data    = local.default_timeout * 60000 # min to ms
  timeout_member_data    = local.default_timeout * 60000 # min to ms
  timeout_member_connect = 1 * 60000                     # min to ms
}

resource "openstack_lb_pool_v2" "lb_http_pool" {
  name        = "${var.project_name}-lb_http_pool"
  description = "Pool for htpp connection"
  listener_id = openstack_lb_listener_v2.lb_http_listener.id
  protocol    = "TCP"
  lb_method   = "ROUND_ROBIN"

  persistence {
    type = "SOURCE_IP"
  }
}

resource "openstack_lb_members_v2" "lb_http_members" {
  pool_id = openstack_lb_pool_v2.lb_http_pool.id

  dynamic "member" {
    for_each = openstack_compute_instance_v2.k8s-controllers
    content {
      address       = member.value.network[0].fixed_ip_v4
      protocol_port = 80
    }
  }

  dynamic "member" {
    for_each = openstack_compute_instance_v2.k8s-workers
    content {
      address       = member.value.network[0].fixed_ip_v4
      protocol_port = 80
    }
  }

  depends_on = [
    openstack_compute_instance_v2.k8s-controllers,
    openstack_compute_instance_v2.k8s-workers,
  ]
}

resource "openstack_lb_listener_v2" "lb_https_listener" {
  name                   = "${var.project_name}-lb_https_listener"
  description            = "Listener for https connection"
  loadbalancer_id        = openstack_lb_loadbalancer_v2.lb.id
  protocol               = "TCP"
  protocol_port          = 443
  timeout_client_data    = local.default_timeout * 60000 # min to ms
  timeout_member_data    = local.default_timeout * 60000 # min to ms
  timeout_member_connect = 1 * 60000                     # min to ms
}

resource "openstack_lb_pool_v2" "lb_https_pool" {
  name        = "${var.project_name}-lb_https_pool"
  description = "Pool for htpp connection"
  listener_id = openstack_lb_listener_v2.lb_https_listener.id
  protocol    = "TCP"
  lb_method   = "LEAST_CONNECTIONS"

  persistence {
    type = "SOURCE_IP"
  }
}

resource "openstack_lb_members_v2" "lb_https_members" {
  pool_id = openstack_lb_pool_v2.lb_https_pool.id

  dynamic "member" {
    for_each = openstack_compute_instance_v2.k8s-controllers
    content {
      address       = member.value.network[0].fixed_ip_v4
      protocol_port = 443
    }
  }

  dynamic "member" {
    for_each = openstack_compute_instance_v2.k8s-workers
    content {
      address       = member.value.network[0].fixed_ip_v4
      protocol_port = 443
    }
  }

  depends_on = [
    openstack_compute_instance_v2.k8s-controllers,
    openstack_compute_instance_v2.k8s-workers,
  ]
}
