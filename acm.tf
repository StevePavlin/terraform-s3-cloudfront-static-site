# AWS virginia must be used to provision HTTPS certificates for cloudfront distributions in other regions
resource "aws_acm_certificate" "cert" {
  provider          = "aws.ssl_certificate_region"
  domain_name       = "${local.bucket_name}"
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "cert" {
  provider                = "aws.ssl_certificate_region"
  certificate_arn         = "${aws_acm_certificate.cert.arn}"
}