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
SERVICE_TO_PROVISION=${service_to_provision}

echo '#########################################################'
echo '### Welcome to the ecs-website deployment script! #######'
echo '###'

if [ -z $AWS_ACCESS_KEY_ID ]; then
    echo '### AWS Access Key ID: '
    read -sp '> ' AWS_ACCESS_KEY_ID
fi

if [ -z $AWS_SECRET_ACCESS_KEY ]; then
    echo '### AWS Secret Access Key: '
    read -sp '> ' AWS_SECRET_ACCESS_KEY
fi

export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

if [ -z $SERVICE_TO_PROVISION ]; then
    echo '### Type the name of the service you want to create/update (ecr/ecs) '
    read '> ' SERVICE_TO_PROVISION
fi

case $SERVICE_TO_PROVISION in
  "ecr")
    echo '### Provisioning the ECR registry...'
    terraform -chdir=/workspace/terraform/ecr init -reconfigure
    terraform -chdir=/workspace/terraform/ecr workspace new $TF_ENVIRONMENT
    terraform -chdir=/workspace/terraform/ecr apply -auto-approve
    source /workspace/terraform/ecr/terraform_out
    ECR_PWD=$(aws ecr get-login-password --region $AWS_REGION)
    echo '### The ECR registry has been provisioned!'
    echo '### Use the following command to authenticate against the ECR registry: '
    echo ''
    echo "docker login --username AWS -p $ECR_PWD $REGISTRY_URL"
    echo ''
    echo '### Use it to push your image on the ECR registry!'
    ;;
  "ecs")
    echo '### Provisioning the ECS cluster...'
    terraform -chdir=/workspace/terraform/ecs init -reconfigure
    terraform -chdir=/workspace/terraform/ecs workspace new $TF_ENVIRONMENT
    terraform -chdir=/workspace/terraform/ecs apply -auto-approve -var "registry=$REGISTRY_URL" -var "image_version=latest"
    source /workspace/terraform/ecs/terraform_out
    echo '### The ECS cluster has been provisioned!'
    echo '### Please wait from 5 to 10 minutes in order to let AWS setup your resources, then call the following endpoint to access your app: '
    echo "$PUBLIC_ENDPOINT"
    ;;
  *)
    echo "ERROR: You selected an unknown service: $SERVICE_TO_PROVISION" 1>&2
    exit 1
    ;;
esac


