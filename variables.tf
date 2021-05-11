#---------------------------------------------
#COMMON VARIABLE
variable "runtime" {
  default = "python3.8"
}

#---------------------------------------------
#VARIABLE FOR LAMBDA INGESTER
variable "path_source_code" {
  default = "lambda_function"
}

variable "function_name" {
  default = "aws_lambda_gbfs_ingester"
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

#---------------------------------------------
# VARIABLE FOR LAMBDA ALERT
variable "endpoint_email_for_alert" {
  default = "frederic.egmorte@gmail.com"
}

variable "alert_path_source_code" {
  default = "lambda_alert"
}

variable "alert_function_name" {
  default = "aws_lambda_alert"
}

variable "alert_output_path" {
  description = "Path to function's deployment package into local filesystem. eg: /path/lambda_function.zip"
  default = "lambda_alert.zip"
}

variable "alert_distribution_pkg_folder" {
  description = "Folder name to create distribution files..."
  default = "lambda_alert_dist_pkg"
}
