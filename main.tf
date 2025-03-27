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

# Genera un suffisso univoco per il nome del bucket e della funzione
resource "random_id" "bucket_suffix" {
  byte_length = 8
}

# Crea il bucket S3 con il nome univoco
resource "aws_s3_bucket" "lambdabucket" {
  bucket = "lambda-bucket-${random_id.bucket_suffix.hex}"  # Aggiungi il suffisso univoco
}

# Crea la funzione Lambda con il nome univoco
resource "aws_lambda_function" "task-service" {
  function_name = "task-service"  # Aggiungi il suffisso univoco
  s3_bucket    = aws_s3_bucket.lambdabucket.bucket  # Usa il bucket creato
  s3_key       = "task-service.zip"
  runtime      = "provided.al2023"
  handler      = "main"
  role         = aws_iam_role.bil.arn
}
