resource "aws_instance" "host" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  key_name                    = var.key_pair_name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.sg_id]
  associate_public_ip_address = true

  user_data = file("${path.root}/user_data.sh")

  tags = {
    Name = "StudentAppBastionHost"
  }
}