provider "aws" {
  region = "us-east-1"
}

# Fetch the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"] # Amazon's official AMI owner ID

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Security Group to allow SSH
resource "aws_security_group" "allow_ssh" {
  name_prefix = "allow-ssh-"
  description = "Allow SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = "terraform-key" # Replace with your key pair
  subnet_id                   = data.aws_subnet.terraform-subnet.id
  vpc_security_group_ids = [data.aws_security_group.allow_tls.id]
  associate_public_ip_address = true

  tags = {
    Name = "AmazonLinuxInstance"
  }
}

output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "instance_id" {
  value = aws_instance.web.id
}
