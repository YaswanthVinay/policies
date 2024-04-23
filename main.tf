terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket = "terraforms3bucket007"
    key    = "iamuser-policies/terraform.tfstate"
    region = "ap-south-1"
  }
}
resource "aws_iam_user" "users" {
  count = length(var.users)
  name  = "user-${var.users[count.index]}"
}

resource "aws_iam_group" "iam-group" {
  count = length(var.groups)
  name  = "Group-${var.groups[count.index]}"
}


resource "aws_iam_group_membership" "Dev" {
  name = "Dev"

  users = [
    aws_iam_user.users[0].name,
    aws_iam_user.users[1].name,
    aws_iam_user.users[2].name,
  ]

  group = aws_iam_group.iam-group[0].name
}
resource "aws_iam_group_membership" "DevOps" {
  name = "DevOps"

  users = [
    aws_iam_user.users[0].name,
    aws_iam_user.users[1].name,
    aws_iam_user.users[2].name,
    aws_iam_user.users[3].name
  ]

  group = aws_iam_group.iam-group[1].name
}
resource "aws_iam_group_membership" "Testing" {
  name = "Testing"

  users = [
    aws_iam_user.users[1].name,
    aws_iam_user.users[3].name,
    aws_iam_user.users[4].name
  ]
  group = aws_iam_group.iam-group[2].name
}

module "vpc" {

  source                = "./vpc-ec2"
  vpc_cidr              = var.vpc_cidr
  proj_name             = var.proj_name
  app-sn-cidr           = var.app-sn-cidr
  web-sn-cidr           = var.web-sn-cidr
  db-sn-cidr            = var.db-sn-cidr
  azs                   = var.azs
  igw_cidr              = var.igw_cidr
  user_name             = var.user_name
  instance_type         = var.instance_type
  iam-ec2-s3-role       = var.iam-ec2-s3-role
  instance_profile_name = var.iam_instance_profile

}



