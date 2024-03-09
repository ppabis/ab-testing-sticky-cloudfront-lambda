resource "aws_dynamodb_table" "sessions" {
  name         = "SessionsTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "token"

  attribute {
    name = "token"
    type = "S"
  }

  ttl {
    attribute_name = "expiration"
    enabled        = true
  }

  replica {
    region_name = "ap-southeast-1"
  }

  replica {
    region_name = "eu-west-1"
  }
}
