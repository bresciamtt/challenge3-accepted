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

if [ -z $AWS_ACCESS_KEY_ID ]; then
    echo "AWS Access Key ID: "
    read -sp AWS_ACCESS_KEY_ID
fi

if [ -z $AWS_SECRET_ACCESS_KEY ]; then
    echo "AWS Secret Access Key: "
    read -sp AWS_SECRET_ACCESS_KEY
fi

export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

if [ -z $SERVICE_TO_PROVISION ]; then
    echo "Which service do you want to provision? (ecs/ecr) "
    read SERVICE_TO_PROVISION
fi

case $SERVICE_TO_PROVISION in
  "ecr")
    echo "Provisioning the ECR registry..."
    terraform -chdir=/workspace/terraform/ecr init -reconfigure
    terraform -chdir=/workspace/terraform/ecr workspace new $TF_ENVIRONMENT
    terraform -chdir=/workspace/terraform/ecr apply -auto-approve
    source /workspace/terraform/ecr/terraform_out
    ECR_PWD=$(aws ecr get-login-password --region $AWS_REGION)
    echo "Use the following command to authenticate against the ECR registry: "
    echo "docker login --username AWS -p $ECR_PWD $REGISTRY_URL"
    echo "Use it to push your image on the ECR registry!"
    ;;
  "ecs")
    echo "Provisioning the ECS cluster..."
    ;;
  *)
    echo "ERROR: You selected an unknown service: $SERVICE_TO_PROVISION" 1>&2
    exit 1
    ;;
esac


