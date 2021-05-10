import botocore.exceptions
import urllib.request
import urllib.error
import boto3
import os
import urllib
import json
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def lambda_handler(event, context):
    logger.info('Starting gbfsIngester')

    # Declare variables before assignment
    bike_status = ''
    s3 = ''
    nb_bike = 0
    bucket_name = os.getenv('S3_BUCKET_NAME')
    url = os.getenv('URL')

    logger.info(f'Request the url : {url}')
    try:
        r = urllib.request.urlopen(url)
    except urllib.error.HTTPError as error:
        logger.error(f'Error code : {error.code} - Error message : {error.read()}')
        return {
            "statusCode": 400
        }

    # Load JSON data
    json_data = json.loads(r.read())

    # Assign some variables extracting from json data
    timestamp = json_data['last_updated']
    bikes_data = json_data['data']

    try:
        # Connect to the S3 resource
        s3 = boto3.resource('s3')

        # Remove all previous free bikes under bike path prefix
        s3.Bucket(bucket_name).objects.filter(Prefix='bikes/bike/').delete()

    except botocore.exceptions.ClientError as error:
        logger.error(f'Error code : {error.response["Error"]["Code"]} - Error message : {error.response["Error"]["Message"]}')
        return {
            "statusCode": 400
        }

    # Loop through the bikes data and ingest each bike status
    logger.info('Storing bikes data in progress .....')
    for bike in bikes_data['bikes']:
        bike_id = bike['bike_id']
        if bike['is_disabled'] == 0 and bike['is_reserved'] == 0:
            bike_status = "AVAILABLE"
        if bike['is_disabled'] == 1 and bike['is_reserved'] == 0:
            bike_status = "DISABLE"
        if bike['is_disabled'] == 0 and bike['is_reserved'] == 1:
            bike_status = "RESERVED"

        tags = f'bike_status={bike_status}'
        bike_file = f'bikes/bike/{bike_id}.json'
        bike = json.dumps(bike)
        nb_bike = nb_bike + 1

        try:
            #Storing each bike data in a specific path in the bucket
            s3.Bucket(bucket_name).put_object(Key=bike_file, Body=bike, Tagging=tags)
        except botocore.exceptions.ClientError as error:
            logger.error(f'Error code : {error.response["Error"]["Code"]} - Error message : {error.response["Error"]["Message"]}')
            return {
                "statusCode": 400
            }

    # Finally ingest the global file with all bikes
    json_data = json.dumps(json_data)
    bikes_file = f'bikes/bikes_status_{str(timestamp)}.json'
    try:
        s3.Bucket(bucket_name).put_object(Key=bikes_file, Body=json_data)
    except botocore.exceptions.ClientError as error:
        logger.error(f'Error code : {error.response["Error"]["Code"]} - Error message : {error.response["Error"]["Message"]}')
        return {
            "statusCode": 400
        }

    # Return 200 at the end
    logger.info(f'{nb_bike} bikes data stored in the bucket : {bucket_name}')
    logger.info('Global file stored')
    logger.info(f'SUCCESS - Ingestion GBFS data OK ')
    return {
        "statusCode": 200
    }