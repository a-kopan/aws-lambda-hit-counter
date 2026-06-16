output "website_url" {
  description = "The CloudFront URL of your website"
  value       = aws_cloudfront_distribution.cdn.domain_name
}

output "api_endpoint" {
  description = "The URL of your API Gateway"
  value       = "${aws_apigatewayv2_api.http_api.api_endpoint}/count"
}