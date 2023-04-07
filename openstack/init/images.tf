# ----------------------------------------------------------------- Images --- #

resource "openstack_images_image_v2" "ubuntu_v22_04" {
  name             = "ubuntu-22.04-2022"
  image_source_url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  web_download     = true
  container_format = "bare"
  disk_format      = "qcow2"
  min_disk_gb      = 1
  min_ram_mb       = 512
  visibility       = "shared"
  protected        = false
  tags             = ["Ubuntu"]
}

resource "openstack_images_image_v2" "ubuntu_v20_04" {
  name             = "ubuntu-20.04-2022"
  image_source_url = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
  web_download     = true
  container_format = "bare"
  disk_format      = "qcow2"
  min_disk_gb      = 1
  min_ram_mb       = 512
  visibility       = "shared"
  protected        = false
  tags             = ["Ubuntu"]
}
