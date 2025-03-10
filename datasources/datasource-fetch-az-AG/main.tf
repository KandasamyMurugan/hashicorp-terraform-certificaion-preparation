provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "az-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "AZ-VPC"
  }
}

resource "aws_internet_gateway" "az-internet" {

  vpc_id = aws_vpc.az-vpc.id

  tags = {
    Name = "az-igw"
  }

}
/*resource "aws_security_group" "allow_tls" {
  name   = "allow_tls"
  vpc_id = "${aws_vpc.az-vpc.id}"

}*/

resource "aws_subnet" "az-public-subnet" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.az-vpc.id
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "AZ-Subnet"
  }

}

resource "aws_launch_template" "az-launch-template" {
  name_prefix   = "AZ-Template"
  image_id      = "ami-08b5b3a93ed654d19"
  instance_type = "t2.micro"
  network_interfaces {
    associate_public_ip_address = "true"
  }
}

resource "aws_autoscaling_group" "az-asg" {
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = aws_subnet.az-public-subnet[*].id

  launch_template {
    id      = aws_launch_template.az-launch-template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ASG-Instances"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "az-sg" {
  vpc_id = "${aws_vpc.az-vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "azs" {
  value = data.aws_availability_zones.available.names
}

output "subnet_ids" {
  value = aws_subnet.az-public-subnet[*].id
}