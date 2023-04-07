# ----------------------------------------------------------- K8S RKE Node --- #

module "sg_k8s_rke_node" {
  source = "haxorof/security-group/openstack"

  name        = "sg_k8s_rke_node"
  description = "Allow traffic for RKE node"

  ingress_rules_ipv4 = []

  egress_rules_ipv4 = [
    {
      description      = "SSH provisioning of node by RKE",
      protocol         = "tcp",
      port             = 22,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Kubernetes apiserver",
      protocol         = "tcp",
      port             = 6443,
      remote_ip_prefix = var.network_cidr
    },
  ]

  tags = [
    "Created_by_terraform",
  ]
}


# ---------------------------------------------------------- K8S etcd nodes--- #

module "sg_k8s_etcd_nodes" {
  source = "haxorof/security-group/openstack"

  name        = "sg_k8s_etcd_nodes"
  description = "Allow traffic for etcd nodes"

  ingress_rules_ipv4 = [
    {
      description      = "Docker daemon TLS port used by Docker Machine",
      protocol         = "tcp",
      port             = 2376,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "etcd client requests",
      protocol         = "tcp",
      port             = 2379,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "etcd peer comunication",
      protocol         = "tcp",
      port             = 2380,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Canal/Flannel VXLAN overlay networking",
      protocol         = "udp",
      port             = 8472,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Canal/Flannel livenessProbe/readinessProbe",
      protocol         = "tcp",
      port             = 9099,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "kubelet",
      protocol         = "tcp",
      port             = 10250,
      remote_ip_prefix = var.network_cidr
    },
  ]

  egress_rules_ipv4 = [
    {
      description      = "Rancher agent",
      protocol         = "tcp",
      port             = 443,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "etcd client requests",
      protocol         = "tcp",
      port             = 2379,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "etcd peer communication",
      protocol         = "tcp",
      port             = 2380,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Kubernetes apiserver",
      protocol         = "tcp",
      port             = 6443,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Canal/Flannel VXLAN overlay networking",
      protocol         = "udp",
      port             = 8472,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Canal/Flannel livenessProbe/readinessProbe",
      protocol         = "tcp",
      port             = 9099,
      remote_ip_prefix = var.network_cidr
    },
  ]

  tags = [
    "Created_by_terraform",
  ]
}


# ------------------------------------------------- K8S Controlplane nodes --- #

module "sg_k8s_controlplane_nodes" {
  source = "haxorof/security-group/openstack"

  name        = "sg_k8s_controlplane_nodes"
  description = "Allow traffic for controlplane nodes"

  ingress_rules_ipv4 = [
    {
      description      = "Ingress controller (HTTP)",
      protocol         = "tcp",
      port             = 80,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Ingress controller (HTTPS)",
      protocol         = "tcp",
      port             = 443,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Docker daemon TLS port used by Docker Machine",
      protocol         = "tcp",
      port             = 2376,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Kubernetes apiserver",
      protocol         = "tcp",
      port             = 6443,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Canal/Flannel VXLAN overlay networking",
      protocol         = "udp",
      port             = 8472,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Canal/Flannel livenessProbe/readinessProbe",
      protocol         = "tcp",
      port             = 9099,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "kubelet",
      protocol         = "tcp",
      port             = 10250,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Ingress controller - livenessProbe/readinessProbe",
      protocol         = "tcp",
      port             = 10254,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "NodePort port range TCP",
      protocol         = "tcp",
      port_range_min   = 30000,
      port_range_max   = 32767,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "NodePort port range UDP",
      protocol         = "udp",
      port_range_min   = 30000,
      port_range_max   = 32767,
      remote_ip_prefix = var.network_cidr
    },
  ]

  egress_rules_ipv4 = [
    {
      description      = "Rancher agent",
      protocol         = "tcp",
      port             = 443,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "etcd client requests",
      protocol         = "tcp",
      port             = 2379,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "etcd peer communication",
      protocol         = "tcp",
      port             = 2380,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Canal/Flannel VXLAN overlay networking",
      protocol         = "udp",
      port             = 8472,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Canal/Flannel livenessProbe/readinessProbe",
      protocol         = "tcp",
      port             = 9099,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "kubelet",
      protocol         = "tcp",
      port             = 10250,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Ingress controller - livenessProbe/readinessProbe",
      protocol         = "tcp",
      port             = 10254,
      remote_ip_prefix = var.network_cidr
    },
  ]

  tags = [
    "Created_by_terraform",
  ]
}


# ------------------------------------------------- K8S Worker nodes --- #

module "sg_k8s_worker_nodes" {
  source = "haxorof/security-group/openstack"

  name        = "sg_k8s_worker_nodes"
  description = "Allow traffic for worker nodes"

  ingress_rules_ipv4 = [
    {
      description      = "Remote access over SSH",
      protocol         = "tcp",
      port             = 22,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Ingress controller (HTTP)",
      protocol         = "tcp",
      port             = 80,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Ingress controller (HTTPS)",
      protocol         = "tcp",
      port             = 443,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Docker daemon TLS port used by Docker Machine",
      protocol         = "tcp",
      port             = 2376,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Canal/Flannel VXLAN overlay networking",
      protocol         = "udp",
      port             = 8472,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Canal/Flannel livenessProbe/readinessProbe",
      protocol         = "tcp",
      port             = 9099,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "kubelet",
      protocol         = "tcp",
      port             = 10250,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Ingress controller - livenessProbe/readinessProbe",
      protocol         = "tcp",
      port             = 10254,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "NodePort port range TCP",
      protocol         = "tcp",
      port_range_min   = 30000,
      port_range_max   = 32767,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "NodePort port range UDP",
      protocol         = "udp",
      port_range_min   = 30000,
      port_range_max   = 32767,
      remote_ip_prefix = var.network_cidr
    },
  ]

  egress_rules_ipv4 = [
    {
      description      = "Rancher agent",
      protocol         = "tcp",
      port             = 443,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Kubernetes apiserver",
      protocol         = "tcp",
      port             = 6443,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Canal/Flannel VXLAN overlay networking",
      protocol         = "udp",
      port             = 8472,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Canal/Flannel livenessProbe/readinessProbe",
      protocol         = "tcp",
      port             = 9099,
      remote_ip_prefix = var.network_cidr
    },
    {
      description      = "Ingress controller - livenessProbe/readinessProbe",
      protocol         = "tcp",
      port             = 10254,
      remote_ip_prefix = var.network_cidr
    },
  ]

  tags = [
    "Created_by_terraform",
  ]
}
