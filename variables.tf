variable "cluster_name" {}
variable "cluster_oidc_issuer_url" {}
variable "k8s_service_account_namespace" {}
variable "k8s_service_account_name" {}
variable "create_role" {}
variable "create_autoscaler_policy" {}
variable "create_velero_policy" {}
variable "role_path" {}
variable "tags" {}
variable "policy_name_prefix" {}
variable "cluster_autoscaler_cluster_ids" {}
variable "permissions_boundary" {}


################################################################################
# Policies
################################################################################
# Velero
variable "attach_velero_policy" {
  description = "Determines whether to attach the Velero IAM policy to the role"
  type        = bool
  default     = false
}

variable "velero_s3_bucket_arns" {
  description = "List of S3 Bucket ARNs that Velero needs access to in order to backup and restore cluster resources"
  type        = list(string)
  default     = ["*"]
}
