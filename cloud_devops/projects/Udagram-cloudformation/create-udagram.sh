aws cloudformation create-stack \
   --stack-name udagram \
   --template-body file://udagram.yml \
   --parameters file://udagram-parameters.json \
   --region us-east-1 \
   --capabilities CAPABILITY_NAMED_IAM