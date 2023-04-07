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
    {
      description      = "Standard SSH Port",
      protocol         = "tcp",
      port             = 22,
      remote_ip_prefix = "192.168.0.0/16"
    },
  ]

  tags = [
    "Created_by_terraform",
  ]
}


# -------------------------------------------------------------------- SSH --- #

module "sg_ingress_ssh_external" {
  source = "haxorof/security-group/openstack"

  name        = "sg_ingress_ssh_external"
  description = "Allow SSH ingress traffic from every network"

  ingress_rules_ipv4 = [
    {
      description      = "Standard SSH Port",
      protocol         = "tcp",
      port             = 22,
      remote_ip_prefix = "0.0.0.0/0"
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


# ------------------------------------------------------------------ https --- #

module "sg_ingress_https" {
  source = "haxorof/security-group/openstack"

  name        = "sg_ingress_https"
  description = "allow http ingress traffic"

  ingress_rules = [
    {
      description = "standard https port",
      protocol    = "tcp",
      port        = 443,
    },
  ]

  tags = [
    "created_by_terraform",
  ]
}


# ---------------------------------------------------------------- Backend --- #

module "sg_ingress_backend" {
  source = "haxorof/security-group/openstack"

  name        = "sg_ingress_backend"
  description = "allow http ingress traffic"

  ingress_rules = [
    {
      description = "standard https port",
      protocol    = "tcp",
      port        = 3000,
    },
  ]

  tags = [
    "created_by_terraform",
  ]
}


# ------------------------------------------------------------------- Plex --- #

module "sg_ingress_plex" {
  source = "haxorof/security-group/openstack"

  name        = "sg_ingress_plex"
  description = "Allow Plex} ingress traffic"

  ingress_rules = [
    {
      description = "Standard Plex Port",
      protocol    = "tcp",
      port        = 32400,
    },
  ]

  tags = [
    "Created_by_terraform",
  ]
}
