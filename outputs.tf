output "iam_access_key_id" {
  value = "${aws_iam_access_key.ci_s3_user_keys.id}"
  description = "IAM access key for S3 CI user"
}

//the access key secret
output "iam_access_key_secret" {
  value = "${aws_iam_access_key.ci_s3_user_keys.secret}"
  description = "IAM secret access key for S3 CI user"
}

output "bucket_name" {
  value = "${aws_s3_bucket.main.id}"
  description = "S3 bucket name"
}