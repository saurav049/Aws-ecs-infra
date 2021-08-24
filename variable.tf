variable "availability_zones" {
  default = ["us-east-2a", "us-east-2b"]
  type= list(string)
}

variable "subnet_cidrs_public" {
  description = "Subnet CIDRs for public subnets"
  default = ["10.0.10.0/24", "10.0.20.0/24"]
  type = list(string)
}
