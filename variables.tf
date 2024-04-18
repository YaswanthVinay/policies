variable "users" {
  type    = list(string)
  default = ["ram", "rajesh", "yash", "vinay", "rakesh"]
}
variable "groups" {
  type    = list(string)
  default = ["Dev", "DevOps", "Testing"]
}