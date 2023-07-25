resource "aws_instance" "application_servers" {
  count                  = length(var.private_subnet_cidr_blocks)
  ami                    = "ami-0ec7f9846da6b0f61"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnets[count.index].id
  vpc_security_group_ids = [aws_security_group.application_server_sg.id]

  key_name                    = "my-test-keypair"
  associate_public_ip_address = false

  tags = {
    Name = "my-application-server-${count.index + 1}"
  }
}