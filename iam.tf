# Provision an IAM user so our CI provider can sync the built bundle with s3
resource "aws_iam_user" "ci_s3_user" {
  name = "s3-${var.domain}"
  provider = "aws.default_region"
}

# bucket policy
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

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
  provider = "aws.default_region"
}

resource "aws_iam_user_policy" "invalidation_policy" {
  name = "AllowInvalidationFromCI"
  user = aws_iam_user.ci_s3_user.name
  provider = "aws.default_region"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudfront:CreateInvalidation"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}