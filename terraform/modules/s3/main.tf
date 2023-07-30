resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name
  acl    = var.acl

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  policy = var.policy
}
