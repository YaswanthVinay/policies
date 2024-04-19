variable "users" {
  type    = list(string)
  default = ["ram", "rajesh", "yash", "vinay", "rakesh"]
}
variable "groups" {
  type    = list(string)
  default = ["Dev", "DevOps", "Testing"]
}
variable "iam-ec2-s3-role" {
  type        = string
  description = "role for access EC2 and s3"
  default     = "EC2-S3-AccessRole"
}
variable "region" {
  type    = string
  default = "ap-south-1"
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "proj_name" {
  type    = string
  default = "thanos"
}
variable "app-sn-cidr" {
  type        = list(string)
  description = "List of CIDRs for the application subnets."
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "azs" {
  type        = list(string)
  description = "azs"
  default     = ["ap-south-1a", "ap-south-1b"]
}
variable "db-sn-cidr" {
  type        = list(string)
  description = "List of CIDRs for the database subnets."

  default = ["10.0.101.0/24", "10.0.102.0/24"]
}
variable "web-sn-cidr" {
  type        = list(string)
  description = "List of CIDRs for the web subnets."
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}
variable "igw_cidr" {
  type        = string
  description = "cidr range of IGW"
  default     = "0.0.0.0/0"
}
variable "user_name" {
  type    = list(string)
  default = ["superman", "robinhood"]
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}

