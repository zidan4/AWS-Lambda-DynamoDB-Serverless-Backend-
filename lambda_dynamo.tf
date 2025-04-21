resource "aws_dynamodb_table" "users" {
  name           = "Users"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Name"

  attribute {
    name = "Name"
    type = "S"
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_lambda_function" "put_to_dynamo" {
  function_name = "PutToDynamo"
  filename      = "lambda_function_payload.zip"
  handler       = "lambda_dynamo.lambda_handler"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_exec.arn
}
