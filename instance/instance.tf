data "aws_ssm_parameter" "AL2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-arm64"
}

resource "aws_instance" "AppInstance" {
  count                  = 2
  ami                    = data.aws_ssm_parameter.AL2023.value
  instance_type          = "t4g.nano"
  iam_instance_profile   = aws_iam_instance_profile.AppEC2Role.name
  vpc_security_group_ids = [aws_security_group.AppEC2.id]
  user_data              = <<-EOF
  #!/bin/bash
  yum install -y docker
  systemctl enable --now docker
  usermod -aG docker ec2-user
  EOF
  tags = {
    Name = "AppVersion${count.index + 1}"
  }
}
