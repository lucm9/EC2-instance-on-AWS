variable "vpc_name" {
  type        = string
  description = "This will be the name of the vpc"
}

variable "vpc_cidr" {
  type        = string
  description = "Cidr of the vpc"
}

variable "pub_sub" {
  type        = list(string)
  description = "Cidr for thw public subnets"

}

variable "priv_sub" {
  type        = list(string)
  description = "Cidr for thw public subnets"
}

variable "availability_zone" {
  type        = list(string)
  description = "The Az that will be used"

}

variable "environment" {
  type        = string
  description = "Which Environment Are We provisioining this in"

}

variable "key_pair" {
  type        = string
  description = "Name of the keypair"

}

variable "tags" {
  type        = map(string)
  description = "We will specify our tags here"

}
