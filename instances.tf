resource "aws_launch_configuration" "example" {
  image_id        = var.aws_ami
  instance_type   = var.aws_instatype
  security_groups = [aws_security_group.instance.id]

  user_data = file("server_apache.sh")

  lifecycle {
    create_before_destroy = true
  }
}