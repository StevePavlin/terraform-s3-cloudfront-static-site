resource "aws_cloudfront_distribution" "main" {
  http_version = "http1.1"

  origin {
    origin_id   = "origin-${local.bucket_name}"
    domain_name = aws_s3_bucket.main.website_endpoint

    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = "80"
      https_port             = "443"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  default_root_object = var.index_document

  aliases = concat([local.bucket_name])

  # route errors to index so react router works, similar to try_files in nginx
  custom_error_response {
    error_code    = 403
    response_code = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code    = 404
    response_code = 200
    response_page_path = "/index.html"
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  // cache index.html/assets for 1 hour, we invalidate index.html during deployment
  default_cache_behavior {
    target_origin_id = "origin-${local.bucket_name}"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    compress         = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 3600
    default_ttl            = 3600
    max_ttl                = 3600
  }

  viewer_certificate {
    acm_certificate_arn      = "${aws_acm_certificate_validation.cert.certificate_arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
  provider = "aws.default_region"
}