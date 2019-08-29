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
  vars {
    s3_cur_bucket = "${var.s3_cur_bucket}"
  }
}

data "template_file" "recommendations_policy" {
  template = <<POLICY
{
    "Sid": "CloudwiryRecommendations",
    "Effect": "Allow",
    "Action": [
        "aws-portal:ViewBilling",
        "aws-portal:ViewUsage",
        "autoscaling:Describe*",
        "ce:*"
        "cloudformation:Get*",
        "cloudformation:List*",
        "cloudformation:Describe*",
        "cloudfront:Get*",
        "cloudfront:List*",
        "cloudtrail:Get*",
        "cloudtrail:DescribeTrails",
        "cloudtrail:ListTags",
        "cloudwatch:Describe*",
        "cloudwatch:Get*",
        "cloudwatch:List*",
        "config:Get*",
        "config:Describe*",
        "config:Deliver*",
        "config:List*",
        "cur:Describe*",
        "cur:PutReportDefinition",
        "dms:Describe*",
        "dynamodb:Describe*",
        "dynamodb:List*",
        "elasticloadbalancing:Describe*",
        "ec2:Describe*",
        "ec2:GetReservedInstancesExchangeQuote",
        "ecs:Describe*",
        "ecs:List*",
        "elasticache:Describe*",
        "elasticache:ListTagsForResource",
        "elasticbeanstalk:Check*",
        "elasticbeanstalk:Describe*",
        "elasticbeanstalk:List*",
        "elasticbeanstalk:RequestEnvironmentInfo",
        "elasticbeanstalk:RetrieveEnvironmentInfo",
        "elasticloadbalancing:Describe*",
        "elasticmapreduce:Describe*",
        "elasticmapreduce:List*",
        "elasticfilesystem:DescribeFileSystems",
        "elasticfilesystem:DescribeTags",
        "es:Describe*",
        "es:List*",
        "firehose:ListDeliveryStreams",
        "firehose:DescribeDeliveryStream",
        "iam:GenerateCredentialReport",
        "iam:Get*",
        "iam:List*",
        "kinesis:Describe*",
        "kinesis:List*",
        "kms:ListKeys",
        "lambda:List*",
        "logs:Describe*",
        "organizations:ListAccounts",
        "redshift:Describe*",
        "route53:Get*",
        "route53:List*",
        "rds:Describe*",
        "rds:ListTagsForResource",
        "s3:List*",
        "s3:GetAnalyticsConfiguration",
        "s3:GetLifecycleConfiguration",
        "s3:GetBucketAcl",
        "s3:GetBucketPolicy",
        "s3:GetBucketTagging",
        "s3:GetBucketLocation",
        "s3:GetBucketLogging",
        "s3:GetBucketVersioning",
        "s3:GetBucketWebsite",
        "sagemaker:Describe*",
        "sagemaker:List*",
        "sdb:GetAttributes",
        "sdb:List*",
        "ses:Get*",
        "ses:List*",
        "sns:Get*",
        "sns:List*",
        "sqs:GetQueueAttributes",
        "sqs:ListQueues",
        "storagegateway:Describe*"
        "storagegateway:List*",
        "workspaces:Describe*"
    ],
    "Resource": [
        "*"
    ]
}POLICY
}

data "template_file" "autopilot_policy" {
  template = <<POLICY
{
    "Sid": "CloudwiryAutopilot",
    "Effect": "Allow",
    "Action": [
        "s3:PutAnalyticsConfiguration",
        "s3:PutLifecycleConfiguration",
        "ec2:PurchaseReservedInstancesOffering",
        "ec2:AcceptReservedInstancesExchangeQuote",
        "ec2:GetReservedInstancesExchangeQuote",
        "ec2:ModifyReservedInstances",
        "ec2:CreateTags",
        "ec2:CreateSnapshot",
        "ec2:DeleteSnapshot",
        "ec2:DeleteVolume",
        "ec2:StartInstances",
        "ec2:StopInstances",
        "ec2:RebootInstances",
        "ec2:releaseAddress"
    ],
    "Resource": [
        "*"
    ]
}
POLICY
}

resource "aws_iam_role" "cloudwiry" {
  name = "${var.cloudwiry_role_name}"

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

data "template_file" "foo" {
  template = "bar"
}

resource "aws_iam_policy" "cloudwiry" {
  name = "${var.cloudwiry_role_name}"

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
  role       = "${aws_iam_role.cloudwiry.name}"
  policy_arn = "${aws_iam_policy.cloudwiry.arn}"
}
