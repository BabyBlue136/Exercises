resource "aws_nat_gateway" "nat_gateways" {
  depends_on = [aws_internet_gateway.igw]

  count         = length(aws_subnet.public_subnets)
  allocation_id = aws_eip.nat_eips[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = {
    Name = "my-nat-gateway-${count.index + 1}"
  }
}

resource "aws_eip" "nat_eips" {
  count  = length(aws_subnet.public_subnets)
  domain = "vpc"

  tags = {
    Name = "my-nat-eip-${count.index + 1}"
  }
}