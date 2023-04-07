# ---------------------------------------------------------------- Mailcow --- #

module "sg_ingress_mailcow" {
  source = "haxorof/security-group/openstack"

  name        = "sg_ingress_mailcow"
  description = "Allow mailcow ingress traffic"

  ingress_rules_ipv4 = [
    {
      description = "Standard Postfix SMTP Port",
      protocol    = "tcp",
      port        = 25,
    },
    {
      description = "Standard Postfix SMTPS Port",
      protocol    = "tcp",
      port        = 465,
    },
    {
      description = "Standard Postfix Submission Port",
      protocol    = "tcp",
      port        = 587,
    },
    {
      description = "Standard Dovecot IMAP Port",
      protocol    = "tcp",
      port        = 143,
    },
    {
      description = "Standard Dovecot IMAPS Port",
      protocol    = "tcp",
      port        = 993,
    },
    {
      description = "Standard Dovecot POP3 Port",
      protocol    = "tcp",
      port        = 110,
    },
    {
      description = "Standard Dovecot POP3S Port",
      protocol    = "tcp",
      port        = 995,
    },
    {
      description = "Standard Dovecot ManageSieve Port",
      protocol    = "tcp",
      port        = 4190,
    },
    {
      description = "Standard HTTP Port",
      protocol    = "tcp",
      port        = 80,
    },
    {
      description = "Standard HTTPS Port",
      protocol    = "tcp",
      port        = 443,
    },
  ]

  tags = [
    "Created_by_terraform",
  ]
}
