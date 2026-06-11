resource "aws_dynamodb_table" "visitor_counter" {
  name           = "userVisitsCounterTable"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "countId"

  attribute {
    name = "countId"
    type = "N"
  }

  tags = {
    Project = "VisitorCounter"
  }
}