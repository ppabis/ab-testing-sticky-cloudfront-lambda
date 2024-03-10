resource "aws_iam_role" "OriginSelectionLambdaRole" {
  name = "OriginSelectionLambdaRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      }
    }]
  })
}

data "aws_iam_policy_document" "DynamoDBSessionsTable" {
  statement {
    actions   = ["dynamodb:GetItem"]
    resources = ["arn:aws:dynamodb:*:*:table/SessionsTable"]
  }
}

resource "aws_iam_role_policy" "DynamoDBRead" {
  name   = "DynamoDBRead"
  role   = aws_iam_role.OriginSelectionLambdaRole.id
  policy = data.aws_iam_policy_document.DynamoDBSessionsTable.json
}
