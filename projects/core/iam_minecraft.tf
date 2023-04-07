# ----------------------------------------------------------------- Bucket --- #

resource "aws_s3_bucket" "alexis974_minecraft_server_backup" {
  bucket        = "alexis974-minecraft-server-backup"
  force_destroy = true

  tags = {
    Terraform = "true"
  }
}

resource "aws_s3_bucket_acl" "alexis974_minecraft_server_backup" {
  bucket = aws_s3_bucket.alexis974_minecraft_server_backup.id
  acl    = "private"
}


# ----------------------------------------------------------------- Access --- #

resource "aws_s3_bucket_public_access_block" "alexis974_minecraft_server_backup" {
  bucket = aws_s3_bucket.alexis974_minecraft_server_backup.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}


# -------------------------------------------------------------------- IAM --- #
#
resource "aws_iam_user" "minecraft_server" {
  name = "minecraft_server"
  path = "/"

  tags = {
    Terraform = "true"
  }
}

resource "aws_iam_policy" "minecraft_server" {
  name        = "S3_minecraft_server"
  description = "Minecrat server backup bucket access"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "s3:ListBucket",
        "Resource": "${aws_s3_bucket.alexis974_minecraft_server_backup.arn}"
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:PutObject"
        ],
        "Resource": [
          "${aws_s3_bucket.alexis974_minecraft_server_backup.arn}/*"
        ]
      }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "minecraft_server" {
  user       = aws_iam_user.minecraft_server.name
  policy_arn = aws_iam_policy.minecraft_server.arn
}
