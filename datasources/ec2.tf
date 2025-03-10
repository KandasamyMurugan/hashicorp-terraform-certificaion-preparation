resource "aws_instance" "new-instance" {
  ami               = "ami-047a51fa27710816e"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  #availability_zone = "us-east-1b"
  key_name                    = "terraform-key"
  subnet_id                   = data.aws_subnet.terraform-subnet.id
  vpc_security_group_ids = [data.aws_security_group.allow_tls.id]
  associate_public_ip_address = true
  tags = {
    "Name"    = "web"
    "Project" = "Dev"
  }
}

terraform {
  backend "s3" {
    bucket = "state-locking-git-kandasamy"
    region = "us-east-1"
    key    = "data-source"
  }
}