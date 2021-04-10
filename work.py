import boto3

# get urls
sqs_in = "https://sqs.us-east-1.amazonaws.com/280520154715/interview-incoming-queue.fifo"
sqs_out = "https://sqs.us-east-1.amazonaws.com/280520154715/interview-outgoing-queue.fifo"


# Create SQS client
sqs = boto3.client('sqs')

# Send message to SQS queue
response = sqs.send_message(
    QueueUrl=sqs_out,
    DelaySeconds=10,
    MessageAttributes={
        'Title': {
            'DataType': 'String',
            'StringValue': 'The Whistler'
        },
        'Author': {
            'DataType': 'String',
            'StringValue': 'John Grisham'
        },
        'WeeksOn': {
            'DataType': 'Number',
            'StringValue': '6'
        }
    },
    MessageBody=(
        'Information about current NY Times fiction bestseller for '
        'week of 12/11/2016.'
    )
)

print(response['MessageId'])