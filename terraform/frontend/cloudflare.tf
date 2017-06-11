provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

# Add a record to the domain
resource "cloudflare_record" "frontend" {
  domain = "${var.domain}"
  name   = "${var.name}"
  value  = "${aws_cloudfront_distribution.frontend.domain_name}"
  type   = "CNAME"
  ttl    = 3600
}