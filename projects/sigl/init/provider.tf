# --------------------------------------------------------------- Provider --- #

terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.51.1"
    }
  }

  backend "s3" {
    bucket  = "alexis974-tf-infra"
    key     = "openstack/sigl/common.tfstate"
    region  = "eu-west-3"
    encrypt = true
  }
}

# Configure the OpenStack Provider
provider "openstack" {
  cloud       = "openstack"
  use_octavia = true
}
