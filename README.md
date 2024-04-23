
---
![iam-git](https://github.com/YaswanthVinay/policies/assets/97665352/e7cbde56-cdce-44ff-9b5d-1110bb400fe3)

# Terraform AWS Infrastructure Automation

This repository contains Terraform scripts for automating the creation of IAM roles, groups, users, policies, and EC2 instances within a custom VPC on AWS. The infrastructure setup enables seamless connectivity between EC2 instances and S3 buckets using IAM roles.

## Overview

The Terraform scripts are organized into modules, with separate modules for creating VPC and EC2 instances. The main use cases and functionality of each resource are outlined below:

### IAM Resources

#### IAM Role

- **Use Case:** IAM roles are used to delegate access to AWS resources securely. In this setup, IAM roles are assigned to EC2 instances to grant them permissions to access other AWS services such as S3 buckets.
- **Functionality:** Allows EC2 instances to assume a role and access AWS resources without the need for long-term credentials.

#### IAM Group

- **Use Case:** IAM groups are used to group IAM users and apply policies to multiple users at once.
- **Functionality:** Simplifies management by allowing policies to be attached to a group, which automatically applies to all users within that group.

#### IAM User

- **Use Case:** IAM users represent individual users or applications that interact with AWS services.
- **Functionality:** Users can be granted specific permissions and access keys for programmatic access to AWS services.

#### IAM Policy

- **Use Case:** IAM policies define permissions for IAM users, groups, and roles.
- **Functionality:** Policies specify what actions are allowed or denied on which AWS resources, providing granular control over access to resources.

### EC2 Instance

- **Use Case:** EC2 instances are virtual servers in the cloud used to run applications and host services.
- **Functionality:** By launching EC2 instances within a custom VPC, you can have full control over networking, security, and environment configurations.

### VPC (Virtual Private Cloud) Module

- **Use Case:** VPCs allow you to launch AWS resources in a virtual network that you define.
- **Functionality:** The VPC module creates a custom VPC with subnets, route tables, and internet gateway, providing isolation and security for your EC2 instances.

### Connecting to S3 Bucket

By utilizing IAM roles, EC2 instances launched within the VPC can securely access S3 buckets without the need for access keys or credentials stored on the instances. This setup enhances security and simplifies access management.

## Getting Started

To deploy the infrastructure:

1. Clone this repository to your local machine.
2. Navigate to the `VPC-EC2` folder.
3. Configure your AWS credentials in `provider.tf`.
4. Run `terraform init` to initialize the Terraform configuration.
5. Run `terraform plan` to view the proposed changes.
6. Run `terraform apply` to apply the Terraform configuration and create the infrastructure.

Ensure that you have appropriate permissions and have installed Terraform before proceeding.

## Contributions

Contributions to improve and expand this repository are welcome. If you encounter any issues or have suggestions for enhancements, feel free to open an issue or submit a pull request.

---




