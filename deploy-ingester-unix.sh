#!/bin/bash

echo "----------------------------------------------------------------------------"
echo "Starting deploy-ingester"
echo "terraform init -input=false"
terraform init -input=false

terraform plan -input=false

terraform apply -auto-approve

echo "----------------------------------------------------------------------------"
echo "Trying to add lambda permission and subscription filter via AWS CLI"
echo "Adding lambda permission via AWS CLI"
id_caller=$(aws sts get-caller-identity --query 'Account' --output text)
aws lambda add-permission \
      --function-name "arn:aws:lambda:eu-central-1:"${id_caller}":function:aws_lambda_alert" \
      --statement-id "alertPermission" \
      --principal "logs.eu-central-1.amazonaws.com" \
      --action "lambda:InvokeFunction" \
      --source-arn "arn:aws:logs:eu-central-1:"${id_caller}":log-group:/aws/lambda/aws_lambda_gbfs_ingester:*"
echo "----------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------"
echo "Adding subscription filter via AWS CLI"
aws logs put-subscription-filter \
        --log-group-name "/aws/lambda/aws_lambda_gbfs_ingester" \
        --filter-name "alertFilter" \
        --filter-pattern "ERROR" \
        --destination-arn "arn:aws:lambda:eu-central-1:"${id_caller}":function:aws_lambda_alert"

echo "----------------------------------------------------------------------------"
echo "SUCCES - GBFS ingester deployed !"
echo "BE CAREFUL - Think to confirm your SNS Subscription email in order to receive alert ! "
