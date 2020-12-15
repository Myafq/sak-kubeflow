
# CDP repo list
resource "aws_ecr_repository" "ml_ecr_repo_list" {
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

resource "aws_iam_user" "system_ml_gitlab" {
  name = "system-ml-gitlab"
}

resource "aws_iam_user_policy" "system_ml_gitlab_access" {
  name = "system-ml-gitlab-access"
  user = aws_iam_user.system_ml_gitlab.name
  policy = data.aws_iam_policy_document.ml_gitlab.json
}
data "aws_iam_policy_document" "ml_gitlab" {

    statement {
        actions = [
            "ecr:*",
        ]
        resources = [for repo in aws_ecr_repository.ml_ecr_repo_list: repo.arn ]
  }
    statement {
        actions = [
            "ecr:GetAuthorizationToken"
        ]
        resources = ["*"]
    }
}


resource "aws_iam_access_key" "system_ml_gitlab" {
  user = aws_iam_user.system_ml_gitlab.name
}
output "secret" {
  value = {
    access_key    = aws_iam_access_key.system_ml_gitlab.id
    access_secret = aws_iam_access_key.system_ml_gitlab.secret
  }
}
