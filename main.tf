provider "aws" {
    region = ""
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
  hash_key       = "TaskID"

  attribute {
    name = "TaskID"
    type = "S"
  }
}

#resource "aws_lambda_function" "task_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  #filename      = "lambda_function_payload.zip"
  #function_name = "task-service"
  #role          = aws_iam_role.bil.arn
  #handler       = "index.test"

  #source_code_hash = data.archive_file.lambda.output_base64sha256

  #runtime = "provided.al2023"
#}

#data "archive_file" "lambda" {
  #type        = "zip"
  #source_file = "lambda.js"
  #output_path = "lambda_function_payload.zip"
#}