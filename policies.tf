data "aws_partition" "current" {}

locals {
  partition = data.aws_partition.current.partition
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
    sid = "kmsops"
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
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

################################################################################
# DynamoDB Policy
################################################################################
data "aws_iam_policy_document" "dynamodb" {
  count = var.create_role && var.attach_dynamodb_policy ? 1 : 0

  # permissions taken from: https://developer.hashicorp.com/vault/docs/configuration/storage/dynamodb
  statement {
    sid = "DynamoDBReadWrite"
    actions = [
      "dynamodb:DescribeLimits",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:ListTagsOfResource",
      "dynamodb:DescribeReservedCapacityOfferings",
      "dynamodb:DescribeReservedCapacity",
      "dynamodb:ListTables",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:CreateTable",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:Scan",
      "dynamodb:DescribeTable"
    ]
    resources = [var.dynamodb_arn]
  }
}

resource "aws_iam_policy" "dynamodb" {
  count = var.create_role && var.attach_dynamodb_policy ? 1 : 0

  name_prefix = "${var.policy_name_prefix}${var.app_name}-"
  path        = var.role_path
  description = "Interact with DynamoDB"
  policy      = data.aws_iam_policy_document.dynamodb[0].json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "dynamodb" {
  count = var.create_role && var.attach_dynamodb_policy ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.dynamodb[0].arn
}

################################################################################
# AWS Secrets Manager Policy
################################################################################
data "aws_iam_policy_document" "secrets-manager" {
  count = var.create_role && var.attach_secretsmanager_policy ? 1 : 0

  statement {
    sid = "SecretsManagerRead"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = var.secret_arns
  }
}

resource "aws_iam_policy" "secrets-manager" {
  count = var.create_role && var.attach_secretsmanager_policy ? 1 : 0

  name_prefix = "${var.policy_name_prefix}${var.app_name}-"
  path        = var.role_path
  description = "Interact with Secrets Manager"
  policy      = data.aws_iam_policy_document.secrets-manager[0].json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "secrets-manager" {
  count = var.create_role && var.attach_secretsmanager_policy ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.secrets-manager[0].arn
}

################################################################################
# CloudWatch Policy for EC2 metrics
################################################################################
data "aws_iam_policy_document" "ec2_metrics" {
  count = var.create_role && var.attach_ec2_metrics_policy ? 1 : 0

  statement {
    sid = "AllowReadingMetricsFromCloudWatch"
    actions = [
      "cloudwatch:DescribeAlarmsForMetric",
      "cloudwatch:DescribeAlarmHistory",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricData",
      "cloudwatch:GetInsightRuleReport"
    ]
    resources = ["*"]
  }

  statement {
    sid = "AllowReadingTagsInstancesRegionsFromEC2"
    actions = ["ec2:DescribeTags", "ec2:DescribeInstances", "ec2:DescribeRegions"]
    resources = ["*"]
  }

  statement {
    sid = "AllowReadingResourcesForTags"
    actions = "tag:GetResources"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ec2_metrics" {
  count = var.create_role && var.attach_ec2_metrics_policy ? 1 : 0

  name_prefix = "${var.policy_name_prefix}${var.app_name}_Policy-"
  path        = var.role_path
  description = "View EC2 metrics"
  policy      = data.aws_iam_policy_document.ec2_metrics[0].json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ec2_metrics" {
  count = var.create_role && var.attach_ec2_metrics_policy ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.ec2_metrics[0].arn
}

################################################################################
# CloudWatch Policy for container insights
################################################################################
resource "aws_iam_role_policy_attachment" "insights_policy" {
  count      = var.create_role && var.attach_insights_policy ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = "arn:${local.partition}:iam::aws:policy/CloudWatchAgentServerPolicy"
}

################################################################################
# SQS Policy
################################################################################
locals {
  sqs_read_write_permissions = [
    "sqs:GetQueueUrl",
    "sqs:DeleteMessage",
    "sqs:ReceiveMessage",
    "sqs:SendMessage",
    "sqs:GetQueueAttributes"
  ]
}
data "aws_iam_policy_document" "sqs_read_write" {
  count = var.create_role && length(var.sqs_read_write_arns) > 0 ? 1 : 0

  statement {
    sid       = "SQSReadWrite"
    actions   = local.sqs_read_write_permissions
    resources = var.sqs_read_write_arns
  }
}
resource "aws_iam_policy" "sqs_read_write" {
  count = var.create_role && length(var.sqs_read_write_arns) > 0 ? 1 : 0

  name_prefix = "${var.policy_name_prefix}${var.app_name}-"
  path        = var.role_path
  description = "SQS Read/Write"
  policy      = data.aws_iam_policy_document.sqs_read_write[0].json

  tags = var.tags
}
resource "aws_iam_role_policy_attachment" "sqs_read_write" {
  count = var.create_role && length(var.sqs_read_write_arns) > 0 ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.sqs_read_write[0].arn
}
