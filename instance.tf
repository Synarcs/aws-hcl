
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

variable "default_key_pair" {
  description = "the aws_key_pair generated using terraform"
  type = string 
  default = "terraform"
}

resource "tls_private_key" "rsa_gen" {
  algorithm = "RSA"
  rsa_bits = 4096 
}

variable "public_key_name" {
  default = "public.pem"
  type = string
}

resource "aws_key_pair" "terraform_key" {
  key_name = var.default_key_pair
  public_key =  tls_private_key.rsa_gen.public_key_openssh 

  provisioner "local-exec" {
    command = "sudo echo '${tls_private_key.rsa_gen.public_key_openssh}' > ./keys/${var.public_key_name}"
  }

  provisioner "local-exec" {
    command = "sudo echo '${tls_private_key.rsa_gen.private_key_pem}' > ./keys/${self.key_name}.pem"
  }

  provisioner "local-exec" {
    command = "sudo chmod 400 ./keys/${self.key_name}.pem"
  }
}

resource "aws_instance" "run_server" {
    ami = data.aws_ami.ubuntu.id 
    instance_type = var.instance_type 


    # our instance in our route table 
    subnet_id = aws_subnet.avail_zone.id 
    vpc_security_group_ids = [aws_security_group.nginx-dep.id]
    availability_zone =  "us-east-1a"
    associate_public_ip_address =  true 
    key_name = aws_key_pair.terraform_key.key_name

    #  provisiooner connector 
    connection {
      type = "ssh" 
      host = self.public_ip 
      user = "ubuntu" 
      private_key = file("./key/${aws_key_pair.terraform_key.key_name}")
    }
    
    provisioner "remote-exec" {
      inline = [
        "export ENV=dev",
        "export image=nginx",
         "sudo apt-get update",
        "sudo apt-get install -y docker.io",
        # "echo '${tls_private_key.rsa_gen.public_key_openssh}' >> public.pem",
        # "echo '${tls_private_key.rsa_gen.private_key_pem}' >> private_key.pem",
        # "sudo chmod 400 private_key.pem"
      ]
    }

    # user_data =  file("startup.sh")

    tags = {
        Name = "nginx-dep" 
        env = "nginx dev"
    }
} 