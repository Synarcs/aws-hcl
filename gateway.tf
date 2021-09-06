
resource "aws_internet_gateway" "terraform_vpc_gateway" {
    vpc_id = aws_vpc.mesh_vpc.id 
    tags = {
        Name: "terraform_vpc_gateway" 
    }
}

resource "aws_route_table" "terraform_vpc_route_table" {
    vpc_id = aws_vpc.mesh_vpc.id 
    route {
            cidr_block = var.internet_gateway_ip 
            gateway_id = aws_internet_gateway.terraform_vpc_gateway.id 
    }
    tags = {
        Name: "terraform_vpc_route_table"
    }
}

# assciate default route table to newly created route table (which has igw) 
# so that the subnet can use the new created route table using igw internally 
resource "aws_route_table_association" "subnetassociation-igwA" {
    subnet_id = aws_subnet.avail_zone.id 
    route_table_id = aws_route_table.terraform_vpc_route_table.id 
}


# # associate internet gateway to the default route table 
# # attach a igw to the default route table in vpc 
resource "aws_default_route_table" "default-route-table" {
    default_route_table_id = aws_vpc.mesh_vpc.default_route_table_id 
    route {
            cidr_block = var.internet_gateway_ip 
            gateway_id = aws_internet_gateway.terraform_vpc_gateway.id 
    }
    tags = {
        Name: "terraform_vpc_route_table_default"
    }
}


### not needed done by aws 
# # associate the subnet to default gateway 
# resource "aws_route_table_association" "subnetassociation-default-igwA" {
#     subnet_id = aws_subnet.avail_zone.id 
#     route_table_id = aws_default_route_table.default-route-table.default_route_table_id
# }
