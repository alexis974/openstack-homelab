# ----------------------------------------------------------------- Egress --- #

module "sg_egress_default" {
  source = "haxorof/security-group/openstack"

  name        = "sg_egress_default"
  description = "Allow all egress traffic"

  egress_rules = [
    {
      description = "Allow all egress traffic",
    },
  ]

  tags = [
    "Created_by_terraform",
  ]
}


# ------------------------------------------------------------------- ICMP --- #

module "sg_ingress_icmp" {
  source = "haxorof/security-group/openstack"

  name        = "sg_ingress_icmp"
  description = "Allow ICMP ingress traffic"

  ingress_rules_ipv4 = [
    {
      description = "ICMP for Ping",
      protocol    = "icmp",
      port        = 0,
    },
  ]

  tags = [
    "Created_by_terraform",
  ]
}


# ---------------------------------------------------------------- Bastion --- #

module "sg_ingress_bastion" {
  source = "haxorof/security-group/openstack"

  name        = "sg_ingress_bastion"
  description = "Allow SSH ingress traffic"

  ingress_rules = [
    {
      description = "Standard SSH Port",
      protocol    = "tcp",
      port        = 22,
    },
    {
      description = "Kubernetes apiserver",
      protocol    = "tcp",
      port        = 6443,
    },
  ]

  tags = [
    "Created_by_terraform",
  ]
}


# -------------------------------------------------------------------- SSH --- #

module "sg_ingress_ssh" {
  source = "haxorof/security-group/openstack"

  name        = "sg_ingress_ssh"
  description = "Allow SSH ingress traffic from within network only"

  ingress_rules_ipv4 = [
    {
      description      = "Standard SSH Port",
      protocol         = "tcp",
      port             = 22,
      remote_ip_prefix = var.network_cidr
    },
  ]

  tags = [
    "Created_by_terraform",
  ]
}


# ------------------------------------------------------------------- HTTP --- #

module "sg_ingress_http" {
  source = "haxorof/security-group/openstack"

  name        = "sg_ingress_http"
  description = "Allow HTTP ingress traffic"

  ingress_rules = [
    {
      description = "Standard HTTP Port",
      protocol    = "tcp",
      port        = 80,
    },
  ]

  tags = [
    "Created_by_terraform",
  ]
}


# ------------------------------------------------------------------ HTTPS --- #

module "sg_ingress_https" {
  source = "haxorof/security-group/openstack"

  name        = "sg_ingress_https"
  description = "Allow HTTP ingress traffic"

  ingress_rules = [
    {
      description = "Standard HTTPS Port",
      protocol    = "tcp",
      port        = 443,
    },
  ]

  tags = [
    "Created_by_terraform",
  ]
}


# -------------------------------------------------------------- Portainer --- #

module "sg_ingress_portainer" {
  source = "haxorof/security-group/openstack"

  name        = "sg_ingress_portainer"
  description = "Allow Portainer ingress traffic"

  ingress_rules = [
    {
      description = "Portainer 1",
      protocol    = "tcp",
      port        = 30779,
    },
    {
      description = "Portainer 1",
      protocol    = "tcp",
      port        = 30777,
    },
  ]

  tags = [
    "Created_by_terraform",
  ]
}
