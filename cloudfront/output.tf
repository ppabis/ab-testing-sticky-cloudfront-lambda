output "CloudFrontDNS" {
  value = aws_cloudfront_distribution.AppDistribution.domain_name
}
