variable "aws_region" {
  default = "us-east-2"
}
variable "access_key" { }
variable "secret_key" { }

locals {
  lambda_zip_path = "${path.module}/mylambda.zip"
 }
