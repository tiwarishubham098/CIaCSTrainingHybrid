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
  region     = "ap-south-1"
  access_key = "your-access-key"
  secret_key = "your-secret-key"
}

resource "aws_security_group" "iac-db-sg" {
  name = "IaCDBSecGrp"
  description = "IaC DB Security Group 3306"

  // To Allow MySQL access
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
resource "aws_s3_bucket" "s3" {
  bucket = "s3-bucket-${var.your_name}"
  acl    = "private"

  tags = {
    Name        = "S3 Bucket with init.sql dump"
    Environment = IaCTesting
  }
}

resource "aws_s3_bucket_object" "init_sql" {
  bucket = aws_s3_bucket.s3.id
  key    = "init.sql.tar.gz"
  source = "${path.module}/init.sql.tar.gz00"
  etag   = filemd5("${path.module}/init.sql.tar.gz00")
}

resource "aws_db_instance" "rds_instance" {
  allocated_storage = 20
  identifier = "iacrds"
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.7.41"
  instance_class = "db.t2.micro"
  name = "shop_inventory"
  username = "admin"
  password = "admin123"
  publicly_accessible    = true
  skip_final_snapshot    = true
  
  vpc_security_group_ids = ["${aws_security_group.iac-db-sg.id}"] 
  
  s3_import {
      source_engine         = "mysql"
      source_engine_version = "5.7"
      bucket_name           = iacrdsbckup.s3.id
      ingestion_role        = arn:aws:iam::404808829238:role/rds-s3-export-role
    }
  
  tags = {
    Name = "ExampleRDSServerInstance"
  }
}
