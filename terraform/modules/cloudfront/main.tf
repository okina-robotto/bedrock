resource "aws_cloudfront_distribution" "main" {
  enabled             = "${var.enabled}"
  is_ipv6_enabled     = "${var.is_ipv6_enabled}"
  default_root_object = "${var.default_root_object}"
  price_class         = "${var.price_class}"

  aliases = ["${var.aliases}"]

  origin {
    domain_name = "${var.origin_domain_name}"
    origin_id   = "${var.identifier}"
    origin_path = "${var.origin_path}"

    custom_origin_config {
      http_port                = "${var.origin_http_port}"
      https_port               = "${var.origin_https_port}"
      origin_protocol_policy   = "${var.origin_protocol_policy}"
      origin_ssl_protocols     = "${var.origin_ssl_protocols}"
      origin_keepalive_timeout = "${var.origin_keepalive_timeout}"
      origin_read_timeout      = "${var.origin_read_timeout}"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = "${var.acm_certificate_arn}"
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.1_2016"
    cloudfront_default_certificate = false
  }

  default_cache_behavior = {
    allowed_methods  = "${var.allowed_methods}"
    cached_methods   = "${var.cached_methods}"
    target_origin_id = "${var.identifier}"
    compress         = "${var.compress}"

    viewer_protocol_policy = "${var.viewer_protocol_policy}"
    default_ttl            = "${var.default_ttl}"
    min_ttl                = "${var.min_ttl}"
    max_ttl                = "${var.max_ttl}"

    forwarded_values = [{
      headers = ["${var.forward_headers}"]

      query_string = "${var.forward_query_string}"

      cookies = [{
        forward           = "${var.forward_cookies}"
        whitelisted_names = ["${var.forward_cookies_whitelisted_names}"]
      }]
    }]
  }

  ordered_cache_behavior = ["${var.custom_cache_behaviors}"]

  restrictions {
    "geo_restriction" {
      restriction_type = "${var.geo_restriction_type}"
    }
  }

  logging_config = ["${var.logging_config}"]
}
