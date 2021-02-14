import pytest

from example_lambda import lambda_handler

def test_handler():
    response = lambda_handler(None, None)
    assert response["statusCode"] == 200
    assert response["body"] == "Hello, world!"
