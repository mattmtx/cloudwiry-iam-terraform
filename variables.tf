variable "cloudwiry_external_id" {
  description = "External-Id provided by Cloudwiry"
}

variable "s3_cur_bucket" {
  description = "Cost & Usage Report S3 bucket name - ex. company-billing - only required in Master Payer account"
  default     = ""
}

variable "cloudwiry_autopilot_enabled" {
  description = "When set to true, Cloudwiry role is granted permissions to execute EC2 RI Exchange Operations"
  default     = false
}

