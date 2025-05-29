resource "aws_instance" "prometheus" {
  ami                    = data.aws_ami.joindevops.id 
  vpc_security_group_ids = [aws_security_group.prometheus.id]
  instance_type          = "t3.micro"
  subnet_id   = var.subnet_id

  user_data = file("prometheus.sh")

  iam_instance_profile        = aws_iam_instance_profile.prometheus_instance_profile.name
  
  tags = {
    Name = "prometheus"
  }
  depends_on = [aws_instance.node_exporter]
}

resource "aws_instance" "node_exporter" {
  ami                    = data.aws_ami.joindevops.id 
  vpc_security_group_ids = [aws_security_group.prometheus.id]
  instance_type          = "t3.micro"
  subnet_id   = var.subnet_id
  
  user_data = file("node_exporter.sh")
  
  tags = {
    Name = "node-exporter"
    Monitoring = "true"
  }
}

resource "aws_security_group" "prometheus" {
  name        = "prometheus"
  description = "Allow TLS inbound traffic and all outbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prometheus"
  }
}
