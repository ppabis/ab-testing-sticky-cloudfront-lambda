data "aws_instance" "AppInstanceV1" {
  instance_tags = {
    Name = "AppVersion1"
  }
}

data "aws_instance" "AppInstanceV2" {
  instance_tags = {
    Name = "AppVersion2"
  }
}
