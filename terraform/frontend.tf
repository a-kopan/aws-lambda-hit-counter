resource "aws_s3_bucket" "website_bucket" {
  bucket_prefix = "visitor-counter-site-"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "website_bucket_pab" {
  bucket                  = aws_s3_bucket.website_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "visitor-counter-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  origin {
    domain_name              = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.website_bucket.id
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.website_bucket.id

    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "cloudfront.amazonaws.com"
      }
      Action   = "s3:GetObject"
      Resource = "${aws_s3_bucket.website_bucket.arn}/*"
      Condition = {
        StringEquals = {
          "AWS:SourceArn" = aws_cloudfront_distribution.cdn.arn
        }
      }
    }]
  })
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "index.html"
  source       = "../website/index.html"
  content_type = "text/html"
  etag         = filemd5("../website/index.html")
}

resource "aws_s3_object" "script" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "script.js"
  
  content = templatefile("../website/script.js", {
    api_url = "${aws_apigatewayv2_api.http_api.api_endpoint}/count"
  })
  
  content_type = "application/javascript"
  
  etag = md5(templatefile("../website/script.js", {
    api_url = "${aws_apigatewayv2_api.http_api.api_endpoint}/count"
  }))
}

resource "aws_s3_object" "styles" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "styles.css"
  source       = "../website/styles.css"
  content_type = "text/css"
  etag         = filemd5("../website/styles.css")
}

resource "aws_s3_object" "image" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "facebook-profile-blank-face.jpeg"
  source       = "../website/facebook-profile-blank-face.jpeg"
  content_type = "image/jpeg"
  etag         = filemd5("../website/facebook-profile-blank-face.jpeg")
}