data "aws_iam_policy_document" "this" {
  count = var.create_role ? 1 : 0

  dynamic "statement" {
    for_each = var.oidc_providers

    content {
      effect  = "Allow"
      actions = ["sts:AssumeRoleWithWebIdentity"]

      principals {
        type        = "Federated"
        identifiers = [statement.value.provider_arn]
      }

      condition {
        test     = var.assume_role_condition_test
        variable = "${replace(statement.value.provider_arn, "/^(.*provider/)/", "")}:sub"
        values   = [for sa in statement.value.namespace_service_accounts : "system:serviceaccount:${sa}"]
      }

      condition {
        test     = var.assume_role_condition_test
        variable = "${replace(statement.value.provider_arn, "/^(.*provider/)/", "")}:aud"
        values   = ["sts.amazonaws.com"]
      }
    }
  }
}

resource "aws_iam_role" "this" {
  count = var.create_role ? 1 : 0

  name        = var.role_name
  path        = var.role_path
  description = var.role_description

  assume_role_policy    = data.aws_iam_policy_document.this[0].json
  max_session_duration  = var.max_session_duration
  permissions_boundary  = var.role_permissions_boundary_arn
  force_detach_policies = var.force_detach_policies

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = { for k, v in var.role_policy_arns : k => v if var.create_role }

  role       = aws_iam_role.this[0].name
  policy_arn = each.value
}

resource "aws_iam_policy" "namespace_secrets_policy" {
  for_each = var.namespace_secrets

  name        = "${each.key}-secrets-manager-policy"
  description = "Policy for accessing secrets in namespace ${each.key}"
  path        = var.role_path
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Effect   = "Allow",
        Resource = each.value
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "namespace_secrets_attachment" {
  for_each = var.namespace_secrets

  policy_arn = aws_iam_policy.namespace_secrets_policy[each.key].arn
  role       = aws_iam_role.this[0].name
}

