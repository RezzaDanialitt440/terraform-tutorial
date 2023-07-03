# resource "aws_dynamodb_table" "tf-table" {
#   name           = "${terraform.workspace}-terraform-state-locking"
#   billing_mode   = "PAY_PER_REQUEST"
#   hash_key       = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }