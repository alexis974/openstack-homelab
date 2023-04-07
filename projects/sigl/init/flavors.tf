# ---------------------------------------------------------------- Flavors --- #

resource "openstack_compute_flavor_v2" "c4_small" {
  name      = "c4.small"
  ram       = 2 * 1024
  vcpus     = 4
  disk      = 15
  swap      = 0 * 1024
  is_public = false
}

resource "openstack_compute_flavor_access_v2" "c4_small" {
  tenant_id = openstack_identity_project_v3.project.id
  flavor_id = openstack_compute_flavor_v2.c4_small.id
}

resource "openstack_compute_flavor_v2" "c4_large" {
  name      = "c4.large"
  ram       = 4 * 1024
  vcpus     = 8
  disk      = 15
  swap      = 0 * 1024
  is_public = false
}

resource "openstack_compute_flavor_access_v2" "c4_large" {
  tenant_id = openstack_identity_project_v3.project.id
  flavor_id = openstack_compute_flavor_v2.c4_large.id
}
