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
  region     = "us-west-2"
  access_key = "your-access-key"
  secret_key = "your-secret-key"
}


resource "aws_db_instance" "rds_instance" {
allocated_storage = 20
identifier = "rds-terraform"
storage_type = "gp2"
engine = "mysql"
engine_version = "8.0.27"
instance_class = "db.t2.micro"
name = "your-db-name"
username = "your-db-username"
password = "your-password"
publicly_accessible    = true
skip_final_snapshot    = true


  tags = {
    Name = "ExampleRDSServerInstance"
  }
}
