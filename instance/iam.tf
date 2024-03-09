resource "aws_iam_role" "AppEC2Role" {
  name = "AppEC2Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "AppEC2Role" {
  name = "AppEC2Role"
  role = aws_iam_role.AppEC2Role.name
}

resource "aws_iam_role_policy_attachment" "AppEC2RoleSSM" {
  role       = aws_iam_role.AppEC2Role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "DynamoDBSessionsTable" {
  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:DeleteItem",
      "dynamodb:UpdateItem"
    ]
    resources = ["arn:aws:dynamodb:*:*:table/SessionsTable"]
  }
}

resource "aws_iam_policy" "DynamoDBSessionsTable" {
  name        = "DynamoDBSessionsTable"
  description = "Provides read/write access to the SessionsTable"
  policy      = data.aws_iam_policy_document.DynamoDBSessionsTable.json
}

resource "aws_iam_role_policy_attachment" "DynamoDBSessionsTable" {
  role       = aws_iam_role.AppEC2Role.name
  policy_arn = aws_iam_policy.DynamoDBSessionsTable.arn
}
