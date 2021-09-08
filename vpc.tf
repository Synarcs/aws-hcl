
resource "aws_vpc" "mesh_vpc" {
    cidr_block = var.vpc_cidr 
    tags = {
        Name: "${var.vpc_name}-vpc" 
        env: "eks-cluster" 
        vpc_name: "private_route_table" 
    }
}

