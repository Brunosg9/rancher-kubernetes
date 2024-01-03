resource "aws_instance" "web_instance" {
  ami           = "ami-06aa3f7caf3a30282"
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.terraform-kube.id]
  key_name = "TF_key"
  count = 4
  tags = {
   "Name" = "rancher-server"
   "Name" = "ks8-0"
  }
  
  # DATA SCRIPT
  user_data = file("script.sh")
  # Adiciona um volume EBS de 30 GB
  root_block_device {
    volume_size = 30
  }
}
# DATA SCRIPT

## SSH KEY PAIR AWS REGION OREGON
resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

## CRIAÇÃO SSH KEY
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

## CRIAR A CHAVE NO LOCAL
resource "local_file" "TF-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "TF_key"
}

# SECURITY GROUP
resource "aws_security_group" "terraform-kube" {
  name        = "terraform-kube2"
  description = "terraform-kube2"
  vpc_id      = "vpc-01f1bbba3aa183df1"

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

    ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

    ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

    

  }

  egress {
    description      = "All Traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  tags = {
    Name = "terraform-kube2"
  }
}