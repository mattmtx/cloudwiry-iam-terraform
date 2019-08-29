variable "role_name" {
  description = "IAM Role and Policy Name"
  default     = "Cloudwiry-Role"
}

variable "external_id" {
  description = "External-Id provided by Cloudwiry"
}

variable "s3_cur_bucket" {
  description = "Cost & Usage Report S3 bucket name - ex. company-billing - only required in Master Payer account"
}

variable "enable_cloudwiry_autopilot" {
  description = "When set to true, Cloudwiry role is granted permissions to execute approved recommendations"
  default     = false
}
