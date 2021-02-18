#!/bin/bash

while [ $# -gt 0 ]; do
   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
   fi
  shift
done

TF_ENVIRONMENT=${environment:-development}
AWS_ACCESS_KEY_ID=${aws_access_key_id}
AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}

if [ -z $AWS_ACCESS_KEY_ID ]; then
    echo "AWS Access Key ID:"
    read -s AWS_ACCESS_KEY_ID
fi

if [ -z $AWS_SECRET_ACCESS_KEY ]; then
    echo "AWS Secret Access Key:"
    read -s AWS_SECRET_ACCESS_KEY
fi

export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

terraform -chdir=/workspace/terraform init -reconfigure
terraform -chdir=/workspace/terraform workspace new $TF_ENVIRONMENT
terraform -chdir=/workspace/terraform apply -auto-approve

source /workspace/terraform/terraform_out
aws s3 sync ./out s3://$S3_BUCKET_NAME --delete --acl=public-read