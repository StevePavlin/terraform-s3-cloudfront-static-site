# Static frontend

A terraform module to deploy a static frontend into s3 + cloudfront. Provisions an HTTPS certificate in us-east-1 (virginia) to be used with CloudFront.


## Usage

```
// The region to provision S3 in
provider "aws" {
  region = "eu-west-1"
  alias = "default_region"

  // optionally pass a profile to use
  profile = "terraform_development"
}

// AWS only allows SSL certificates provisioned in us-east-1 (virginia) to be pointed at cloudfront
provider "aws" {
  region = "us-east-1"
  alias = "ssl_certificate_region"

  // optionally pass a profile to use
  profile = "terraform_development"
}

module "static-s3-cloudfront-frontend" {
  source = "github.com/StevePavlin/terraform-s3-cloudfront-static-site"
  domain = "your-domain-name.com"
  providers = {
    aws.default_region = aws.default_region
    aws.ssl_certificate_region = aws.ssl_certificate_region
  }
}
```

This module assumes you're not using Route53 to manage DNS so setup is manual.

When the DNS verification step is created, you can view ACM to get the DNS verification details, then point your DNS towards the specified endpoint.

## License 
MIT
