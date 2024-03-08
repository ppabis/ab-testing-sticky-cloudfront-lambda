FROM python:3.11-alpine
RUN pip3 install "uvicorn[standard]" "fastapi" "boto3"

WORKDIR /app
ARG VERSION=version1
COPY app-$VERSION/* /app/

ENTRYPOINT [ "uvicorn", "index:app", "--host", "0.0.0.0" ]
