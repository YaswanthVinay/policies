output "role" {
  value = aws_iam_role.ec2_s3_role.id

}
output "policy_name" {
  value = aws_iam_policy.iam-role-policy.name
}