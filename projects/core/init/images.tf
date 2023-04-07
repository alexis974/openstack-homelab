# ----------------------------------------------------------------- Ubuntu --- #

data "openstack_images_image_v2" "ubuntu_22" {
  name        = "ubuntu-22.04-2022"
  most_recent = true
}

resource "openstack_images_image_access_v2" "ubuntu_22" {
  image_id  = data.openstack_images_image_v2.ubuntu_22.id
  member_id = openstack_identity_project_v3.project.id
  status    = "accepted"
}

data "openstack_images_image_v2" "ubuntu_20" {
  name        = "ubuntu-20.04-2022"
  most_recent = true
}

resource "openstack_images_image_access_v2" "ubuntu_20" {
  image_id  = data.openstack_images_image_v2.ubuntu_20.id
  member_id = openstack_identity_project_v3.project.id
  status    = "accepted"
}
