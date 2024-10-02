import os
import awsgi
import boto3
from flask import Flask

GITLAB_INSTANCE_ID = os.environ['GITLAB_INSTANCE_ID']

app = Flask(__name__)

@app.route('/start')
def start():
    ec2 = boto3.client('ec2', region_name='eu-west-3')
    response = ec2.start_instances(
    InstanceIds=[
        GITLAB_INSTANCE_ID,
    ],
    )
    return (response)

@app.route('/stop')
def stop():
    ec2 = boto3.client('ec2', region_name='eu-west-3')
    response = ec2.stop_instances(
    InstanceIds=[
        GITLAB_INSTANCE_ID,
    ],
    )
    return (response)


def lambda_handler(event, context):
    # https://github.com/slank/awsgi/issues/73#issuecomment-1986868661
    event['httpMethod'] = event['requestContext']['http']['method']
    event['path'] = event['requestContext']['http']['path']
    event['queryStringParameters'] = event.get('queryStringParameters', {})
    return awsgi.response(app, event, context) 