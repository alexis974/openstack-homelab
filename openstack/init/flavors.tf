# ---------------------------------------------------------------- Flavors --- #

resource "openstack_compute_flavor_v2" "m1_tiny" {
  name      = "m1.tiny"
  ram       = 512
  vcpus     = 1
  disk      = 10
  swap      = 0
  is_public = true
}

resource "openstack_compute_flavor_v2" "m1_small" {
  name      = "m1.small"
  ram       = 1024
  vcpus     = 1
  disk      = 10
  swap      = 0
  is_public = true
}

resource "openstack_compute_flavor_v2" "m1_medium" {
  name      = "m1.medium"
  ram       = 1024 * 2
  vcpus     = 2
  disk      = 20
  swap      = 0
  is_public = true
}

resource "openstack_compute_flavor_v2" "m1_large" {
  name      = "m1.large"
  ram       = 1024 * 4
  vcpus     = 4
  disk      = 40
  swap      = 0
  is_public = true
}

resource "openstack_compute_flavor_v2" "m1_xlarge" {
  name      = "m1.xlarge"
  ram       = 1024 * 8
  vcpus     = 8
  disk      = 40
  swap      = 0
  is_public = true
}

resource "openstack_compute_flavor_v2" "c1_large" {
  name      = "c1.large"
  ram       = 1024 * 2
  vcpus     = 4
  disk      = 40
  swap      = 0
  is_public = true
}

resource "openstack_compute_flavor_v2" "c1_xlarge" {
  name      = "c1.xlarge"
  ram       = 1024 * 4
  vcpus     = 8
  disk      = 40
  swap      = 0
  is_public = true
}
