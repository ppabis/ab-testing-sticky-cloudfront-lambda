data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/origin_selector.py"
  output_path = "${path.module}/origin_selector.zip"
}

resource "aws_lambda_function" "OriginSelector" {
  filename         = data.archive_file.lambda.output_path
  function_name    = "OriginSelector"
  role             = aws_iam_role.OriginSelectionLambdaRole.arn
  handler          = "origin_selector.handler"
  runtime          = "python3.11"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  publish          = true
}

