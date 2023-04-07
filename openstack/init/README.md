# Openstack init

Base configuration for a freshly installed Openstack.

Note: The block storage and compute quotas for the admin project are set to zero because the VM will be exclusively created from other projects.


## Auth

Go to identity -> Application credentials -> Create application credential and give it all the roles. Download the `clouds.yaml` file and put it in the current directory.


## Backend
Since Terraform’s version 1.3.0, the swift backend has been deprecated due to lack of support. Since then, I switched to AWS S3.


## Terraform

```bash
terraform init
terraform plan
terraform apply
```