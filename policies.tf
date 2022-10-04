data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  partition  = data.aws_partition.current.partition
  dns_suffix = data.aws_partition.current.dns_suffix
}

################################################################################
# Velero Policy
################################################################################

# https://github.com/vmware-tanzu/velero-plugin-for-aws#set-permissions-for-velero
data "aws_iam_policy_document" "velero" {
  count = var.create_role && var.attach_velero_policy ? 1 : 0

  statement {
    sid = "Ec2ReadWrite"
    actions = [
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot",
    ]
    resources = ["*"]
  }

  statement {
    sid = "S3ReadWrite"
    actions = [
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
    ]
    resources = [for bucket in var.velero_s3_bucket_arns : "${bucket}/*"]
  }

  statement {
    sid = "S3List"
    actions = [
      "s3:ListBucket",
    ]
    resources = var.velero_s3_bucket_arns
  }
}

resource "aws_iam_policy" "velero" {
  count = var.create_role && var.attach_velero_policy ? 1 : 0

  name_prefix = "${var.policy_name_prefix}Velero_Policy-"
  path        = var.role_path
  description = "Provides Velero permissions to backup and restore cluster resources"
  policy      = data.aws_iam_policy_document.velero[0].json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "velero" {
  count = var.create_role && var.attach_velero_policy ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.velero[0].arn
}

################################################################################
# Flux Policy
################################################################################
data "aws_kms_alias" "sops" {
  name = "alias/batcave-landing-sops"
}

data "aws_iam_policy_document" "flux" {
  count = var.create_role && var.attach_flux_policy ? 1 : 0

  statement {
    sid = "kmslist"
    actions = [
      "kms:List*",
      "kms:Describe*"
    ]
    resources = ["*"]
  }

  statement {
    sid = "K8sNodes"
    actions = [
      "kms:Decrypt",
    ]
    resources = [
      data.aws_kms_alias.sops.arn,
      data.aws_kms_alias.sops.target_key_arn,
    ]
  }
}

resource "aws_iam_policy" "flux" {
  count = var.create_role && var.attach_flux_policy ? 1 : 0

  name_prefix = "${var.policy_name_prefix}Flux_Policy-"
  path        = var.role_path
  description = "Provides Flux permissions to view and decrypt KMS keys"
  policy      = data.aws_iam_policy_document.flux[0].json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "flux" {
  count = var.create_role && var.attach_flux_policy ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.flux[0].arn
}
