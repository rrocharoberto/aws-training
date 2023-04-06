# aws-training with Terraform

This repository contains examples of using AWS resources based in Java, Python and Terraform code to create the infrastructure.

The Java and Python code are located in `overview-01/app` and `overview-02/app` directories.

The AWS terraform infrastructure is located in `overview-01/infra` and `overview-02/infra` directories.

Current architecture diagrams:

- [Demo 01 of overview-01](docs/overview-01/TerraformOverview-v1.drawio.png)
- [Demo 02 of overview-01](docs/overview-01/TerraformOverview-v2.drawio.png)
- [Demo 03 of overview-01](docs/overview-01/TerraformOverview-v3.drawio.png)
- [Demo of overview-02 (WIP)](docs/ArchitectureDiagram.png)


## Instructions to build and deploy

### Build Java projects

Run the following command in each directory: `overview-01/app` and `overview-02/app`.

- `mvn clean install`

### Deploy to AWS

1. Set up AWS credentials (see more details [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)).

2. Go to `infra` directory you want to deploy.

- `overview-01/infra/demo01` or
- `overview-01/infra/demo02` or
- `overview-01/infra/demo03`

PS: the configuration of `overview-02/infra` is still working in progress.

3. Run:

- `terraform init`
- `terraform plan -var-file=demo.tfvars -out=tfplan`
- `terraform apply tfplan`

PS: for `overview-02/infra`, use the following plan command:

- `terraform plan -var-file=demo.tfvars -out=tfplan -var email_recipient=<YOUR_EMAIL>`

### Deploy Notes

- For `demo03` it is necessary to create a Slack channel and setup a Web Hook. Configure the follwing environment variable:
  - `export TF_VAR_slack_hook_url=<you_slack_web_hook_url>`
  - See the Slack chanel id in `demo03/demo.tfvars` file.
- The e-mail required is used to SNS send an e-email when the alarm gets activated.
- Also after deployment, it is necessary verify your e-mail.

### Destroy

Run the folowing commands in `infra` directory you want to destroy your AWS resources.

- `terraform plan -destroy -var-file=demo.tfvars -out=tfplan`
- `terraform apply tfplan`

Please, let me know if you have any questions.
