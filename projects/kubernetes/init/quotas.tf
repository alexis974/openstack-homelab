# ----------------------------------------------------------------- Quotas --- #

resource "openstack_compute_quotaset_v2" "compute" {
  project_id = openstack_identity_project_v3.project.id

  instances            = 5
  cores                = 24
  ram                  = 16 * 1024
  metadata_items       = 128
  key_pairs            = 15
  server_groups        = 10
  server_group_members = 10
}

resource "openstack_blockstorage_quotaset_v3" "blockstorate" {
  project_id = openstack_identity_project_v3.project.id

  volumes              = 10
  snapshots            = 10
  backups              = 0
  backup_gigabytes     = 0
  gigabytes            = 150
  per_volume_gigabytes = 100
}

resource "openstack_networking_quota_v2" "networking" {
  project_id = openstack_identity_project_v3.project.id

  network             = 3
  subnet              = 9
  port                = 30
  router              = 1
  floatingip          = 9
  security_group      = 25
  security_group_rule = 100
  rbac_policy         = 10
}
