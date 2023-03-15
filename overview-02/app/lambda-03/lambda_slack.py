import urllib3 
import json
import os

http = urllib3.PoolManager() 

def lambda_handler(event, context): 
  print("Running slack lambda: " + str(event))

  message = event['Records'][0]['Sns']['Message']
  parsed_message = json.loads(message)
  
  url = os.environ["SLACK_HOOK_URL"]
  msg = {
    "channel": os.environ["SLACK_CHANNEL"],
    "username": "aws-alarm",
    "text": event['Records'][0]['Sns']['Subject'] 
      + "\nstate: " + parsed_message['NewStateValue']
      + "\nreason: " + parsed_message['NewStateReason']
  }
  encoded_msg = json.dumps(msg).encode('utf-8')
  resp = http.request('POST', url, body=encoded_msg)
  print({
    "message": event['Records'][0]['Sns']['Message'], 
    "status_code": resp.status, 
    "response": resp.data
  })
