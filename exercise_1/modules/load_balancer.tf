resource "aws_lb" "app_lb" {
  name               = "my-test-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_sg.id]
  subnets            = [for subnet in aws_subnet.public_subnets : subnet.id]

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "test-lb"
    enabled = true
  }
}

resource "aws_lb_target_group" "app_lb_target_group" {
  name     = "my-test-lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

resource "aws_lb_target_group_attachment" "app-lb-tg-attachment" {
  for_each         = { for k, v in aws_instance.application_servers : k => v }
  target_group_arn = aws_lb_target_group.app_lb_target_group.arn
  target_id        = each.value.id
  port             = 80
}


resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_lb_target_group.arn
  }
}