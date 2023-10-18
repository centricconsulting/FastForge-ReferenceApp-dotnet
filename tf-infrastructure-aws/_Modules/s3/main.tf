resource "aws_s3_bucket" "s3_bucket" {
    bucket_name = var.name
    tags        = var.tags
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
    bucket = aws_s3_bucket.s3_bucket.id
    acl    = var.acl
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
    bucket = aws_s3_bucket.s3_bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_website_configuration" "s3_bucket_website" {
  bucket = aws_s3_bucket.s3_bucket.id

  index_document {
    suffix = "index.html"
  }
}
