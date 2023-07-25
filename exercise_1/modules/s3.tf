resource "aws_s3_bucket" "lb_logs" {
  bucket = "my-test-bucket"

  tags = {
    Name = "my-test-bucket"
  }
}