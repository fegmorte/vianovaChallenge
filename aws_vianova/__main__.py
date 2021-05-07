"""An AWS Python Pulumi program"""

import os
import pulumi
from pulumi_aws import s3
from dotenv import load_dotenv

load_dotenv('../.env')

# Create an AWS resource (S3 Bucket)
bucket = s3.Bucket(os.getenv('S3_BUCKET_NAME'))

# Export the name of the bucket
pulumi.export('bucket_name', bucket.id)
