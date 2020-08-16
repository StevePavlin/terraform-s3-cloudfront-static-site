# Usage

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