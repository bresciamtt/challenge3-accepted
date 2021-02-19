# challenge3-accepted
## Task 1 > Static HTML deployment on S3 bucket

Using the Next.js export function we can export the app to static HTML, which can be run standalone without the need of a Node.js server.

On AWS we can leverage on an S3 bucket for a pretty straightforward deployment (https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html).

The solution is built using Terraform and AWS CLI inside a containerized workspace, so the only requirement to run this solutions is:

- Docker CE 17.06 or newer version (support for multi-stage builds)

Follow the README in the folder static-html-on-s3 for more details.

## Task 2.1 > S3 bucket policy

Using the S3 bucket policies we can blacklist suspected malicious IPs. 

Just update the list of blacklisted IPs and apply the changes using Terraform.

## Task 3 > ECS Service

The website can be deployed as a container on ECS - EC2 based (unfortunately there isn't a free-tier for Fargate).

Like before, the solution is built using Terraform and AWS CLI inside a containerized workspace. So it's required to run a container in order to deploy the website.

Follow the README in the folder ecs-service for more details.

## Task 2.2 > Security groups and Network ACL

The restrictions on the ECS stack can be made by creating new Network ACL and by specifying the list of allowed CIDR blocks on the Elastic Load Balancer Security Group.

All these changes can be applied on AWS using Terraform.

## Task 4 > Issues on Github

Speaking of the website, there's a list of issues on the codebase Github repo https://github.com/bresciamtt/challenge3

Of course, there are multiple issues on this repository too. Feel free to suggest new improvements and highlight defects!