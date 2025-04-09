variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "public_key_path" {
  description = "Path to your public key"
  default     = "~/.ssh/id_rsa.pub"
}
variable "dockerhub_username" {}
