terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.57.0"
    }
   }
#    backend "s3" {
#        bucket = "tfstate"
#        key = "tfapp/state.tfstate" 
#        region = "eu-west-3" 
#    }
}

# configure the provider for the core terraform api 
provider "aws" {
    region = "us-east-1" 
}

variable "subnet_cidr_block"  { 
    description = "subnet_cidr blcok" 
    type = list(object({
        cidr = string
        name = string 
    }))
}

variable "subnet_cidr_block_data"  { 
    description = "subnet_cidr blcok_data" 
    type = list(object({
        cidr = list(string)
        name = string
    }))
}

variable internet_gateway_ip {} 
variable vpc_cidr {} 
variable instance_type {} 
variable s3BucketName {} 

variable "vpc_name" {
    description = "name of vpc provider"
    default = "terraform" 
}

# output variables in tf 
output "get_id_vpc" {
    value = aws_vpc.mesh_vpc.id
}

# output "get_subnet_id" {
#     value = aws_subnet.data_subnet.id 
# }
