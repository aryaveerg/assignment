provider "aws" {
  region     = "ap-south-1" # Change if needed
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_key_pair" "deployer" {
  key_name   = "flask-key"
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "flask_sg" {
  name        = "flask-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "flask_vm" {
  ami           = "ami-0f5ee92e2d63afc18"  # Ubuntu 22.04 in ap-south-1
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.flask_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y docker.io
              systemctl start docker
              docker pull ${var.dockerhub_username}/flask-api
              docker run -d -p 5000:5000 --name flask-api ${var.dockerhub_username}/flask-api
            EOF

  tags = {
    Name = "FlaskAPI_VM"
  }
}

resource "aws_iam_role" "cloudwatch_role" {
  name = "cloudwatch-agent-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Effect    = "Allow",
      Sid       = ""
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_attach" {
  role       = aws_iam_role.cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "cloudwatch_profile" {
  name = "cloudwatch-instance-profile"
  role = aws_iam_role.cloudwatch_role.name
}

