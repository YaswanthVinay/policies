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


