
resource "aws_subnet" "avail_zone"  {
    vpc_id  = aws_vpc.mesh_vpc.id 
    cidr_block = var.subnet_cidr_block[0].cidr
    availability_zone = "us-east-1a"
    tags = {
        Name: var.subnet_cidr_block[0].name
        envFor: "eks-clusterName1" 
    }
}

# data "aws_vpc" "default_vpc" {
#     cidr_block = "10.0.0.0/16"
# }

resource "aws_subnet" "data_subnet" {
    vpc_id = aws_vpc.mesh_vpc.id 
    cidr_block = var.subnet_cidr_block_data[0].cidr[0] 
    availability_zone = "us-east-1c"        
    tags = {
        Name: var.subnet_cidr_block_data[0].name
        envFor: "eks-cluster" 
    }
}


resource "aws_s3_bucket" "terraform_bucket" {
    bucket = var.s3BucketName 
    acl = "public-read" 

    tags = {
        Name: "terraform_bucket"
        Env: "prod" 
    }
}

resource "aws_s3_bucket_object" "push_object" {
    bucket = var.s3BucketName 
    key = "load_balancer" 
    source = "./terraform.tfstate" 
    etag = file("./terraform.tfstate") 
}