import boto3, os

# To reduce latency, we will pick one of the tables based on the region
aws_region = os.environ.get("AWS_REGION")
aws_region = "us-east-1" if aws_region is None else aws_region
if aws_region.startswith("eu-"):
    aws_region = "eu-west-1"
elif aws_region.startswith("ap-"):
    aws_region = "ap-southeast-1"

dynamo = boto3.client("dynamodb", region_name=aws_region)

import random
second_origin = "ec2-54-236-20-164.compute-1.amazonaws.com"

def pick_random(request):
    if random.choice([0, 1]) == 0:
        request['origin']['custom']['domainName'] = second_origin
    return request

def select_version(token, request):
    item = dynamo.get_item(
        TableName="SessionsTable",
        Key={ "token": {"S": token} }
    )
    # If this token is found and has a version, we stick to it
    if 'Item' in item and 'version' in item['Item']:
        if item['Item']['version']['S'] == "2":
            request['origin']['custom']['domainName'] = second_origin
    # Session might be invalid so roll any origin 50/50
    else:
        request = pick_random(request)
        
    return request

def handler(event, context):
    token = None
    request = event['Records'][0]['cf']['request']
    headers = request['headers']

    # Check if there is any cookie header
    cookie = headers.get('cookie', [])
    if cookie:
        for c in cookie:
            # Check if there is a sessiontoken
            if 'sessiontoken' in c['value']:
                token = c['value'].split('=')[1]
                break
    
    if token:
        request = select_version(token, request)
    else:
        # As with invalid session case, we roll any origin 50/50
        request = pick_random(request)
    
    return request
