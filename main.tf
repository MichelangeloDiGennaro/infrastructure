provider "aws" {
    region     = "eu-west-1"
    access_key = ""
    secret_key = ""
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "bil" {
  name               = "bil"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_dynamodb_table" "tasks_dynamodb_table" {
  name           = "Tasks"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "task_id"

  attribute {
    name = "task_id"
    type = "S"
  }
}

# Crea la funzione Lambda con il nome univoco
resource "aws_lambda_function" "task-service" {
  function_name = "task-service"  # Aggiungi il suffisso univoco
  filename     = "task-service.zip"
  runtime      = "provided.al2023"
  handler      = "main"
  role         = aws_iam_role.bil.arn
}