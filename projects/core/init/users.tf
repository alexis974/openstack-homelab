# ------------------------------------------------------------------ Users --- #

resource "openstack_identity_user_v3" "alexis_boissiere" {
  default_project_id = openstack_identity_project_v3.project.id
  name               = "alexis_boissiere"
  description        = "System administrator"
  password           = var.default_user_password

  ignore_change_password_upon_first_use = false
  multi_factor_auth_enabled             = false

  extra = {
    email = "alexis.boissiere@epita.fr"
  }
}

resource "openstack_identity_role_v3" "user_role" {
  name = "${var.project_name}_user"
}

resource "openstack_identity_role_assignment_v3" "role_assignment_user" {
  user_id    = openstack_identity_user_v3.alexis_boissiere.id
  project_id = openstack_identity_project_v3.project.id
  role_id    = openstack_identity_role_v3.user_role.id
}

resource "openstack_identity_user_membership_v3" "membership" {
  user_id  = openstack_identity_user_v3.alexis_boissiere.id
  group_id = openstack_identity_group_v3.group.id
}
