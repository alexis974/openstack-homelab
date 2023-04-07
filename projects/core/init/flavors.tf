# ---------------------------------------------------------------- Flavors --- #

resource "openstack_compute_flavor_v2" "minecraft_small" {
  name      = "mc.small"
  ram       = 4 * 1024
  vcpus     = 4
  disk      = 50
  swap      = 0
  is_public = false
}

resource "openstack_compute_flavor_access_v2" "minecraft_small" {
  tenant_id = openstack_identity_project_v3.project.id
  flavor_id = openstack_compute_flavor_v2.minecraft_small.id
}

resource "openstack_compute_flavor_v2" "minecraft_medium" {
  name      = "mc.medium"
  ram       = 6 * 1024
  vcpus     = 6
  disk      = 50
  swap      = 0
  is_public = false
}

resource "openstack_compute_flavor_access_v2" "minecraft_medium" {
  tenant_id = openstack_identity_project_v3.project.id
  flavor_id = openstack_compute_flavor_v2.minecraft_medium.id
}

resource "openstack_compute_flavor_v2" "minecraft_large" {
  name      = "mc.large"
  ram       = 8 * 1024
  vcpus     = 8
  disk      = 50
  swap      = 0
  is_public = false
}

resource "openstack_compute_flavor_access_v2" "minecraft_large" {
  tenant_id = openstack_identity_project_v3.project.id
  flavor_id = openstack_compute_flavor_v2.minecraft_large.id
}