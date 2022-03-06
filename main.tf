provider "aws" {
  region   = "eu-west-1"
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "jm-tf-locks-table-infrajenkins"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}