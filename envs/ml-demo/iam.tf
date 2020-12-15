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
