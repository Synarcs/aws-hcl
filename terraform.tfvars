subnet_cidr_block = [{cidr = "10.0.0.0/24",name = "terraform-vpc-subnet_resource"}] 
subnet_cidr_block_data = [{cidr = ["10.0.2.0/24","10.0.1.0/24"], name = "terraform-vpc-subnet_resource_data" }] 

vpc_cidr = "10.0.0.0/16"
internet_gateway_ip = "0.0.0.0/0" 

# 
ec2_amiId = "ami-09e67e426f25ce0d7"
instance_type = "t2.micro"


# bucket name
s3BucketName = "s3-terraform.com"

private_key_name = "/home/synarcs/.ssh/terraform"

remote_ssh_user = "ubuntu" 