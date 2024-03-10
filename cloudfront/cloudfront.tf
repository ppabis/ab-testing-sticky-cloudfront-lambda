resource "aws_cloudfront_distribution" "AppDistribution" {
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "AppVersion1"
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = true
      cookies { forward = "all" }
    }

    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = "${data.aws_lambda_function.origin_request.arn}:2"
      include_body = false
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  enabled = true

  origin {
    custom_origin_config {
      http_port              = 8080
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
    domain_name = data.aws_instance.AppInstanceV1.public_dns
    origin_id   = "AppVersion1"
  }

}
