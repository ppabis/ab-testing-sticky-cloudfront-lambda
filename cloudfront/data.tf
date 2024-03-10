data "aws_instance" "AppInstanceV1" {
  instance_tags = {
    Name = "AppVersion1"
  }
}

data "aws_lambda_function" "origin_request" {
  function_name = "OriginSelector"
}
