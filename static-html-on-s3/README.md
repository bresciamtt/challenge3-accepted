# Static HTML on S3
## Build Environment

In order to deploy the website you need to:

- build the Terraform image

`docker build -t challenge3-terraform:latest .`

- build the app using the Nect.js export command and copy the static website build folder `out` 
  under the `static-html-on-s3` folder
- run the provisioning script inside the Terraform container

(on Linux)

`docker run --name terraform -v $(pwd):/workspace challenge3-terraform "./entrypoint.sh"`

(on Windows)

`docker run --name terraform -v %cd%:/workspace challenge3-terraform "./entrypoint.sh"`

- you can also connect to the container's shell

`docker run -it --name terraform -v $(pwd):/workspace challenge3-terraform sh`

## Infrastructure resources

The terraform module manages the creation of the following resources:

- AWS S3 bucket
- S3 Bucket Policy
- Local file used to share outputs
- [not yet implemented] Cloudfront distribution (issue #17)

## Manage access rules

You can update the array of blacklisted IPs for each Terraform environment/workspace 
by modifying the parameter `blacklisted_ips` defined inside the file `./terraform/env.tf`

To apply the changes, run the provisioning script inside the Terraform container.