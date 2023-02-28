terraform {
  required_providers {
    aws = {
    source  = "hashicorp/aws"
    version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region     = "ap-east-1"
  access_key = "your-access-key"
  secret_key = "your-secret-key"
}

resource "aws_db_security_group" "iac-db-sg" {
  name = "IaCDBSecGrp"
  description = "IaC DB Security Group 3306"
  vpc_id = "vpc-04de07d7d900e861b"

  // To Allow MySQL port
  ingress {
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "rds_instance" {
  allocated_storage = 20
  identifier = "rds-terraform"
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.7.41"
  instance_class = "db.t2.micro"
  name = "shop_inventory"
  username = "admin"
  password = "admin123"
  publicly_accessible    = true
  skip_final_snapshot    = true
  
  vpc_security_group_ids = [
    aws_db_security_group.iac-db-sg
  ] 

  tags = {
    Name = "ExampleRDSServerInstance"
  }
}
