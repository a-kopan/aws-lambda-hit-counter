import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('userVisitsCounterTable')

def increment_visits_count(event, context):
    response = table.update_item(
        Key={'countId': 0},
        UpdateExpression='ADD visitors :inc',
        ExpressionAttributeValues={':inc': 1},
        ReturnValues="UPDATED_NEW"
    )

    new_count = response['Attributes']['visitors']

    return {
        'statusCode': 200,
        'body': f"{new_count}"
    }