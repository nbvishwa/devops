data "aws_vpc" "default_vpc" {
  tags = {
    Name = "VPC"
  }
}

data "aws_subnets" "private_subnets_node" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }

  filter {
      name   = "tag:Name"
      values = ["prod-eks-infra-private-1a","prod-eks-infra-private-1b","prod-eks-infra-private-1c",
                "prod-eks-infra-private-2a","prod-eks-infra-private-2b","prod-eks-infra-private-2c"]
    }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }

  filter {
      name   = "tag:Name"
      values = ["prod-eks-infra-public-1a","prod-eks-infra-public-1b","prod-eks-infra-public-1c"]
    }
}

provider "aws" {
  alias  = "mumbai"
  region = "ap-south-1"
}


data "aws_caller_identity" "current" {}


