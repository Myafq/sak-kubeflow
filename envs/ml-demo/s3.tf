resource "aws_s3_bucket" "demo-model" {
  bucket = "demo-model-churn-13917"
  acl    = "private"

  tags = {
    Purpose            = "ML Demo"
    Owner     = "devsitukhin"
  }
}

resource "aws_s3_bucket" "demo-model-sagemaker" {
  bucket = "demo-model-churn-east-1"
  acl    = "private"
  provider = aws.one
  tags = {
    Purpose            = "ML Demo"
    Owner     = "devsitukhin"
  }
}

