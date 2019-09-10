# Access to read the Cost and Usage Reports
# https://aws.amazon.com/aws-cost-management/aws-cost-and-usage-reporting/
data "template_file" "s3_cur_bucket_policy" {
  template = <<POLICY
{
    "Sid": "CloudwiryCUR",
    "Effect": "Allow",
    "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetObjectAcl",
        "s3:GetObjectVersionAcl"
    ],
    "Resource": [
        "arn:aws:s3:::$${s3_cur_bucket}",
        "arn:aws:s3:::$${s3_cur_bucket}/*"
    ]
}
POLICY

  vars = {
    s3_cur_bucket = var.s3_cur_bucket
  }
}

# ce - access Cost and Usage data available in the API
# cloudwatch - access historical usage by instance type
# cur - describe cost and usage report settings
# ec2 - check the current instance type and status
# ec2:GetReservedInstancesExchangeQuote - Generate realtime quotes for RI recommendations
data "template_file" "recommendations_policy" {
  template = <<POLICY
{
    "Sid": "CloudwiryRecommendations",
    "Effect": "Allow",
    "Action": [
        "ce:*",
        "cloudwatch:Describe*",
        "cloudwatch:Get*",
        "cloudwatch:List*",
        "cur:DescribeReportDefinitions",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeRegions",
        "ec2:DescribeTags",
        "ec2:GetReservedInstancesExchangeQuote"
    ],
    "Resource": [
        "*"
    ]
}
POLICY

}

# ec2:PurchaseReservedInstancesOffering - purchase new EC2 RIs
# ec2:AcceptReservedInstancesExchangeQuote - perform CRI exchanges
# ec2:ModifyReservedInstances - Split and Merge existing RIs (no billing impact)
data "template_file" "autopilot_policy" {
template = <<POLICY
{
    "Sid": "CloudwiryAutopilot",
    "Effect": "Allow",
    "Action": [
        "ec2:PurchaseReservedInstancesOffering",
        "ec2:AcceptReservedInstancesExchangeQuote",
        "ec2:ModifyReservedInstances"
    ],
    "Resource": [
        "*"
    ]
}
POLICY

}

resource "aws_iam_role" "cloudwiry" {
name = "Share-Cloudwiry-Role"

assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
               "AWS": "arn:aws:iam::282711413064:root"
            },
            "Action": "sts:AssumeRole",
            "Condition": {
                "StringEquals": {
                    "sts:ExternalId": "${var.cloudwiry_external_id}"
                }
            }
        }
    ]
}
POLICY

}

resource "aws_iam_policy" "cloudwiry" {
  name = "Share-Cloudwiry-Role"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        ${data.template_file.recommendations_policy.rendered}
        ${var.s3_cur_bucket == "" ? "" : format(",%s", data.template_file.s3_cur_bucket_policy.rendered)}
        ${var.cloudwiry_autopilot_enabled == false ? "" : format(",%s", data.template_file.autopilot_policy.rendered)}
    ]
}
POLICY

}

resource "aws_iam_role_policy_attachment" "cloudwiry_role_policy_attachment" {
  role = aws_iam_role.cloudwiry.name
  policy_arn = aws_iam_policy.cloudwiry.arn
}

