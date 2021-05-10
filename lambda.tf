resource "null_resource" "install_python_dependencies" {
  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/create_pkg.sh"

    environment = {
      source_code_path = var.path_source_code
      function_name = var.function_name
      path_module = path.module
      runtime = var.runtime
      path_cwd = path.cwd
    }
  }
}

data "archive_file" "create_dist_pkg" {
  depends_on = [null_resource.install_python_dependencies]
  source_dir = "${path.cwd}/lambda_dist_pkg/"
  output_path = var.output_path
  type = "zip"
}

resource "aws_lambda_function" "aws_lambda_gbfs_ingester" {
  function_name = var.function_name
  description = "Ingest GBFS data every minute"
  handler = "lambda_function.lambda.lambda_handler"
  runtime = var.runtime

  role = aws_iam_role.lambda_exec_role.arn
  memory_size = 128
  timeout = 59

  depends_on = [null_resource.install_python_dependencies]
  source_code_hash = data.archive_file.create_dist_pkg.output_base64sha256
  filename = data.archive_file.create_dist_pkg.output_path

  environment {
    variables = {
      URL = "https://mds.bird.co/gbfs/tempe/free_bike_status.json"
      S3_BUCKET_NAME = var.gbfs_bucket
    }
  }
}