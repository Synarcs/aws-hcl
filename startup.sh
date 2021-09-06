 #!/bin/bash 
sudo apt-get update -y && suod apt-get install -y nginx && sudo apt-get install -y docker.io 
sudo su 
sudo service docker restart 
docker pull nginx:latest 
docker run --name nginx-server -p 9000:80 -v .:/tmp -d nginx