module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"
  
  for_each = toset(["1"]) #, "2"])
  name = "instance-${each.key}"
  instance_type = "t2.micro"
  
  user_data = <<-EOF
    #!/bin/bash
    # Installing Amazon SSM Agent...
    yum install -y https://s3.${var.region}.amazonaws.com/amazon-ssm-${var.region}/latest/linux_amd64/amazon-ssm-agent.rpm
    systemctl start amazon-ssm-agent
    # Installing httpd...
    yum install -y httpd
    echo $(ec2-metadata -i) > /var/www/html/index.html
    systemctl start httpd
    EOF

  availability_zone = element(module.basic_vpc.azs, "${each.key - 1}")
  subnet_id = element(module.basic_vpc.public_subnets, "${each.key - 1}")

  associate_public_ip_address = true
  vpc_security_group_ids = [module.allow-all_sg.security_group_id]

  iam_instance_profile = resource.aws_iam_instance_profile.ssm_managed_ec2.name

  depends_on = [module.basic_vpc, module.allow-all_sg, resource.aws_iam_instance_profile.ssm_managed_ec2]

}

module "allow-all_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "allow-all"
  description = "allow-all (dev)"
  vpc_id      = module.basic_vpc.vpc_id

  # https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest#input_rules
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]
}


