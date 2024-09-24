resource "aws_instance" "prometheus" {
    count           = var.ec2_count  
    ami             = var.ami_id
    instance_type   = var.instance_type
    subnet_id       = var.subnet_id
    user_data       = var.user_data
    security_groups = [aws_security_group.prometheus_sg.name]
    tags = {Name = "Prometheus Server"}
}

resource "aws_security_group" "prometheus_sg" {
    name        = "prometheus_sg"
    description = "Allow access to Prometheus server"
    vpc_id = var.vpc_id
    ingress {
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
}
