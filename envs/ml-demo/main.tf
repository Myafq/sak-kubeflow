module "sak_kubeflow" {
  source = "../.."

  cluster_name = "ml-demo"

  owner      = "Myafq"
  repository = "sak-kubeflow"
  branch     = "init"

  #Main route53 zone id if exist (Change It)
  mainzoneid = "Z02149423PVQ0YMP19F13"

  # Name of domains (create route53 zone and ingress). Set as array, first main ingress fqdn ["example.com", "example.io"]
  domains = ["ml-demo.edu.provectus.io"]

  # ARNs of users which would have admin permissions. (Change It)
  admin_arns = [
    {
      userarn  = "arn:aws:iam::245582572290:user/devstiukhin"
      username = "devstiukhin"
      groups   = ["system:masters"]
    }
  ]

  # Email that would be used for LetsEncrypt notifications
  cert_manager_email = "devstiukhin@provectus.com"

  cognito_users = [
    {
      email    = "devstiukhin@provectus.com"
      username = "devstiukhin"
      group    = "administrators"
    }
  ]

  argo_path_prefix = "envs/ml-demo/"
  argo_apps_dir    = "argocd-applications"
}
