variable "instance_type" {
  default="t2.micro"
  type=string
  description="Instance type for my EC2 Instance"
}

variable "tag_name" {
  type=string
  description="Tags name for my EC2 Instance"
}
