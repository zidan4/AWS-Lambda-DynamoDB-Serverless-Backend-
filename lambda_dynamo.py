import json
import boto3

def lambda_handler(event, context):
    data = json.loads(event['body'])
    name = data['name']
    table = boto3.resource('dynamodb').Table('Users')
    table.put_item(Item={"Name": name})
    
    return {
        'statusCode': 200,
        'body': json.dumps({"message": f"Added {name} to DB!"})
    }
