
################################################################################
# argocd helm deployment
################################################################################

module "argo_application" {
  # source = "lablabs/eks-argocd/aws"
  source = "./modules/eks-argocd-helm"

  cluster_identity_oidc_issuer     = module.eks.oidc_provider
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn

  enabled           = true
  argo_enabled      = false
  argo_helm_enabled = true

  self_managed = false

  helm_release_name = "argocd-helm"
  namespace         = "argocd-helm"

  argo_namespace = "default"
  argo_sync_policy = {
    "automated" : {}
    "syncOptions" = ["CreateNamespace=true"]
  }
}

################################################################################
# argocd helm deployment
################################################################################








locals {
  name   = "skp-${replace(basename(path.cwd), "_", "-")}"
  region = "us-east-1"


  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }
}



module "eks" {
  source          = "./modules/eks"
  name            = local.name
  cluster_version = "1.27"
  aws_auth_roles  = var.aws_auth_roles
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  intra_subnets   = module.vpc.intra_subnets
}

module "vpc" {
  source                  = "./modules/vpc"
  name                    = local.name
  vpc_cidr                = var.vpc_cidr
  oidc_provider_arn       = module.eks.oidc_provider_arn
  eks_managed_node_groups = module.eks.eks_managed_node_groups

}

resource "null_resource" "update_kubeconfig" {

  provisioner "local-exec" {
    command = "aws eks --region ${local.region} update-kubeconfig --name ${module.eks.cluster_name}"
  }

  depends_on = [module.eks]
}








