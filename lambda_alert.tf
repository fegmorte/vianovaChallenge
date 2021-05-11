resource "null_resource" "create_alert_package" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/create_alert_pkg.sh"

    environment = {
      source_code_path = var.alert_path_source_code
      function_name = var.alert_function_name
      path_module = path.module
      runtime = var.runtime
      path_cwd = path.cwd
    }
  }
}

data "archive_file" "create_alert_dist_pkg" {
  depends_on = [null_resource.create_alert_package]
  source_dir = "${path.cwd}/lambda_alert_dist_pkg/"
  output_path = var.alert_output_path
  type = "zip"
}

resource "aws_lambda_function" "aws_lambda_alert" {
  function_name = var.alert_function_name
  description = "Check if error in gbfs ingester and send email"
  handler = "lambda_alert.alert_function.lambda_handler"
  runtime = var.runtime

  role = aws_iam_role.lambda_exec_role.arn
  memory_size = 128
  timeout = 59

  depends_on = [
    null_resource.create_alert_package
  ]
  source_code_hash = data.archive_file.create_alert_dist_pkg.output_base64sha256
  filename = data.archive_file.create_alert_dist_pkg.output_path

  environment {
    variables = {
      snsARN = aws_sns_topic.sns-gbfs-error.arn
    }
  }
}