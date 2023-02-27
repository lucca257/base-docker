#!/usr/bin/env bash
echo "########### Creating S3 ###########"

# Create bucket
aws --endpoint-url=http://127.0.0.1:4566 s3api create-bucket --bucket mybucket
# Add ACL (Acess Control List) rules to bucket
aws --endpoint-url=http://127.0.0.1:4566 s3api put-bucket-acl --bucket mybucket --acl public-read
echo "########### Creating SQS ###########"
# Create queue
aws --endpoint-url=http://127.0.0.1:4566 sqs create-queue --queue-name myqueue
# creating queue config file
cat >"notification.json" <<EOF
{
  "QueueConfigurations": [
    {
      "QueueArn": "arn:aws:sqs:us-east-1:000000000000:myqueue",
      "Events": [
        "s3:ObjectCreated:*"
      ]
    }
  ]
}
EOF
# Configure notification on bucket
aws --endpoint-url=http://127.0.0.1:4566 s3api put-bucket-notification-configuration --bucket mybucket --notification-configuration file://notification.json
aws --endpoint-url=http://127.0.0.1:4566 sqs get-queue-attributes --queue-url http://localhost:4566/queue/myqueue --attribute-names All
# sample image
touch sample.jpg
# Copy local object to bucket
aws --endpoint-url=http://127.0.0.1:4566 s3 cp sample.jpg s3://mybucket/
# Sync local files to bucket
aws --endpoint-url=http://127.0.0.1:4566 s3 sync /root/localstack/s3 s3://mybucket/
echo "########### LOCALSTACK CONFIGURED ###########"