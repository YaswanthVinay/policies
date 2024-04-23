resource "aws_iam_policy" "Dev-policy" {
  name   = "Dev_Team_policy"
  policy = data.aws_iam_policy_document.Dev_group_policy.json
}
resource "aws_iam_policy" "DevOps-policy" {
  name   = "DevOps_policy"
  policy = data.aws_iam_policy_document.DevOps_group_policy.json
}
resource "aws_iam_policy" "Testing-policy" {
  name   = "Testing_team_policy"
  policy = data.aws_iam_policy_document.Testing_group_policy.json
}

data "aws_iam_policy_document" "Dev_group_policy" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:*"]
    resources = ["*"]
  }
}
data "aws_iam_policy_document" "Testing_group_policy" {
  statement {
    effect    = "Allow"
    actions   = ["cloudwatch:*"]
    resources = ["*"]
  }
}
data "aws_iam_policy_document" "DevOps_group_policy" {
  statement {
    effect    = "Allow"
    actions   = ["cloudwatch:*"]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["ec2:*"]
    resources = ["*"]
  }
}
resource "aws_iam_group_policy_attachment" "Dev-attach" {
  group      = aws_iam_group.iam-group[0].name
  policy_arn = aws_iam_policy.Dev-policy.arn
}
resource "aws_iam_group_policy_attachment" "DevOps-attach" {
  group      = aws_iam_group.iam-group[1].name
  policy_arn = aws_iam_policy.DevOps-policy.arn
}
resource "aws_iam_group_policy_attachment" "Testing-attach" {
  group      = aws_iam_group.iam-group[2].name
  policy_arn = aws_iam_policy.Testing-policy.arn
}
//////////////////////////////////////////
#      Create IAM Role Using Terraform
///////////////////////////////////////////
# To create a IAM role for using it with the ec2 instance you need to do the following.

# Create IAM Policy with the required permission to AWS resources.
# Create IAM Role
# Attach the policy to the role.
# Create an instance profile and attach it to the role.

resource "aws_iam_policy" "iam-role-policy" {
  name   = "${var.iam-ec2-s3-role}-Policy-1"
  policy = data.aws_iam_policy_document.ec2_s3_role_policy.json
}

data "aws_iam_policy_document" "ec2_s3_role_policy" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:*"]
    resources = ["arn:aws:ec2:::*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["*"]
  }
}

# Create IAM Role

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_s3_role" {
  name               = "${var.iam-ec2-s3-role}-policy-1"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

# Attach the policy to the role.


resource "aws_iam_policy_attachment" "test-attach" {
  name = "${var.iam-ec2-s3-role}-PolicyAttachment-1"
  #users      = [aws_iam_user.user.name]
  roles = [aws_iam_role.ec2_s3_role.name]
  #groups     = [aws_iam_group.group.name]
  policy_arn = aws_iam_policy.iam-role-policy.arn
}


# Create an instance profile and attach it to the role

resource "aws_iam_instance_profile" "ec2-s3-instance-profile" {
  name = var.iam_instance_profile
  role = aws_iam_role.ec2_s3_role.name
}

variable "iam_instance_profile" {
  description = "The name of the IAM instance profile to associate with the EC2 instances."
  type        = string
  default     = "instance-profile"
}