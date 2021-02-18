# How to run the build environment
## Docker image build
docker build -t challenge3-terraform:latest .
## Run the container using volumes
The following commands can be used to start the container and attach to the shell

on Linux:

docker run -it --name terraform -v $(pwd):/workspace challenge3-terraform sh

on Windows:

docker run -it --name terraform -v %cd%:/workspace challenge3-terraform sh

## Using the environment provisioning script

docker run --name terraform -v $(pwd):/workspace challenge3-terraform "./entrypoint.sh"

You may run the script with arguments to avoid prompts (useful for programmatic execution):

docker run --name terraform -v $(pwd):/workspace challenge3-terraform "./entrypoint.sh --aws_access_key_id ****** --aws_secret_access_key ********"
