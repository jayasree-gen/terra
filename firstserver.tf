terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

resource "aws_instance" "example" {
  ami           = "ami-08962a4068733a2b6"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleInstance"
  }
}       




#creating security group, allow ssh and http

resource "aws_security_group" "hello-terra-ssh-http" {
                 name = "hello-terra-http-ssh"
                 description = "allowing ssh and http traffic"
            
                 ingress {
                                from_port  = 22
                                to_port = 22
                                protocal = "tcp"
                                cidr_blocks = ["0.0.0.0/0"]
       
                 }
            
                 ingress {
                                from_port  = 80
                                to_port = 80
                                protocal = "tcp"
                                cidr_blocks = ["0.0.0.0/0"]
       
                 }

                   egress {
                                from_port  = 0
                                to_port = 0
                                protocal = "-1"
                                cidr_blocks = ["0.0.0.0/0"]
       
                 }

}
#security group ends here

#creating aws ec2 instance

               security_groups = ["${aws_security_group.hello-terra-ssh-http.name}"]
               key_name = "test"
               user_data = <<-EOF 
                                  #!/bin/bash
                                  sudo yum install httpd y
                                  sudo systemctl start httpd
                                  sudo systemctl enable httpd
                                  echo "<h1>Sample Webser creating using terraform<br>Network Nuts</h1>" >> /var/www/html/index.html               
                        EOF

                 tags = {
                             Name = "webserver"
                 }

}

