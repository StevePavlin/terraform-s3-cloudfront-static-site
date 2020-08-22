locals {
  bucket_name = var.domain
}


resource "aws_iam_access_key" "ci_s3_user_keys" {
  user = aws_iam_user.ci_s3_user.name
  provider = "aws.default_region"
}



resource "aws_s3_bucket" "main" {
  bucket = local.bucket_name
  acl    = "private"
  policy = data.aws_iam_policy_document.bucket_policy.json

  website {
    index_document = var.index_document
    error_document = var.index_document
  }

  force_destroy = false

  tags = {
    "Name" = local.bucket_name
  }
  provider = "aws.default_region"
}

resource "aws_s3_bucket_object" "index" {
  bucket       = local.bucket_name
  key          = "index.html"
  source       = "${path.module}/initial-files/index.html"
  content_type = "text/html"
  provider = "aws.default_region"
}