resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "lambda_policy_doc" {
  statement {
    sid = "AllowS3Bucket"
    effect = "Allow"

    actions = [
      "s3:PutAnalyticsConfiguration",
      "s3:PutAccessPointConfigurationForObjectLambda",
      "s3:GetObjectVersionTagging",
      "s3:DeleteAccessPoint",
      "s3:CreateBucket",
      "s3:DeleteAccessPointForObjectLambda",
      "s3:GetStorageLensConfigurationTagging",
      "s3:ReplicateObject",
      "s3:GetObjectAcl",
      "s3:GetBucketObjectLockConfiguration",
      "s3:DeleteBucketWebsite",
      "s3:GetIntelligentTieringConfiguration",
      "s3:DeleteJobTagging",
      "s3:PutLifecycleConfiguration",
      "s3:GetObjectVersionAcl",
      "s3:PutObjectTagging",
      "s3:DeleteObject",
      "s3:DeleteObjectTagging",
      "s3:GetBucketPolicyStatus",
      "s3:GetObjectRetention",
      "s3:GetBucketWebsite",
      "s3:GetJobTagging",
      "s3:DeleteStorageLensConfigurationTagging",
      "s3:PutReplicationConfiguration",
      "s3:DeleteObjectVersionTagging",
      "s3:PutObjectLegalHold",
      "s3:GetObjectLegalHold",
      "s3:GetBucketNotification",
      "s3:PutBucketCORS",
      "logs:CreateLogGroup",
      "s3:GetReplicationConfiguration",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:GetObject",
      "s3:PutBucketNotification",
      "s3:DescribeJob",
      "s3:PutBucketLogging",
      "s3:GetAnalyticsConfiguration",
      "s3:PutBucketObjectLockConfiguration",
      "s3:GetObjectVersionForReplication",
      "s3:GetAccessPointForObjectLambda",
      "s3:GetStorageLensDashboard",
      "s3:CreateAccessPoint",
      "s3:GetLifecycleConfiguration",
      "s3:GetInventoryConfiguration",
      "s3:GetBucketTagging",
      "s3:PutAccelerateConfiguration",
      "s3:GetAccessPointPolicyForObjectLambda",
      "s3:DeleteObjectVersion",
      "s3:GetBucketLogging",
      "s3:ListBucketVersions",
      "s3:ReplicateTags",
      "s3:RestoreObject",
      "s3:ListBucket",
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketPolicy",
      "s3:PutEncryptionConfiguration",
      "s3:GetEncryptionConfiguration",
      "s3:GetObjectVersionTorrent",
      "s3:AbortMultipartUpload",
      "s3:PutBucketTagging",
      "s3:GetBucketRequestPayment",
      "s3:DeleteBucketOwnershipControls",
      "s3:GetAccessPointPolicyStatus",
      "s3:UpdateJobPriority",
      "s3:GetObjectTagging",
      "s3:GetMetricsConfiguration",
      "s3:GetBucketOwnershipControls",
      "s3:DeleteBucket",
      "s3:PutBucketVersioning",
      "s3:GetBucketPublicAccessBlock",
      "s3:ListBucketMultipartUploads",
      "s3:PutIntelligentTieringConfiguration",
      "s3:GetAccessPointPolicyStatusForObjectLambda",
      "s3:PutMetricsConfiguration",
      "s3:PutStorageLensConfigurationTagging",
      "s3:PutBucketOwnershipControls",
      "s3:PutObjectVersionTagging",
      "s3:PutJobTagging",
      "s3:UpdateJobStatus",
      "s3:GetBucketVersioning",
      "s3:GetBucketAcl",
      "s3:GetAccessPointConfigurationForObjectLambda",
      "s3:PutInventoryConfiguration",
      "s3:GetObjectTorrent",
      "s3:GetStorageLensConfiguration",
      "s3:DeleteStorageLensConfiguration",
      "s3:PutBucketWebsite",
      "s3:PutBucketRequestPayment",
      "s3:PutObjectRetention",
      "s3:CreateAccessPointForObjectLambda",
      "s3:GetBucketCORS",
      "s3:GetBucketLocation",
      "s3:GetAccessPointPolicy",
      "s3:ReplicateDelete",
      "s3:GetObjectVersion"
    ]

  resources = [
      "arn:aws:logs:eu-central-1:*:*",
      "arn:aws:s3:*:*:storage-lens/*",
      "arn:aws:s3:*:*:job/*",
      "arn:aws:s3-object-lambda:*:*:accesspoint/*",
      "arn:aws:s3:::*/*",
      "arn:aws:s3:::gbfs-bucket",
      "arn:aws:s3:*:*:accesspoint/*"
    ]
  }

  statement {
    sid = "AllowInvokingLambdas"
    effect = "Allow"

    resources = [
      "arn:aws:lambda:*:*:function:*"
    ]

    actions = [
      "lambda:InvokeFunction"
    ]
  }

  statement {
    sid = "AllowCreatingLogGroups"
    effect = "Allow"

    resources = [
      "arn:aws:logs:*:*:*"
    ]

    actions = [
      "logs:CreateLogGroup"
    ]
  }

  statement {
    sid = "AllowWritingLogs"
    effect = "Allow"

    resources = [
      "arn:aws:logs:*:*:log-group:/aws/lambda/*:*"
    ]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

resource "aws_iam_policy" "lambda_iam_policy" {
  name = "lambda_iam_policy"
  policy = data.aws_iam_policy_document.lambda_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_iam_policy.arn
  role = aws_iam_role.lambda_exec_role.name
}