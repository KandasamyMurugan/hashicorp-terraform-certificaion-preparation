data "aws_vpc" "terraform-vpc" {

  id = "vpc-07a71f4ce364418ed"

}

data "aws_subnet" "terraform-subnet" {
  id = "subnet-04c5cccc0ff248028"
}

data "aws_security_group" "allow_tls" {
  id = "sg-00b0beb2d8e9474bf"
}