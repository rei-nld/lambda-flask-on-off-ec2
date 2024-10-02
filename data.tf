data "archive_file" "lambda_function" {
  type = "zip"
  source_file = "./lambda_function.py"
  output_path = "package.zip"
}

resource "aws_s3_object" "dependencies" {
  bucket = resource.aws_s3_bucket.largest_graveyard_mmxxiv.bucket
  key    = "dependencies.zip"
  source = "./dependencies.zip"
}

# resource "aws_s3_object" "lambda_function" {
#   bucket = resource.aws_s3_bucket.largest_graveyard_mmxxiv.bucket
#   key    = "lambda_function.py"
#   source = "./lambda_function.py"
# }