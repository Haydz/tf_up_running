variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
  default = "haydn-test-stuff-2"
}

# variable "table_name" {
#   description = "The name of the DynamoDB table. Must be unique in this AWS account."
#   type        = string
# }