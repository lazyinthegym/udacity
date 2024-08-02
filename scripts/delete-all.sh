#!/bin/bash



echo "Retrieving S3 bucket URL from stack output..."
S3_BUCKET_URL=$(aws cloudformation describe-stacks \
                --region us-east-1 \
                --stack-name udagram \
                --query "Stacks[0].Outputs[?ExportName=='udagram-S3BucketURI'].OutputValue" \
                --output text)

echo "Emptying the S3 bucket..."
aws s3 rm $S3_BUCKET_URL --recursive


# Delete the udagram stack
aws cloudformation delete-stack \
   --stack-name udagram \
   --region us-east-1

# Check if the deletion of the udagram stack succeeded
if [ $? -eq 0 ]; then
    echo "Udagram stack deletion initiated successfully."
    echo "Waiting for the Udagram stack deletion to complete..."

    # Wait for the stack to be deleted
    aws cloudformation wait stack-delete-complete \
        --stack-name udagram \
        --region us-east-1

    if [ $? -eq 0 ]; then
        echo "Udagram stack deleted successfully."

        # Delete the network stack
        aws cloudformation delete-stack \
           --stack-name network \
           --region us-east-1

        if [ $? -eq 0 ]; then
            echo "Network stack deletion initiated successfully."
            echo "Waiting for the Network stack deletion to complete..."

            # Wait for the stack to be deleted
            aws cloudformation wait stack-delete-complete \
                --stack-name network \
                --region us-east-1

            if [ $? -eq 0 ]; then
                echo "Network stack deleted successfully."
            else
                echo "Failed to delete the Network stack."
            fi
        else
            echo "Failed to initiate the Network stack deletion."
        fi
    else
        echo "Failed to delete the Udagram stack."
    fi
else
    echo "Failed to initiate the Udagram stack deletion."
fi
