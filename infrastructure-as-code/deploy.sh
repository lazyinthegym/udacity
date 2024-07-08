aws cloudformation deploy \
   --stack-name $1 \
   --template-file $2 \
   --parameter-overrides file://$3 \
   --region us-east-1 