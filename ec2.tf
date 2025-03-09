resource "aws_instance" "existing_sg_ec2" {
  ami                    = "ami-08b5b3a93ed654d19"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_security_group.default.id]
}