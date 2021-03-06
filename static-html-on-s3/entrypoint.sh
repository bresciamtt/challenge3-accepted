#!/bin/bash

while [ $# -gt 0 ]; do
   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
   fi
  shift
done

TF_ENVIRONMENT=${environment:-dev}
AWS_ACCESS_KEY_ID=${aws_access_key_id}
AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}

echo '#########################################################'
echo '### Welcome to the static-html-on-s3 deployment script! #'
echo '###'

if [ -z $AWS_ACCESS_KEY_ID ]; then
    echo '### Type your AWS Access Key ID: '
    read -sp '(silent) > ' AWS_ACCESS_KEY_ID
    echo ''
fi

if [ -z $AWS_SECRET_ACCESS_KEY ]; then
    echo '### Type your AWS Secret Access Key: '
    read -sp '(silent) > ' AWS_SECRET_ACCESS_KEY
    echo ''
fi

export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

echo '### Provisioning the S3 bucket...'
terraform -chdir=/workspace/terraform init -reconfigure
terraform -chdir=/workspace/terraform workspace new $TF_ENVIRONMENT
terraform -chdir=/workspace/terraform workspace select $TF_ENVIRONMENT
terraform -chdir=/workspace/terraform apply -auto-approve
echo '### The S3 bucket has been provisioned!'
echo '### Deploying the website...'
source /workspace/terraform/terraform_out
aws s3 sync ./out s3://$S3_BUCKET_NAME --delete --acl=public-read
echo '### The website has been deployed!'
echo '### Call the following endpoint to access your app: '
echo "http://$S3_BUCKET_NAME.s3-website.$AWS_REGION.amazonaws.com/"