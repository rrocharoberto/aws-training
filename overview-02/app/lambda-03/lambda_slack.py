import urllib3 
import json
import os

http = urllib3.PoolManager() 

def lambda_handler(event, context): 
    print("Running slack lambda: " + str(event))

    url = os.environ["SLACK_WORKSPACE_URL"]
    msg = {
        "channel": os.environ["SLACK_CHANNEL"],
        "username": "aws-alarm",
        "text": event['Records'][0]['Sns']['Message']
    }
    encoded_msg = json.dumps(msg).encode('utf-8')
    resp = http.request('POST', url, body=encoded_msg)
    print({
        "message": event['Records'][0]['Sns']['Message'], 
        "status_code": resp.status, 
        "response": resp.data
    })
