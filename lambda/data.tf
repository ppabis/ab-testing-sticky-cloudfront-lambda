data "aws_instance" "AppInstanceV2" {
  instance_tags = {
    Name = "AppVersion2"
  }
}
