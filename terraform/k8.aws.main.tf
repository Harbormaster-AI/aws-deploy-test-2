
# Modules
module "eks" {
  source   = "./eks"
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  region         = var.region
}

module "k8s" {
  source   = "./k8s"
}

provider "kubernetes" {
    host = data.aws_eks_cluster.bankingbackend-cluster.endpoint
    cluster_ca_certificate = base64decode(
      data.aws_eks_cluster.bankingbackend-cluster.certificate_authority[0].data
    )

    exec {
      api_version = "client.authentication.k8s.io/v1"

      command = "aws"

      args = [
        "eks",
        "get-token",
        "--cluster-name",
        data.aws_eks_cluster.bankingbackend-cluster.name
      ]
    }
}