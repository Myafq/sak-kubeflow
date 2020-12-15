resource "aws_s3_bucket" "demo-model" {
  bucket = "demo-model-churn-13917"
  acl    = "private"

  tags = {
    Purpose            = "ML Demo"
    Owner     = "devsitukhin"
  }
}

