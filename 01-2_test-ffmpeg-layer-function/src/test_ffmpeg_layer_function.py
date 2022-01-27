# ref: https://dev.classmethod.jp/articles/ffmpeg-lambda-layer/

import json
import logging
import os
import shlex
import subprocess

import boto3
from botocore.exceptions import ClientError

S3_DESTINATION_BUCKET = os.environ["OUTPUT_BUCKET"]
SIGNED_URL_TIMEOUT_SECONDS = 900

logger = logging.getLogger('lambda_logger')
logger.setLevel(logging.INFO)
s3_client = boto3.client('s3')

data_path = '/tmp'

def lambda_handler(event, context):

    s3_source_bucket = event['Records'][0]['s3']['bucket']['name']
    s3_source_key = event['Records'][0]['s3']['object']['key']
    logger.info(f"s3_source_bucket: {s3_source_bucket}")
    logger.info(f"s3_source_key: {s3_source_key}")

    s3_source_basename = os.path.splitext(os.path.basename(s3_source_key))[0]
    s3_destination_filename = f"{s3_source_basename}_encoded.wav"

    input_filename = os.path.join(data_path, s3_source_basename)
    s3_client.download_file(s3_source_bucket, s3_source_key, input_filename)

    # Check wav duration
    get_duration_cmd = f"/opt/bin/ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 {input_filename}"
    logger.info(f"get_duration_cmd: {get_duration_cmd}")
    get_duration_result = float(subprocess.check_output(get_duration_cmd, stdin=subprocess.DEVNULL, shell=True))
    logger.info(f"get_duration_result: {get_duration_result} seconds")

    output_filename = os.path.join(data_path, s3_destination_filename)

    # Convert Encoding
    convert_cmd = f"/opt/bin/ffmpeg -hide_banner -i {input_filename} -ab 256k {output_filename}"
    logger.info(f"convert_cmd: {convert_cmd}")
    logger.info("start converting!!!")
    subprocess.run(convert_cmd, stdin=subprocess.DEVNULL, shell=True)
    logger.info("finish converting!!!")

    try:
        response = s3_client.upload_file(output_filename, S3_DESTINATION_BUCKET, s3_destination_filename)
        logger.info(f"response: {response}")
        
        os.remove(input_filename)
        os.remove(output_filename)
    except ClientError as e:
        logging.error(e)
        return False

    return True
