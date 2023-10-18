output "id" {
  value       = aws_s3_bucket.s3_bucket.id
  description = "The id of the S3 Bucket"
}

output "arn" {
  value       = aws_s3_bucket.s3_bucket.arn
  description = "The arn of the S3 Bucket"
}

output "website_url" {
  value       = aws_s3_bucket_website_configuration.s3_bucket_website.website_endpoint
  description = "The website url"
}

output "website_domain" {
  value       = aws_s3_bucket_website_configuration.s3_bucket_website.website_domain
  description = "The domain of the website"
}