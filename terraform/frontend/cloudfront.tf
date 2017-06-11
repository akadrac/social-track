resource "aws_cloudfront_distribution" "frontend" {
  origin {
    domain_name = "${aws_s3_bucket.frontend.bucket_domain_name}"
    origin_id   = "origin-bucket-${aws_s3_bucket.frontend.id}"

    s3_origin_config {
      # origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.frontend_origin_id.iam_arn}"
      origin_access_identity = "${aws_cloudfront_origin_access_identity.frontend_origin_id.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  aliases = ["${var.name}.${var.domain}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "origin-bucket-${aws_s3_bucket.frontend.id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 5
    max_ttl                = 60
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["AU", "US"]
    }
  }

  tags {
    Name = "social_track"
    Environment = "production"
    Component = "frontend"
    Managed = "terraform"
  }

  custom_error_response {
    error_code = 404
    response_code = 200
    response_page_path = "/index.html"
  }

  viewer_certificate {
    acm_certificate_arn = "${data.aws_acm_certificate.frontend.arn}"
    minimum_protocol_version = "TLSv1"
    ssl_support_method = "sni-only"
  }
}

resource "aws_cloudfront_origin_access_identity" "frontend_origin_id" {
  comment = "does this work"
}

#hack to support issued certs out of us-east-1 only
data "aws_acm_certificate" "frontend" {
  provider = "aws.us-east-1"
  domain   = "${var.name}.${var.domain}"
  statuses = ["ISSUED"]
}