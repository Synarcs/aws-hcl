
# get ami from aws 
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# resource "aws_key_pair" "terraform-keys" {
#     key_name =  "terraform"
#     public_key = "terraform.pub" 
# }

variable "private_key_name" {} 
variable "remote_ssh_user" {}

resource "aws_key_pair" "terraform_key" {
  key_name = "terraform" 
  public_key = file(var.private_key_name)
}


variable "default_key_pair" {
  description = "the aws_key_pair generated using terraform"
  type = string 
  default = "terraform"
}

resource "aws_instance" "run_server" {
    ami = data.aws_ami.ubuntu.id 
    instance_type = var.instance_type 


    # our instance in our route table 
    subnet_id = aws_subnet.avail_zone.id 
    vpc_security_group_ids = [aws_security_group.nginx-dep.id]
    availability_zone =  "us-east-1a"
    associate_public_ip_address =  true 
    key_name = var.default_key_pair 

    #  provisiooner connector 
    connection {
      type = "ssh" 
      host = self.public_ip 
      user = "ubuntu" 
      private_key = file(var.private_key_name)
    }
    
    provisioner "remote-exec" {
      inline = [
        "export ENV=dev",
        "export image=nginx",
         "sudo apt-get update",
        "sudo apt-get install -y docker.io",
      ]
    }

    # user_data =  file("startup.sh")

    tags = {
        Name = "nginx-dep" 
        env = "nginx dev"
    }
} 