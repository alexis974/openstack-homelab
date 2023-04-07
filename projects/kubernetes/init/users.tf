# ------------------------------------------------------------------ Users --- #

data "openstack_identity_user_v3" "alexis_boissiere" {
  name = "alexis_boissiere"
}

resource "openstack_identity_role_v3" "user_role" {
  name = "${var.project_name}_user"
}

resource "openstack_identity_role_assignment_v3" "role_assignment_user" {
  user_id    = data.openstack_identity_user_v3.alexis_boissiere.id
  project_id = openstack_identity_project_v3.project.id
  role_id    = openstack_identity_role_v3.user_role.id
}

resource "openstack_identity_user_membership_v3" "membership" {
  user_id  = data.openstack_identity_user_v3.alexis_boissiere.id
  group_id = openstack_identity_group_v3.group.id
}
