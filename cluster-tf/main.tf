
################################################################################
# EKS Module
################################################################################

module "eks" {
  source = "../../..//modules/eks-modules-2024/terraform-aws-eks/"

  cluster_name                    = local.cluster_name
  cluster_version                 = local.cluster_version
  cluster_endpoint_private_access = local.cluster_private
  cluster_endpoint_public_access  = local.cluster_public
  authentication_mode = "API_AND_CONFIG_MAP"
  
  create_cluster_security_group = local.create_cluster_security_group
  cluster_security_group_id = local.cluster_security_group_id
  cluster_additional_security_group_ids = local.cluster_additional_security_group_ids
  enable_cluster_creator_admin_permissions = local.enable_cluster_creator_admin_permissions

  vpc_id = local.vpc_id
  control_plane_subnet_ids = local.private_subnet_ids
  subnet_ids = local.private_subnet_ids
  cluster_service_ipv4_cidr = local.cluster_service_ipv4_cidr
  cluster_tags = local.tags
  bootstrap_self_managed_addons = false

  create_iam_role = local.create_iam_role
  iam_role_arn = local.iam_role_arn

  create_node_security_group = false
  node_security_group_id = local.node_security_group_id

  enable_irsa = false
  cluster_addons = local.cluster_addons

  cluster_encryption_config = {
    provider_key_arn = local.provider_key_arn
    resources        = ["secrets"] 
  }
  access_entries = local.access_entries
  
  create_kms_key = false

  self_managed_node_groups = {
    devops = {
      name = "${local.cluster_name}-devops-ng"
      instance_type        = local.instance_type
      ami_id               = local.ami_arm 
      bootstrap_extra_args = "--container-runtime containerd --dns-cluster-ip 10.172.0.10 --kubelet-extra-args '--node-labels=project=devops --register-with-taints=project=devops:NoSchedule'"
      min_size             = local.min_size
      max_size             = local.max_size
      desired_size         = local.desired_size
      launch_template_name = "${local.cluster_name}-devops-ng-lt"
      cluster_service_cidr = local.cluster_service_ipv4_cidr
      subnet_ids           = local.private_subnet_ids
      key_name = local.key_name

      create_iam_instance_profile = false
      iam_instance_profile_arn = local.iam_instance_profile_arn
      iam_role_arn = local.node_iam_role_arn

      create_access_entry = true
      vpc_security_group_ids = [
        module.eks.cluster_primary_security_group_id,
        module.eks.cluster_security_group_id,
      ]

      block_device_mappings =  [{
        device_name = "/dev/xvda"
        ebs = {
          volume_size = "100"
          volume_type = "gp3"
        }
      }]
      tags = merge(local.tags, { Name = "${local.cluster_name}-devops-ng" }, local.asg_autoscaling_tags, local.node_termination_tags)
    }
  }
}
