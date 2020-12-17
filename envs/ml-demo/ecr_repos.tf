
# CDP repo list
resource "aws_ecr_repository" "ml_ecr_repo_list" {
  provider = aws.one

  for_each             = toset(local.ml_demo_ecr_repo_list)
  name                 = each.key
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

locals {
    ml_demo_ecr_repo_list = [
        "demo-model/preprocessing",
        "demo-model/training",
        "demo-model/inference"
    ]
}
