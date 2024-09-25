terraform {
  backend "s3" {
    bucket         = "terraform-state"
    encrypt        = true
    region         = "ap-south-1"
    key            = "ap-south-1/production/eks/prod/prod-eks-infra-cluster/terraform.tfstate"
    dynamodb_table = "terraform-locks"
  }
}
