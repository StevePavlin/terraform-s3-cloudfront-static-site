output "iam_access_key_id" {
  value = "${aws_iam_access_key.ci_s3_user_keys.id}"
  description = "IAM access key for S3 CI user"
}

//the access key secret
output "iam_access_key_secret" {
  value = "${aws_iam_access_key.ci_s3_user_keys.secret}"
  description = "IAM secret access key for S3 CI user"
}

output "cloudfront_domain_name" {
  value = "${aws_cloudfront_distribution.main.domain_name}"
  description = "The cloudfront domain name to point your cname records towards"
}

output "cloudfront_distribution_id" {
  value = "${aws_cloudfront_distribution.main.id}"
  description = "The cloudfront distribution id"
}