# ---------------------------------------------------------------- Project --- #

resource "openstack_identity_project_v3" "project" {
  name        = var.project_name
  description = var.project_description
  enabled     = true
}

resource "openstack_identity_group_v3" "group" {
  name        = var.project_name
  description = var.project_description
}


# ------------------------------------------------------------- Admin Data --- #

data "openstack_identity_user_v3" "admin" {
  name = "admin"
}

data "openstack_identity_role_v3" "admin" {
  name = "admin"
}


# ------------------------------------------------------------------- Role --- #

resource "openstack_identity_role_assignment_v3" "role_assignment_admin" {
  user_id    = data.openstack_identity_user_v3.admin.id
  project_id = openstack_identity_project_v3.project.id
  role_id    = data.openstack_identity_role_v3.admin.id
}

data "openstack_identity_role_v3" "load_balancer" {
  name = "load-balancer_member"
}

resource "openstack_identity_role_assignment_v3" "lb_member" {
  group_id   = openstack_identity_group_v3.group.id
  project_id = openstack_identity_project_v3.project.id
  role_id    = data.openstack_identity_role_v3.load_balancer.id
}

data "openstack_identity_role_v3" "member" {
  name = "_member_"
}

resource "openstack_identity_role_assignment_v3" "member" {
  group_id   = openstack_identity_group_v3.group.id
  project_id = openstack_identity_project_v3.project.id
  role_id    = data.openstack_identity_role_v3.member.id
}
