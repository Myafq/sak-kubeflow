resource "aws_iam_role" "kubeflow_role" {
  name  = "kubeflow-ml-demo"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::245582572290:oidc-provider/oidc.eks.us-east-2.amazonaws.com/id/D8E0EE1A27A5FDF9E54543546F33BAAD"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringLike": {
           "oidc.eks.us-east-2.amazonaws.com/id/D8E0EE1A27A5FDF9E54543546F33BAAD:sub": "system:serviceaccount:*:*"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "kubeflow_role_access" {
  name  = "kubeflow-ml-demo-access"
  role  = aws_iam_role.kubeflow_role.id

  policy = <<-EOF
{
  "Version": "2012-10-17",
    "Statement": [
   {
      "Sid": "ListBuckets",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "${aws_s3_bucket.demo-model.arn}"
      ]
    },
    {
      "Sid": "AllowS3Read",
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.demo-model.arn}/*"
      ]
    },
        {
            "Sid": "RoleAssume",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "${aws_iam_role.kubeflow_role.arn}"
        }
    ]
}
  EOF
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
    statement {
        actions = [
                "sagemaker:*",
                "cloudwatch:PutMetricData",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents"
        ]
        resources =["*"]
    }
    statement       {
         actions = [
            "s3:CreateBucket", 
            "s3:ListAllMyBuckets", 
            "s3:GetBucketLocation",
            "s3:PutObject"  
         ]
         resources = [
            "arn:aws:s3:::demo*"
         ]
       }
    statement {
      actions = [
        "iam:PassRole"
      ]
      resources = [
        "arn:aws:iam::245582572290:role/service-role/AmazonSageMakerServiceCatalogProductsUseRole"
      ]
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
