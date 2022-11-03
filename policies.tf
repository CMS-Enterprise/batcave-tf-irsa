data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  partition  = data.aws_partition.current.partition
  dns_suffix = data.aws_partition.current.dns_suffix
}

################################################################################
# SOPS Policy
################################################################################
data "aws_iam_policy_document" "sops" {
  count = var.create_role && var.attach_sops_policy ? 1 : 0

  statement {
    sid = "kmslist"
    actions = [
      "kms:List*",
      "kms:Describe*"
    ]
    resources = ["*"]
  }

  statement {
    sid = "kmsdecrypt"
    actions = [
      "kms:Decrypt",
    ]
    resources = [var.sops_arn]
  }
}

resource "aws_iam_policy" "sops" {
  count = var.create_role && var.attach_sops_policy ? 1 : 0

  name_prefix = "${var.policy_name_prefix}${var.app_name}_Policy-"
  path        = var.role_path
  description = "View and decrypt KMS keys"
  policy      = data.aws_iam_policy_document.sops[0].json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "sops" {
  count = var.create_role && var.attach_sops_policy ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.sops[0].arn
}

################################################################################
# S3 Policy
################################################################################
data "aws_iam_policy_document" "s3" {
  count = var.create_role && var.attach_s3_policy ? 1 : 0

  statement {
    sid = "S3ReadWrite"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
    ]
    resources = [for bucket in var.s3_bucket_arns : "${bucket}/*"]
  }

  statement {
    sid = "S3List"
    actions = [
      "s3:ListBucket",
    ]
    resources = var.s3_bucket_arns
  }
}

resource "aws_iam_policy" "s3" {
  count = var.create_role && var.attach_s3_policy ? 1 : 0

  name_prefix = "${var.policy_name_prefix}${var.app_name}-"
  path        = var.role_path
  description = "Interact with S3"
  policy      = data.aws_iam_policy_document.s3[0].json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "s3_policy" {
  count = var.create_role && var.attach_s3_policy ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.s3[0].arn
}
