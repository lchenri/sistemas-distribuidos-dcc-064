resource "aws_security_group" "lambda_sistemas_distribuidos" {
  name        = "lambda_sistemas_distribuidos_sg"
  description = "Permite acesso HTTP"
  vpc_id      = aws_vpc.vpc_sistemas_distribuidos.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "lambda_sistemas_distribuidos_sg"
  }
}