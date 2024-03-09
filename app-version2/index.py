from fastapi import FastAPI, Cookie, Response
from fastapi.responses import HTMLResponse
from typing import Annotated

import config

app = FastAPI()

@app.get("/", response_class=HTMLResponse)
async def root(response: Response, sessiontoken: Annotated[str | None, Cookie()] = None):
    try:
        update_session(response, sessiontoken)
    except Exception as e:
        print(e)
        response.status_code = 500
        return f"""<html><body><h1>ERROR 500</h1><p>We expected unexpected!</p></body></html>"""
    return f"""
    <html>
        <head>
            <title>Application {config.VERSION_NAME}</title>
            <style>
                body {{
                    background-color: {config.BACKGROUND_COLOR};
                    color: {config.COLOR};
                    font-family: {config.FONT_FAMILY};
                }}
            </style>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        </head>
        <body>
            <h1>This is application {config.VERSION_NAME}</h1>
            <p>You now got a cookie :)</p>
        </body>
    </html>
    """

from boto3 import client
from random import randbytes
from hashlib import sha1
from datetime import datetime
import os

if os.environ.get("AWS_REGION") is None:
  dynamo = client("dynamodb", region_name="us-east-1")
else:
  dynamo = client("dynamodb")

def update_session(response: Response, sessiontoken: Annotated[str | None, Cookie()] = None):
    # If there is no session token we pick a random one
    if sessiontoken is None:
        sessiontoken = sha1(randbytes(128)).hexdigest()
    # And we update the session token in the database. Update in DynamoDB works also for new items.
    dynamo.update_item(
        TableName="SessionsTable",
        Key={ "token": {"S": sessiontoken} },
        UpdateExpression="SET expires = :expires, version = :version",
        ExpressionAttributeValues={
            ":expires": { "N": str(int(datetime.now().timestamp() + 600)) },
            ":version": { "S": config.VERSION_CODE }
        },
    )
    # We give the user either a new cookie or the same one as before
    response.set_cookie(key="sessiontoken", value=sessiontoken)

