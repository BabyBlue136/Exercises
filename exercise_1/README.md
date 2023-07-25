# Terraform Module: VPC with Internet Access

This Terraform module deploys a Virtual Private Cloud (VPC) with internet access, along with 4 subnets across 2 Availability Zones (AZs). It includes 2 public subnets for hosting an application load balancer, and 2 private subnets for hosting application servers with outbound internet access. The module also ensures that calls to the S3 API from within the VPC do not leave the AWS backbone network for security and cost reduction.

## Usage

```bash
# Change directory to the example folder
cd example/

# Initialize Terraform in the working directory
terraform init

# Review the Terraform execution plan
terraform plan
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| vpc_cidr_block | The CIDR block for the VPC | string | | yes |
| public_subnet_cidrs | List of CIDR blocks for the public subnets | list(string) | | yes |
| private_subnet_cidrs | List of CIDR blocks for the private subnets | list(string) | | yes |


## Example

```hcl
module "example" {
  source = "path/to/modules"

  vpc_cidr_block             = "10.0.0.0/16"
  public_subnet_cidr_blocks  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]
  region                     = "eu-central-1"

}
```

## Dependencies

 - The configuration specifies that it requires Terraform version 1.4.6
 - The configuration requires the hashicorp/aws provider version 5.9.0 or later.
