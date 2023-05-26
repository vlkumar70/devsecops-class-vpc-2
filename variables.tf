variable "region" {
  type        = string
  description = "region vlaue"
}

variable "vpc_name" {
  type        = string
  description = "VPC Name"
  default     = "devsecops-vpc-terraform"
}

variable "igw_name" {
  type        = string
  description = "Internet Gateway name"
}

variable "public_subnet_1a" {
  type        = string
  description = "Public Subnet 1a"
}

variable "application_private_1a" {
  type        = string
  description = "Application private Subnet Name"
}

variable "database_private_1a" {
  type        = string
  description = "Database private Subnet Name"
}

variable "public_subnet_1b" {
  type        = string
  description = "Public Subnet 1a"
}

variable "application_private_1b" {
  type        = string
  description = "Application private Subnet Name"
}

variable "database_private_1b" {
  type        = string
  description = "Database private Subnet Name"
}

variable "public_subnet_1c" {
  type        = string
  description = "Public Subnet 1a"
}

variable "application_private_1c" {
  type        = string
  description = "Application private Subnet Name"
}

variable "database_private_1c" {
  type        = string
  description = "Database private Subnet Name"
}

variable "availability_zone_1a" {
  type        = string
  description = "Availabilty zone 1a"
}

variable "availability_zone_1b" {
  type        = string
  description = "Availabilty zone 1b"
}

variable "availability_zone_1c" {
  type        = string
  description = "Availabilty zone 1c"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR value"
}

variable "public_subnet_1a_cidr" {
  type        = string
  description = "Public subnet 1a CIDR value"
}

variable "application_private_1a_cidr" {
  type        = string
  description = "Application 1a CIDR value"
}

variable "database_private_1a_cidr" {
  type        = string
  description = "database 1a CIDR value"
}

variable "public_subnet_1b_cidr" {
  type        = string
  description = "Public subnet 1b CIDR value"
}

variable "application_private_1b_cidr" {
  type        = string
  description = "Application 1b CIDR value"
}

variable "database_private_1b_cidr" {
  type        = string
  description = "database 1b CIDR value"
}

variable "public_subnet_1c_cidr" {
  type        = string
  description = "Public subnet 1c CIDR value"
}

variable "application_private_1c_cidr" {
  type        = string
  description = "Application 1c CIDR value"
}

variable "database_private_1c_cidr" {
  type        = string
  description = "database 1c CIDR value"
}

variable "public_route_table" {
  type        = string
  description = "public route table"
}

variable "application_route_table" {
  type        = string
  description = "application route table"
}

variable "database_route_table" {
  type        = string
  description = "database route table"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "instance_name" {
  type        = string
  description = "EC2 instance name"
}

variable "instance_keypair" {
  type        = string
  description = "EC2 instance keypair"
}

variable "ssh_port" {
  description = "The port the EC2 Instance should listen on for SSH requests."
  type        = number
  default     = 22
}

variable "ssh_user" {
  description = "SSH user name to use for remote exec connections,"
  type        = string
  default     = "ec2-user"
}
