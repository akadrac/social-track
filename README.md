# social-track

This is a lambda function to check a twitter users timeline and post any new tweets to a discord webhook.

![example](/images/social-track.png?raw=true "example")

## Requires
- [Docker](https://docker.com) is used to build and package the function
- [Terraform](https://terraform.io) is used to provision the infrastructure for this serverless function.

## To use this project

### Initial Setup
1. git clone the repo
2. create `tf\secrets.auto.tfvars` from the example
3. add your api keys and discord webhook

### Deploy the application
4. run `build.sh` - builds and packages the function
5. run `terraform plan` then `terraform apply` in `tf`

It should now be installed, however you need to add entires for each user you want to follow into the dynamodb table. e.g.

    {
      "screen_name": { S: 'OpenAI' },
      "since_id": { S: '867411728857939970' },
      "exclude_replies": { BOOL: true }
    }

If you make changes to the app then run steps 6 then 7 again.

## AWS resources used

Terraform provisions the following:
- IAM role
- IAM policy
- Lambda function
- Cloudwatch event
- Dynamodb table
- Cloudwatch log group

enjoy!
