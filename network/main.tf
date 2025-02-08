terraform {
  backend "s3" {}
}

locals {
  bucket-name = var.bucket-name
}

resource "aws_s3_bucket" "example" {
  provider = aws.jongin
  bucket = local.bucket-name

  tags = {
    Name        = "test"
    Environment = "home"
  }
}