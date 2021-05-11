#CW Event rule for lambda function
resource "aws_cloudwatch_event_rule" "gbfs-schedule" {
  name = "gbfs-schedule"
  description = "Trigger gbfs ingestion every minute"
  schedule_expression = "rate(1 minute)"
}

#CW event target for lambda function
resource "aws_cloudwatch_event_target" "gbfs-trigger-lambda" {
  rule      = aws_cloudwatch_event_rule.gbfs-schedule.name
  target_id = "aws_lambda_gbfs_ingester"
  arn       = aws_lambda_function.aws_lambda_gbfs_ingester.arn
}

#CW Permission to call lambda function
resource "aws_lambda_permission" "allow_cloudwatch_to_call_aws_lambda_function" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.aws_lambda_gbfs_ingester.arn
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.gbfs-schedule.arn
}

#Log group ingester for lambda function
resource "aws_cloudwatch_log_group" "gbfs-ingester-logging" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 14
}

#-------------------------------------------------------------------------------
#CLOUDWATCH PART FOR ALERT LAMBDA
#
#Log group alerting for lambda function
resource "aws_cloudwatch_log_group" "alert-logging" {
  name              = "/aws/lambda/${var.alert_function_name}"
  retention_in_days = 14
}

#CW Permission to call lambda alert function
resource "aws_lambda_permission" "alert_allow_cw" {
  statement_id  = "AllowAlertExecutionFromCloudWatch"
  function_name = aws_lambda_function.aws_lambda_alert.arn
  principal     = "logs.eu-central-1.amazonaws.com"
  action        = "lambda:InvokeFunction"
  source_arn    = aws_cloudwatch_log_group.gbfs-ingester-logging.arn
}

//------------------------------------------------------------------------
//BUG ON THIS METHOD TO CREATE LOG SUBSCRIPTION
//#CW Trigger alert on log
//resource "aws_cloudwatch_log_subscription_filter" "alert_error_gbfs" {
//  depends_on = [aws_lambda_permission.alert_allow_cw]
//  name = "alertFilter"
//  log_group_name = aws_cloudwatch_log_group.gbfs-ingester-logging.name
//  filter_pattern = "ERROR"
//  destination_arn = aws_lambda_function.aws_lambda_alert.arn
//}
