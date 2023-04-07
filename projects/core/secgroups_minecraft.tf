# ---------------------------------------------------------------- Mailcow --- #

module "sg_ingress_minecraft" {
  source = "haxorof/security-group/openstack"

  name        = "sg_ingress_minecraft"
  description = "Allow minecraft ingress traffic"

  ingress_rules_ipv4 = [
    {
      description = "Standard Minecraft Port",
      protocol    = "tcp",
      port        = 25565
    },
  ]

  tags = [
    "Created_by_terraform",
  ]
}
