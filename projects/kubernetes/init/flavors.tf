# ---------------------------------------------------------------- Flavors --- #

resource "openstack_compute_flavor_v2" "kubernetes_controller" {
  name      = "kubernetes.controller"
  ram       = 1024 * 4
  vcpus     = 4
  disk      = 25
  swap      = 0 * 4
  is_public = false
}

resource "openstack_compute_flavor_access_v2" "kubernetes_controller" {
  tenant_id = openstack_identity_project_v3.project.id
  flavor_id = openstack_compute_flavor_v2.kubernetes_controller.id
}

resource "openstack_compute_flavor_v2" "kubernetes_worker" {
  name      = "kubernetes.worker"
  ram       = 1024 * 12
  vcpus     = 8
  disk      = 75
  swap      = 0 * 4
  is_public = false
}

resource "openstack_compute_flavor_access_v2" "kubernetes_worker" {
  tenant_id = openstack_identity_project_v3.project.id
  flavor_id = openstack_compute_flavor_v2.kubernetes_worker.id
}