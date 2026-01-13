variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type = list(object({
    name = string
    cidr = string
    az   = string
  }))
  default = [
    { name = "cmtr-k5vl9gpq-01-subnet-public-a", cidr = "10.10.1.0/24", az = "us-east-1a" },
    { name = "cmtr-k5vl9gpq-01-subnet-public-b", cidr = "10.10.3.0/24", az = "us-east-1b" },
    { name = "cmtr-k5vl9gpq-01-subnet-public-c", cidr = "10.10.5.0/24", az = "us-east-1c" }
  ]
}
