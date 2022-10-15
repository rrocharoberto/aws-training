# aws-training
This repository contains examples of using AWS resources based in Java and Terraform code to create the infrastructure.

The Java code is located in `java/app` directory.

The Lambda terraform infrastructure is located in `java/infra` directory.

## Instructions to build and deploy

1. Go to `java/app/lambda01` directory
2. Run: `mvn clean install`
3. Go to `java/infra` directory
4. Set up `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables (more details [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)).
5. Run:
    * `terraform init`
    * `terraform plan`
    * `terraform apply`

Please, let me know if you have any questions.
