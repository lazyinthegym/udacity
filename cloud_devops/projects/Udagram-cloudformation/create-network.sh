aws cloudformation create-stack \
   --stack-name network \
   --template-body file://network.yml \
   --parameters file://network-parameters.json \
   --region us-east-1 \
   --capabilities CAPABILITY_NAMED_IAM