ARG AWS_CLI_VERSION=2.1.26
ARG TERRAFORM_VERSION=0.14.6

FROM hashicorp/terraform:$TERRAFORM_VERSION as terraform

FROM amazon/aws-cli:$AWS_CLI_VERSION as awscli
COPY --from=terraform /bin/terraform /usr/bin/terraform
RUN mkdir /workspace
WORKDIR /workspace
RUN yum install git -y
ENTRYPOINT ["/bin/sh", "-c"]