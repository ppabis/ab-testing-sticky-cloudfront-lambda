from fastapi import FastAPI, Cookie, Response
from fastapi.responses import HTMLResponse
from typing import Annotated

import config

app = FastAPI()

@app.get("/", response_class=HTMLResponse)
async def root(response: Response, sessiontoken: Annotated[str | None, Cookie()] = None):
    
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

