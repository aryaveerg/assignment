variable "aws_region" {
  default = "us-east-1"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI or Ubuntu AMI"
}

variable "public_key_path" {
  description = "Path to your public SSH key"
}
