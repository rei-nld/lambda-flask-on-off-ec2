resource "aws_lambda_layer_version" "dependencies" {
  layer_name = "dependencies"

  filename = "dependencies.zip"

  compatible_runtimes = ["python3.12"]
}

resource "aws_lambda_function" "on-off" {
  function_name = "on-off"

  filename = data.archive_file.lambda_function.output_path

  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"
  role    = resource.aws_iam_role.lambda_execution_role.arn

  layers = [resource.aws_lambda_layer_version.dependencies.arn]

  timeout = 60
  memory_size = 256

  environment {
    variables = {
      GITLAB_INSTANCE_ID = module.ec2_instance["1"].id
    }
  }

  depends_on = [resource.aws_s3_object.dependencies]
}

resource "aws_lambda_function_url" "on-off" {
  function_name      = resource.aws_lambda_function.on-off.function_name
  authorization_type = "NONE"
}
