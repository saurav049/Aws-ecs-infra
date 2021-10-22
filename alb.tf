resource "aws_alb" "myapp-lb" {
  name            = "myapp-load-balancer"
  subnets         = aws_subnet.myapp-subnet.*.id
  security_groups = [aws_security_group.myapp-sg.id]
}

resource "aws_alb_target_group" "myapp-tg" {
  name        = "myapp-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.myapp-vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.myapp-lb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.myapp-tg.id
    type             = "forward"
  }
}
