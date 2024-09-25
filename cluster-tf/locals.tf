locals {

  env    = "prod-eks"
  region = "ap-south-1"

  #cluster-details
  cluster_name    = "prod-eks-infra-cluster"
  cluster_private = true
  cluster_public  = false

  #cluster add on
  cluster_addons = {
    coredns = {
      before_compute       = false
      most_recent          = true
      configuration_values = "{\"replicaCount\":2,\"resources\":{\"limits\":{\"cpu\":\"100m\",\"memory\":\"200Mi\"},\"requests\":{\"cpu\":\"100m\",\"memory\":\"200Mi\"}},\"nodeSelector\":{\"project\":\"devops\"},\"tolerations\":[{\"key\":\"project\",\"value\":\"devops\",\"operator\":\"Equal\",\"effect\":\"NoSchedule\"}]}"
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      before_compute       = false
      most_recent          = true
      configuration_values = "{\"controller\":{\"replicaCount\":2,\"nodeSelector\":{\"project\":\"system-compute-arm\"},\"tolerations\":[{\"key\":\"project\",\"value\":\"system-compute-arm\",\"operator\":\"Equal\",\"effect\":\"NoSchedule\"}]}}"
      service_account_role_arn = "arn:aws:iam::xxxxxxxxxxxxxx:role/AmazonEKS_EBS_CSI_DriverRole" #changes for each cluster
    }
  }

  #access entries
  access_entries = {
    eks-admin-view = {
      principal_arn = "arn:aws:iam::xxxxxxxxxxxxxx:role/aws-reserved/sso.amazonaws.com/ap-south-1/DevOpsManager-Prod"
      type          = "STANDARD"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }


  //ami for nodes
  ami     = "ami-00485f2beb3fc5f6c"
  ami_arm = "ami-03732d5fa0eb956c6"

  #Networking
  availability_zones = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  vpc_id             = data.aws_vpc.default_vpc.id
  private_subnet_ids = data.aws_subnets.private_subnets_node.ids
  public_subnet_ids  = data.aws_subnets.public_subnets.ids
  provider_key_arn = "arn:aws:kms:ap-south-1:xxxxxxxxxxxxxx:key/1234"

  #security groups
  create_cluster_security_group            = false
  cluster_security_group_id                = "sg-1234"
  cluster_additional_security_group_ids    = ["sg-5678"]
  enable_cluster_creator_admin_permissions = true
  cluster_service_ipv4_cidr                = "10.172.0.0/21"
  cluster_version                          = "1.29"

  #iam
  create_iam_role = false
  iam_role_arn    = "arn:aws:iam::xxxxxxxxxxxxxx:role/eks-infra-cluster-role"

  #node security groups
  create_node_security_group = false
  node_security_group_id     = "sg-91012"
  iam_instance_profile_arn   = "arn:aws:iam::xxxxxxxxxxxxxx:instance-profile/eks-infra-cluster-node-role"
  node_iam_role_arn          = "arn:aws:iam::xxxxxxxxxxxxxx:role/eks-infra-cluster-node-role"

  #initial-node-group-details
  instance_type = "c6g.xlarge"
  min_size             = 1
  max_size             = 10
  desired_size         = 1
  key_name = "eks-prod-key"
  
  #tags
  tags = merge(local.common_tags, {
    Name = local.cluster_name
  })

  asg_autoscaling_tags = {
    "k8s.io/cluster-autoscaler/enabled"               = "true"
    "k8s.io/cluster-autoscaler/${local.cluster_name}" = "owned"
  }

  node_termination_tags = {
    "aws-node-termination-handler/managed" = "true"
  }

  common_tags = {
    "environment" = "prod-eks"
    "dept"        = "tech"
    "managed-by"  = "devops"
    "vertical"    = "devops"
  }
}
