locals {
  bucket_name = var.domain
}

# Provision an IAM user so our CI provider can sync the built bundle with s3
resource "aws_iam_user" "ci_s3_user" {
  name = "s3-${var.domain}"
  provider = "aws.default_region"
}

resource "aws_iam_access_key" "ci_s3_user_keys" {
  user = aws_iam_user.ci_s3_user.name
  provider = "aws.default_region"
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid = "AllowSyncFromCI"

    actions = [
      "*",
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}",
      "arn:aws:s3:::${local.bucket_name}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.ci_s3_user.arn]
    }
  }
  statement {
    sid = "AllowReadFromAll"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}/*",
    ]

    condition {
      test = ""
      values = []
      variable = ""
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
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