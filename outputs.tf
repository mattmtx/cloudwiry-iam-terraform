#output "cloudwiry_role_arn" {
#  value = "${aws_iam_role.cloudwiry.arn}"
#}
#
#output "cloudwiry_policy_arn" {
#  value = "${aws_iam_policy.cloudwiry.arn}"
#}

output "cloudwiry_external_id" {
  value = "${var.cloudwiry_external_id}"
}
