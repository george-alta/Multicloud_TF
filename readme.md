## wordpress over AWS using terraform

this code allows to deploy an AWS VPC and an EC2 wordpress instance using Terraform. 


## what works

- [x] VPC

- [x] Subnets

- [x] IGW

- [x] Security Groups

- [x] Route tables

- [x] EC2 Creation

- [x] EC2: install MariaDB, Wordpress, PHPMyAdmin

- [x] Secrets are in tfvars file

- [x] New RDS Maria DB is created



## TO DO

- [ ] connect the EC2 instance to the newly created RDS

- [ ] modify security groups to nested permissions

- [ ] create mount for EFS (optional)

- [ ] create load balancer

- [ ] create auto scale

- [ ] create IAM certificate for load balancer


