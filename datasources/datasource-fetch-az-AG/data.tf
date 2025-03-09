data "aws_availability_zones" "available" {
  state = "available"
}

/*locals {
  selected_azs = ["us-east-1a", "us-east-1b", "us-east-1c"]  # Replace with valid AZs
}*/

data "aws_security_group" "allow_tls" {
  id = "sg-00b0beb2d8e9474bf"
}

/*data "aws_security_group" "west-aa" {
  id = "sg-05c9a947ea5d8c1d7"
}*/
