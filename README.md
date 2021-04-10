# IOC tutorial

## Prerequisites

AWS

* Add [interview] section to ~/.aws/credentials with aws access and secret keys
* Add [interview] section to ~/.aws/config with region = us-east-1
* Test configuration: aws ec2 describe-instances --region us-east-1 --profile interview

SSH

* Save ssh key as ~/.ssh/interview.pem
* chmod 400 ~/.ssh/interview.pem


## Usefull links

* https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html#finding-quick-start-ami
* https://medium.com/@hmalgewatta/setting-up-an-aws-ec2-instance-with-ssh-access-using-terraform-c336c812322f

## Usefull commands

* cloud-init devel schema --config-file ${file.yaml}
