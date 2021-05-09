import json

import urllib.parse
import boto3

print('Loading function')

s3 = boto3.client('s3')


def lambda_handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))

    # Get the object from the event and show its content type
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    string = "successfully wrote to my file!"
    encoded_string = string.encode("utf-8")
    file_name = "hello.txt"
    s3_path = "newfile/" + file_name
    try:
        response = s3.put_object(Bucket=bucket_name, Key=s3_path, Body=encoded_string, ACL='public-read')
        print("CONTENT TYPE: " + response['ContentType'])
        return response['ContentType']
    except Exception as e:
        print(e)
        print('Error putting object {} to bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(s3_path, bucket_name))
        raise e
