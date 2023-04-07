# ----------------------------------------------------------------- Quotas --- #

data "openstack_identity_project_v3" "admin" {
  name = "admin"
}

resource "openstack_compute_quotaset_v2" "compute" {
  project_id = data.openstack_identity_project_v3.admin.id

  instances            = 0
  cores                = 0
  ram                  = 0
  metadata_items       = 128
  key_pairs            = 15
  server_groups        = 10
  server_group_members = 10
}

resource "openstack_blockstorage_quotaset_v3" "blockstorate" {
  project_id = data.openstack_identity_project_v3.admin.id

  volumes   = 0
  snapshots = 0
  backups   = 0
  gigabytes = 0
}

resource "openstack_networking_quota_v2" "networking" {
  project_id = data.openstack_identity_project_v3.admin.id

  network             = 3
  subnet              = 9
  port                = 30
  router              = 1
  floatingip          = 9
  security_group      = 25
  security_group_rule = 100
  rbac_policy         = 10
}
