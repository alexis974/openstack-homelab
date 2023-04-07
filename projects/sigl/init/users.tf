# ----------------------------------------------------------------- Commun --- #

resource "openstack_identity_role_v3" "user_role" {
  name = "${var.project_name}_user"
}

# ------------------------------------------------------------------ Admin --- #

data "openstack_identity_user_v3" "alexis_boissiere" {
  name = "alexis_boissiere"
}

resource "openstack_identity_role_assignment_v3" "admin" {
  user_id    = data.openstack_identity_user_v3.alexis_boissiere.id
  project_id = openstack_identity_project_v3.project.id
  role_id    = openstack_identity_role_v3.user_role.id
}

resource "openstack_identity_user_membership_v3" "admin" {
  user_id  = data.openstack_identity_user_v3.alexis_boissiere.id
  group_id = openstack_identity_group_v3.group.id
}

# ------------------------------------------------------------------ Users --- #

resource "openstack_identity_user_v3" "user" {
  for_each = var.user_list

  default_project_id = openstack_identity_project_v3.project.id
  name               = each.key
  description        = var.user_description
  password           = var.default_user_password

  ignore_change_password_upon_first_use = false
  multi_factor_auth_enabled             = false

  extra = {
    email = each.value
  }
}

resource "openstack_identity_role_assignment_v3" "user" {
  for_each   = var.user_list
  user_id    = openstack_identity_user_v3.user[each.key].id
  project_id = openstack_identity_project_v3.project.id
  role_id    = openstack_identity_role_v3.user_role.id
}

resource "openstack_identity_user_membership_v3" "user" {
  for_each = var.user_list
  user_id  = openstack_identity_user_v3.user[each.key].id
  group_id = openstack_identity_group_v3.group.id
}
