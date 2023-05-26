# AWS VPC with public EC2 instance

This project will build the VPC with 9 subnets and create EC2 in public subnet with apache server installation

## Dependencies

```
- terraform v0.13+
- install jq
- chmod 755 whatismyip.sh
```
## Precheck
```
- create pem file from EC2 and download to your local. 
- change the permissions to pem file 'chmod 400 <pem-key>'
- validate the connection (aws sts get-caller-identity)
- if there is no connectivity
- set the profile (export AWS_PROFILE=<profile>)
- set the default region (export AWS_DEFAULT_REGION=us-east-1)

```
## Commands
```
- terraform init
- terraform fmt --recursive
- terraform validate
- terraform plan
- terraform apply
- terraform destroy
```
## Resources will be created (29)

1. 
## validate these

```
- login to ssh
- validate 
* aws s3 ls
* aws sqs list-queue --region us-east-1
- from browser (https://<publicip>:80)
```
* Input/output variale 
* locals
* Explicit and implicit dependencies 
* Provisioners
* dynamic block
* data types
* terraform state# devsecops-class-vpc-2
# devsecops-class-vpc-2
