# aws-training
This repository contains examples of using AWS resources based in Java and Terraform code to create the infrastructure.

The Java code is located in `java/app` directory.

The AWS terraform infrastructure is located in `java/infra` directory.

Look at this [architecture diagram](docs/ArchitectureDiagram.png) to see the infrastructure details.

## Instructions to build and deploy

1. Go to `java/app/` directory.
2. Run: `mvn clean install`
3. Set up `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables (more details [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)).
4. Go to `java/infra/` directory.
5. Run:
    * `terraform init`
    * `terraform plan -out=tfplan -var email_recipient=<YOUR_EMAIL>`
    * `terraform apply tfplan`

### Notes:

 - The e-mail required is used to SNS send an e-email when the alarm gets activated.

 - Also after deployment, it is necessary verify your e-mail.

Please, let me know if you have any questions.
