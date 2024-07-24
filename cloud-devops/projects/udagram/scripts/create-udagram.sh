#!/bin/bash

# Get the directory of the script
SCRIPT_DIR=$(dirname "$(realpath "$0")")

aws cloudformation create-stack \
   --stack-name udagram \
   --template-body file://"$SCRIPT_DIR/../udagram.yml" \
   --parameters file://"$SCRIPT_DIR/../udagram-parameters.json" \
   --region us-east-1 \
   --capabilities CAPABILITY_NAMED_IAM
