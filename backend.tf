terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"


    }

  }
}

terraform {
  backend "s3" {
    bucket         = "terraform-buck-luc"
    key            = "ec2proj/terraform.state"
    dynamodb_table = "terraform-locks"
    encrypt        = false
    region         = "us-east-2"
  }
}