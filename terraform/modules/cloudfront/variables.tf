variable "identifier" {
  description = "Identifier for the distribution and the origin, no spaces"
}

variable "aliases" {
  description = "Web dns addresses"
  type = "list"
}

variable "origin_domain_name" {
  description = "Origin dns address"
}

variable "acm_certificate_arn" {
  description = "Existing acm certificate arn"
}

variable "enabled" {
  default = "true"
}

variable "origin_path" {
  description = "Cloudfront origin request path"
  default     = ""
}

variable "origin_http_port" {
  description = "Http port the custom origin listens on"
  default     = "80"
}

variable "origin_https_port" {
  description = "Https port the custom origin listens on"
  default     = "443"
}

variable "origin_protocol_policy" {
  description = "Origin protocol policy to apply to your origin, http-only, https-only, or match-viewer"
  default     = "match-viewer"
}

variable "origin_ssl_protocols" {
  description = "SSL/TLS protocols to use when communicating with your origin over https"
  type        = "list"
  default     = [
    "TLSv1",
    "TLSv1.1",
    "TLSv1.2"
  ]
}

variable "origin_keepalive_timeout" {
  description = "Custom keep-alive timeout, in seconds, by default aws enforces a limit of 60"
  default     = "60"
}

variable "origin_read_timeout" {
  description = "Custom read timeout, in seconds, by default aws enforces a limit of 60"
  default     = "60"
}

variable "compress" {
  description = "Should cloudfront automatically compress content for requests that include Accept-Encoding: gzip"
  default     = "true"
}

variable "is_ipv6_enabled" {
  default = "true"
}

variable "default_root_object" {
  default = ""
}

variable "forward_query_string" {
  default = "true"
}

variable "forward_headers" {
  description = "Headers that cloudfront should forward to the origin, for all use *"
  type        = "list"
  default     = [
    "Host",
    "Origin",
    "Referrer",
    "Authorization",
    "X-Forwarded-Proto",
    "X-Forwarded-Scheme"
  ]
}

variable "forward_cookies" {
  description = "Whether CloudFront should forward cookies to the origin, all, none or whitelist"
  default     = "whitelist"
}

variable "forward_cookies_whitelisted_names" {
  type        = "list"
  description = "List of forwarded cookies to the origin"
  default     = []
}

variable "price_class" {
  default = "PriceClass_All"
}

variable "viewer_protocol_policy" {
  description = "allow-all, redirect-to-https"
  default     = "redirect-to-https"
}

variable "allowed_methods" {
  type    = "list"
  default = [
    "DELETE",
    "GET",
    "HEAD",
    "OPTIONS",
    "PATCH",
    "POST",
    "PUT"
  ]
}

variable "cached_methods" {
  type    = "list"
  default = [
    "GET",
    "HEAD"
  ]
}

variable "default_ttl" {
  default = "900"
}

variable "min_ttl" {
  default = "0"
}

variable "max_ttl" {
  default = "86400" // 24hrs
}

variable "geo_restriction_type" {
  default = "none"
}

variable "custom_cache_behaviors" {
  type    = "list"
  default = []
}

variable "logging_config" {
  type    = "list"
  default = []
}
