vpc_name = "saturday_project"
vpc_cidr = "10.10.0.0/16"
tags = {
  "CreatedBy"   = "Luc M"
  "CreatedDate" = "06/08/2024"
  "Department"  = "Sales"
}

pub_sub  = ["10.10.4.0/24", "10.10.2.0/24"]
priv_sub = ["10.10.5.0/24", "10.10.7.0/24"]

availability_zone = ["us-east-2a", "us-east-2b"]
key_pair          = "terra"

instance_type = "t2.micro"

environment = "production"

map_public_ip_on_launch = true

associate_public_ip_address = true