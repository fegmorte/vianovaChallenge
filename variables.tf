variable "path_source_code" {
  default = "lambda_function"
}

variable "function_name" {
  default = "aws_lambda_gbfs_ingester"
}

variable "runtime" {
  default = "python3.8"
}

variable "output_path" {
  description = "Path to function's deployment package into local filesystem. eg: /path/lambda_function.zip"
  default = "lambda_function.zip"
}

variable "distribution_pkg_folder" {
  description = "Folder name to create distribution files..."
  default = "lambda_dist_pkg"
}

variable "gbfs_bucket" {
  description = "Bucket name for gbfs json"
  default = "gbfs-bucket"
}