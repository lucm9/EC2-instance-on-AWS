resource "aws_vpc" "sat_vpc" {
  cidr_block = var.vpc_cidr

  tags = merge(
    var.tags,

    {
      Name = format("%-VPC-%", var.vpc_name, var.environment)
    }
  )
}

resource "aws_internet_gateway" "aws_igw" {
  vpc_id = aws_vpc.sat_vpc.id

  tags = merge(
    var.tags,
    {
      name = format("IGW-%", var.environment)
    }
  )
}

# data "aws_availability_zones" "available" {
#   state = "available"
# }

resource "aws_subnet" "pub_sub" {
  count             = length(var.availability_zone)
  vpc_id            = aws_vpc.sat_vpc.id
  availability_zone = var.availability_zone[count.index]
  cidr_block        = var.pub_sub[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = merge(var.tags,
    {
      name = format("%-Public-Subnet-%", var.environment, count.index)

    }
  )

}

resource "aws_subnet" "priv_sub" {
  count             = length(var.availability_zone)
  vpc_id            = aws_vpc.sat_vpc.id
  availability_zone = var.availability_zone[count.index]
  cidr_block        = var.priv_sub[count.index]

  tags = merge(var.tags,
    {
      name = format("%-Private-Subnet-%", var.environment, count.index)
    }
  )
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.sat_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_igw.id

  }

  tags = merge(var.tags,

    {
      name = format("%-public_rt", var.environment)
    }

  )

}

resource "aws_route_table" "Private_rt" {
  vpc_id = aws_vpc.sat_vpc.id

  tags = merge(var.tags,

    {
      name = format("%-private_rt", var.environment)
    }

  )
}

resource "aws_route_table_association" "public_asso" {
  count          = length(aws_subnet.pub_sub[*].id)
  subnet_id      = element(aws_subnet.pub_sub[*].id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "Private_asso" {
  count          = length(aws_subnet.priv_sub[*].id)
  subnet_id      = element(aws_subnet.priv_sub[*].id, count.index)
  route_table_id = aws_route_table.Private_rt.id

}


resource "aws_security_group" "ec2_sg" {
  name        = "ec2_instance_sg"
  description = "this Security is for the Ec2 instance"
  vpc_id      = aws_vpc.sat_vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags,
    {
      name = format("%-Ec2SG", var.environment)
    }
  )

}

# resource "aws_security_group_rule" "Ec2_ssh" {
#   security_group_id = aws_security_group.ec2_sg.id
# cidr_blocks     = ["0.0.0.0/0"]
#   from_port         = 80
#   ip_protocol       = "tcp"
#   to_port           = 80
# }

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # owners = [ "533267047415" ] - Only put owner if you own the Image 
}

resource "aws_instance" "luc_instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.pub_sub[0].id
  key_name                    = var.key_pair
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = var.associate_public_ip_address
}