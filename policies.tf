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

