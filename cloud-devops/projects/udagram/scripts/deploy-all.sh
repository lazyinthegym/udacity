#!/bin/bash

# Get the directory of the script
SCRIPT_DIR=$(dirname "$(realpath "$0")")

echo "Deploying the network stack..."

# Deploy the network stack
aws cloudformation deploy \
   --stack-name network \
   --template-file "$SCRIPT_DIR/../network.yml" \
   --parameter-overrides file://"$SCRIPT_DIR/../network-parameters.json" \
   --region us-east-1 \
   --capabilities CAPABILITY_NAMED_IAM

# Check if the deployment of the network stack succeeded
if [ $? -eq 0 ]; then
    echo "Deploying the udagram stack ..."
    # Deploy the udagram stack
    aws cloudformation deploy \
       --stack-name udagram \
       --template-file "$SCRIPT_DIR/../udagram.yml" \
       --parameter-overrides file://"$SCRIPT_DIR/../udagram-parameters.json" \
       --region us-east-1 \
       --capabilities CAPABILITY_NAMED_IAM

    if [ $? -eq 0 ]; then
        echo "Udagram stack deployed successfully."

        echo "Retrieving S3 bucket URL from stack output..."
        S3_BUCKET_URL=$(aws cloudformation describe-stacks \
            --region us-east-1 \
            --stack-name udagram \
            --query "Stacks[0].Outputs[?ExportName=='udagram-S3BucketURI'].OutputValue" \
            --output text)

        if [ -n "$S3_BUCKET_URL" ]; then
            echo "Uploading HTML file to S3 bucket..."
            aws s3 cp "$SCRIPT_DIR/../index.html" "$S3_BUCKET_URL/index.html"

            if [ $? -eq 0 ]; then
                echo "HTML file uploaded successfully to $S3_BUCKET_URL"
            else
                echo "Failed to upload HTML file."
            fi
        else
            echo "Failed to retrieve S3 bucket URL."
        fi

    else
        echo "Failed to deploy the Udagram stack."
    fi
else
    echo "Failed to deploy the network stack."
fi
