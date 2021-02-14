def lambda_handler(event, context):
    """
    Returns a 200, hello-world response
    """
    return { 'statusCode': 200, 'body': "Hello, world!" }
