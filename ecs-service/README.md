# ECS Service
## Build Environment

In order to deploy the website you need to:

- build the Terraform image

`docker build -t challenge3-terraform:latest .`

- run the provisioning script inside the Terraform container 
  and select `ecr` when it prompts for which service to provision 

(on Linux)

`docker run --name terraform -v $(pwd):/workspace challenge3-terraform "./entrypoint.sh"`

(on Windows)

`docker run --name terraform -v %cd%:/workspace challenge3-terraform "./entrypoint.sh"`

- copy the output command to login on ECR and execute it

- clone the website project here

`git clone https://github.com/bresciamtt/challenge3.git`

- build the website production-ready image (follow the readme in the challenge3 repo)
- push the image on the provisioned ECR private repo 
  (https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-push-ecr-image.html)
- run the provisioning script inside the Terraform container
    and select `ecs` when it prompts for which service to provision

(on Linux)

`docker run --name terraform -v $(pwd):/workspace challenge3-terraform "./entrypoint.sh"`

(on Windows)

`docker run --name terraform -v %cd%:/workspace challenge3-terraform "./entrypoint.sh"`

- you can also connect to the container's shell to manually execute terraform 
or AWS CLI commands

`docker run -it --name terraform -v $(pwd):/workspace challenge3-terraform sh`

## Infrastructure resources

The terraform modules manage the creation of the following resources:

- ECR registry
- AWS ECS cluster (ECS, Service, Task definition)
- Autoscaling Group
- Elastic Load Balancer
- Security Groups
- IAM instance profile
- Network ACL rules

## Manage access rules

You can update the array of allowed IPs for each Terraform environment/workspace
by modifying the parameter `website_allowed_cidr_blocks` defined inside the file `./terraform/ecs/env.tf`

You can also define multiple Network ACL rules by updating the parameter `nacl_rules`
defined inside the file `./terraform/ecs/env.tf`

To apply the changes, run the provisioning script inside the Terraform container.