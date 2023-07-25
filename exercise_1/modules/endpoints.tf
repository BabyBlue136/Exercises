# Ensure S3 API calls stay within the AWS backbone network
resource "aws_vpc_endpoint" "endpoint" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.region}.s3"

  route_table_ids = concat(aws_route_table.public_route_tables[*].id, aws_route_table.private_route_tables[*].id)
}
