# resource "aws_s3_bucket" "tf-state-bucket" {
#   bucket = "${terraform.workspace}-terraform-tutorial-tf-state-rezzadanialcs"
#   force_destroy = true
# }

# resource "aws_s3_bucket_versioning" "tf-state-versioning" {
#   bucket = aws_s3_bucket.tf-state-bucket.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "tf-state-bucket-sse" {
#   bucket = aws_s3_bucket.tf-state-bucket.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm     = "AES256"
#     }
#   }
# }