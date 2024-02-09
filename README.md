# batcave-tf-irsa

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.secrets-manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.sops](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.sqs_read_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.insights_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.secrets-manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.sops](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.sqs_read_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.secrets-manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sops](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sqs_read_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | App name (ie. Flux, Velero, etc.) | `string` | `""` | no |
| <a name="input_assume_role_condition_test"></a> [assume\_role\_condition\_test](#input\_assume\_role\_condition\_test) | Name of the [IAM condition operator](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_condition_operators.html) to evaluate when assuming the role | `string` | `"StringEquals"` | no |
| <a name="input_attach_cloudwatch_policy"></a> [attach\_cloudwatch\_policy](#input\_attach\_cloudwatch\_policy) | Determines whether to attach the cloudwatch permissions to the role | `bool` | `false` | no |
| <a name="input_attach_dynamodb_policy"></a> [attach\_dynamodb\_policy](#input\_attach\_dynamodb\_policy) | Determines whether to attach the dynamodb policy to the role | `bool` | `false` | no |
| <a name="input_attach_ec2_policy"></a> [attach\_ec2\_policy](#input\_attach\_ec2\_policy) | Determines whether to attach the ec2 permissions to the role | `bool` | `false` | no |
| <a name="input_attach_insights_policy"></a> [attach\_insights\_policy](#input\_attach\_insights\_policy) | Determines whether to attach the CloudWatch Insights policy to the role | `bool` | `false` | no |
| <a name="input_attach_s3_policy"></a> [attach\_s3\_policy](#input\_attach\_s3\_policy) | Determines whether to attach the S3 to the role | `bool` | `false` | no |
| <a name="input_attach_secretsmanager_policy"></a> [attach\_secretsmanager\_policy](#input\_attach\_secretsmanager\_policy) | Determines whether to attach the secrets manager permissions to the role | `bool` | `false` | no |
| <a name="input_attach_sops_policy"></a> [attach\_sops\_policy](#input\_attach\_sops\_policy) | Determines whether to attach the SOPS policy to the role | `bool` | `false` | no |
| <a name="input_attach_tags_policy"></a> [attach\_tags\_policy](#input\_attach\_tags\_policy) | Determines whether to attach the tags permissions to the role | `bool` | `false` | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | Whether to create a role | `bool` | `true` | no |
| <a name="input_dynamodb_arn"></a> [dynamodb\_arn](#input\_dynamodb\_arn) | Dynamodb table to allow access to | `string` | `""` | no |
| <a name="input_force_detach_policies"></a> [force\_detach\_policies](#input\_force\_detach\_policies) | Whether policies should be detached from this role when destroying | `bool` | `true` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum CLI/API session duration in seconds between 3600 and 43200 | `number` | `null` | no |
| <a name="input_oidc_providers"></a> [oidc\_providers](#input\_oidc\_providers) | Map of OIDC providers where each provider map should contain the `provider`, `provider_arn`, and `namespace_service_accounts` | `any` | <pre>{<br>  "one": {<br>    "namespace_service_accounts": [<br>      "default:default"<br>    ],<br>    "provider_arn": ""<br>  }<br>}</pre> | no |
| <a name="input_policy_name_prefix"></a> [policy\_name\_prefix](#input\_policy\_name\_prefix) | IAM policy name prefix | `string` | `"AmazonEKS_"` | no |
| <a name="input_role_description"></a> [role\_description](#input\_role\_description) | IAM Role description | `string` | `null` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of IAM role | `string` | `"vpc-cni"` | no |
| <a name="input_role_path"></a> [role\_path](#input\_role\_path) | Path of IAM role | `string` | `"/delegatedadmin/developer/"` | no |
| <a name="input_role_permissions_boundary_arn"></a> [role\_permissions\_boundary\_arn](#input\_role\_permissions\_boundary\_arn) | Permissions boundary ARN to use for IAM role | `string` | `"arn:aws:iam::373346310182:policy/cms-cloud-admin/developer-boundary-policy"` | no |
| <a name="input_role_policy_arns"></a> [role\_policy\_arns](#input\_role\_policy\_arns) | ARNs of any policies to attach to the IAM role | `map(string)` | `{}` | no |
| <a name="input_s3_bucket_arns"></a> [s3\_bucket\_arns](#input\_s3\_bucket\_arns) | List of S3 Bucket ARNs to allow access to | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_secret_arns"></a> [secret\_arns](#input\_secret\_arns) | ARNs of secrets in secrets manager to add to policy | `list(string)` | `[]` | no |
| <a name="input_sops_arn"></a> [sops\_arn](#input\_sops\_arn) | SOPS ARN to allow access to | `string` | `""` | no |
| <a name="input_sqs_read_write_arns"></a> [sqs\_read\_write\_arns](#input\_sqs\_read\_write\_arns) | List of SQS ARNs to allow read/write access to | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add the the IAM role | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of IAM role |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | Name of IAM role |
| <a name="output_iam_role_path"></a> [iam\_role\_path](#output\_iam\_role\_path) | Path of IAM role |
| <a name="output_iam_role_unique_id"></a> [iam\_role\_unique\_id](#output\_iam\_role\_unique\_id) | Unique ID of IAM role |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
