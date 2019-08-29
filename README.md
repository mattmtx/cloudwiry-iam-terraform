# terraform-cloudwiry-iam
Terraform config for onboarding with Cloudwiry.com

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| enable\_cloudwiry\_autopilot | When set to true, Cloudwiry role is granted permissions to execute approved recommendations | string | `"false"` | no |
| external\_id | External-Id provided by Cloudwiry | string | n/a | yes |
| role\_name | IAM Role and Policy Name | string | `"Cloudwiry-Role"` | no |
| s3\_cur\_bucket | Cost & Usage Report S3 bucket name - ex. company-billing - only required in Master Payer account | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cloudwiry\_external\_id |  |
| cloudwiry\_policy\_arn |  |
| cloudwiry\_role\_arn |  |

## Usage
A Cloudwiry Account Manager will provide the required external-id specific to your Cloudwiry account.  

It can be passed in directly, if calling terraform-cloudwiry-iam as a module.
OR
The external-id value can be passed into terraform in a *.tfvar file, like:
```
cloudwiry_external_id = CW_abc123
```
OR it can be passed in as an environment variable, like:
```bash
export TF_VAR_cloudwiry_external_id=CW_abc123
```

Then you can call the terraform-cloudwiry-iam module:
```
module "cloudwiry_iam_role" {
  source = "github.com/mattmtx/terraform-cloudwiry-iam"
  external-id = "CW_abc123"
  s3_cur_bucket = "company-billing"
  cloudwiry_autopilot_enabled = true
}
```

Run terraform plan and apply
```bash
terraform plan -target=module.cloudwiry_iam_role
terraform apply -target=module.cloudwiry_iam_role
```

You can retrieve the outputs from the module with the output command:
```bash
terraform output -module=cloudwiry_iam_role
```

## Doc Generation
The Inputs and Outputs sections should be generated using [terraform-docs](https://github.com/segmentio/terraform-docs).

Generate them like so:
```bash
terraform-docs markdown terraform/ | cat -s | ghead -n -1
```
