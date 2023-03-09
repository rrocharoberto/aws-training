import boto3
import os

def lambda_handler(event, context):
    print("Environment: " + os.environ["ENVIRONMENT"])
    print("Service: " + os.environ["SERVICE"])
    result = "Hello World: " + str(event)
    return {
        'statusCode' : 200,
        'body': result
    }
