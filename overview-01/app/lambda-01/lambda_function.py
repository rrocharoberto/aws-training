import boto3
import os

def lambda_handler(event, context):
    print("Running lambda with input data: " + str(event))
    print("Environment: " + os.environ["ENVIRONMENT"])
    print("Service: " + os.environ["SERVICE"])
    if "error" in event:
        raise Exception(event["error"])

    result = "Hello World: " + str(event)
    return {
        'statusCode' : 200,
        'body': result
    }
