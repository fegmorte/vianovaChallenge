# Script:           gfbs_reader.py                                          #
# User:             Frederic EGMORTE                                        #
# Creation date:    2021-05-07                                              #
# Object:           Ingest gbfs data in S3                                  #
#                                                                           #
import warnings
import boto3
import logging
import os
import requests
from dotenv import load_dotenv
import json


logging.basicConfig(
    level=logging.INFO,
    #filename="log_file.log",
    format="%(asctime)s - %(levelname).4s : %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
log = logging.getLogger()

load_dotenv('../.env')

def gbfs_get_data(gbfs_url):

    log.info(f'Request the url : {gbfs_url}')
    r = requests.get(gbfs_url)
    json_data = r.json()

    timestamp = json_data['last_updated']
    bike_data = json_data['data']
    i=0
    for bike in bike_data['bikes']:
        print(bike)
        i=i+1
        print(i)

    exit()


    json_data = json.dumps(bike_data)
    json_file = f'bike/bike_status_{str(timestamp)}.json'

    log.info(f'Returning the data and the file name')
    return json_data, json_file

def gbfs_ingest_data():

    URL = os.getenv('URL')

    bikes_data, bikes_file = gbfs_get_data(URL)

    s3 = boto3.resource('s3')

    for bucket in s3.buckets.all():
        if os.getenv('S3_BUCKET_NAME') in bucket.name:
            BUCKET_NAME = bucket.name

    log.info(f'Putting the object in the bucket : {BUCKET_NAME}')
    s3.Bucket(BUCKET_NAME).put_object(Key=bikes_file, Body=bikes_data)


    #session = boto3.Session(profile_name='default')
    #dev_s3_client = session.client('s3')


if __name__ == '__main__':
    log.info(f'Starting gbfs_reader')
    gbfs_ingest_data()
    log.info(f'Finishing gbfs_reader')