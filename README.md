# social-track

This is a lambda function to check a twitter users timeline and post any new tweets to a discord webhook.

![example](/images/social-track.png?raw=true "example")

#### Requires
- [Docker](https://docker.com) is used to build and package the function
- [Terraform](https://terraform.io) is used to provision the infrastructure for this serverless function.

#### To use this project

1. git clone the repo
2. modify `variables.tf` to set your unique bucket name and region
3. rename `secrets\keys.template` to `secrets\keys.json`
4. add your api keys and webhook to `secrets\keys.json`
5. run `build.cmd` - builds and packages the function
6. run `terraform plan` - make sure you have your aws creds available
7. run `terraform apply` - deploys the application

Its should now be installed, however you need to add entires for each user you want to follow into the dynamodb table.

    {
      "screen_name": { S: 'OpenAI' },
      "since_id": { S: '867411728857939970' },
      "exclude_replies": { BOOL: true }
    }


#### AWS resources used

Terraform provisions the following:
- IAM role
- IAM policy
- Lambda function
- Cloudwatch event
- Dynamodb table
- Cloudwatch log group
- KMS key
- S3 bucket
- S3 object with encrypted secrets

enjoy!
