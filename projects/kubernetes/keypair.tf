# ----------------------------------------------------------------- Alexis --- #

resource "openstack_compute_keypair_v2" "kp_alexis_boissiere" {
  name       = "kp_alexis_boissiere_mac"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGy6gQWWIASnt3KVOWjjdKhPtkeHyVxmuf+LccP7tyPsbFmbsR9GHCZpch8GphJJbfZTci8zInQhD7q16ePylV7vmnGX9XaC+D4xqTkq0JQTo5VxWlvRUL2GYB6Zrle5HDbEIKymc48fvIcTDDowAwZtW/uOFb7hf7P9AtyLOTL+Zb6Rq6lo44unXXAKcW3mDMFNeENAE2kG2AeQeoDRe6Fj2MEGaInIGMBCwrMybsVj6zDRVDysbVK5OoIHpjqdewznHt5M7gRIHgNSqAwRxAgWJ7mu43J+LLO6qmPTH8oQcGBJZAj12nvl5fMqy+hFFKLxerMlYy4guC9ISjrfDJ3ZdmHgGyRU5WkdUeaLSkvEf84Ii6DZwwM7IyTxE20hft8LaWvkFtDwlPp9dRpM2B2QGRZ1oN4/Tf1Uqn96RoAqxME0Kr3PZheoqnWABw4xhPoFw35HA/8saEoCypQ6wwLF7vo+rFT5cUqnUNAnTkUxpbiFhpPhelxBTWixos/Flv5di2vhTp7HSNajt3lFoia+o6/cMmngsbwbnkQ6O1f7dUleDahR18pbXNm9qk1wpXMoKXV8qBnb5/ciw7kbrtAl3EgUwKs0t3O3iV0dsqo4JdMkyKRQ1z2mJzao44Y7L44qAybb/XvSyJCEf3l+htdVwm5Cqf/Pa2S24tzq/WwQ== alexis@Alexiss-MacBook-Pro.local"
}
