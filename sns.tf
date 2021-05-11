  resource "aws_sns_topic" "sns-gbfs-error" {
    name = "sns-gbfs-error"
  }

  resource "aws_sns_topic_subscription" "alert_sns_subscription" {
    endpoint = var.endpoint_email_for_alert
    protocol = "email"
    topic_arn = aws_sns_topic.sns-gbfs-error.arn
  }