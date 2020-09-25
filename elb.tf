resource "aws_lb" "example" {
  name               = "terraform-lb-example"
  # availability_zones = data.aws_availability_zones.all.name
  load_balancer_type = "application"
  subnets = data.aws_subnet_ids.default.ids
  security_groups    = [aws_security_group.elb.id]

  # listener {
  #  lb_port           = 80
  #  lb_protocol       = "http"
  #  instance_port     = var.server_port
  #  instance_protocol = "http"
  # }

  # helth_check {
  #  healthy_threshold   = 2
  #  unhealthy_threshold = 2
  #  timeout             = 3
  #  interval            = 30
  #  taget               = "HTTP:var.server_port/"
  # }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code = 404
    }
  }
}

resource "aws_lb_target_group" "asg" {
  name = "terraform-asg-example"

  port = var.server_port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}