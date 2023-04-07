# --------------------------------------------------------------- Provider --- #

terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.51.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.51.0"
    }
  }

  backend "s3" {
    bucket  = "alexis974-tf-infra"
    key     = "core/common.tfstate"
    region  = "eu-west-3"
    encrypt = true
  }
}

provider "openstack" {
  cloud       = "openstack"
  use_octavia = true
}

provider "aws" {
  region = "eu-west-3"
}
