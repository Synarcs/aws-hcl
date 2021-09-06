resource "aws_security_group" "nginx-dep" {
    name = "nginx-dep" 
    vpc_id = aws_vpc.mesh_vpc.id 
    ingress {
        from_port = 22 
        to_port = 22 
        protocol = "tcp" 
        cidr_blocks = [var.internet_gateway_ip]
    }
    ingress {
        from_port = 9000 
        to_port = 9000
        protocol = "tcp" 
        cidr_blocks = [var.internet_gateway_ip]
    }
    egress {
        from_port = 0 
        to_port = 0
        protocol = "-1" 
        cidr_blocks = [var.internet_gateway_ip]
        prefix_list_ids = [] 
    }
    tags = {
        Name: "custom_vpc security Group"
    }
}
