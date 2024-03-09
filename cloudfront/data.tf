data "aws_instance" "AppInstanceV1" {
  instance_tags = {
    Name = "AppVersion1"
  }
}
