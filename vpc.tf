module "basic_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "basic-vpc"
  cidr = "10.0.0.0/16"

  enable_nat_gateway = false
  enable_vpn_gateway = false

  azs             = ["${var.region}a", "${var.region}b"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
}