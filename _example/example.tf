provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "0.15.0"

  name        = "vpc"
  environment = "test"
  label_order = ["environment", "name"]

  cidr_block = "172.16.0.0/16"
}

module "public_subnets" {
  source  = "clouddrove/subnet/aws"
  version = "0.15.0"

  name        = "public-subnet"
  environment = "test"
  label_order = ["environment", "name"]

  availability_zones = ["eu-west-1b", "eu-west-1c"]
  vpc_id             = module.vpc.vpc_id
  cidr_block         = module.vpc.vpc_cidr_block
  type               = "public"
  igw_id             = module.vpc.igw_id
  ipv6_cidr_block    = module.vpc.ipv6_cidr_block

}

module "http_https" {
  source  = "clouddrove/security-group/aws"
  version = "0.15.0"

  name        = "http-https"
  environment = "test"
  label_order = ["environment", "name"]

  vpc_id        = module.vpc.vpc_id
  allowed_ip    = ["0.0.0.0/0"]
  allowed_ports = [80, 443]
}

module "ssh" {
  source  = "clouddrove/security-group/aws"
  version = "0.15.0"

  name        = "ssh"
  environment = "test"
  label_order = ["environment", "name"]

  vpc_id        = module.vpc.vpc_id
  allowed_ip    = [module.vpc.vpc_cidr_block]
  allowed_ports = [22]
}



module "ec2" {
  source  = "clouddrove/ec2/aws"
  version = "0.15.0"

  name        = "ec2-instance"
  environment = "test"
  label_order = ["environment", "name"]

  instance_count = 1
  ami            = "ami-08d658f84a6d84a80"
  instance_type  = "t2.nano"
  monitoring     = true
  tenancy        = "default"

  vpc_security_group_ids_list = [module.ssh.security_group_ids, module.http_https.security_group_ids]
  subnet_ids                  = tolist(module.public_subnets.public_subnet_id)

  assign_eip_address          = true
  associate_public_ip_address = true

  instance_profile_enabled = false

  disk_size          = 8
  ebs_optimized      = false
  ebs_volume_enabled = true
  ebs_volume_type    = "gp2"
  ebs_volume_size    = 30

}


module "alb" {
  source = "./../"

  name        = "alb"
  environment = "test"
  label_order = ["environment", "name"]

  enable                     = true
  internal                   = false
  load_balancer_type         = "application"
  instance_count             = module.ec2.instance_count
  security_groups            = [module.ssh.security_group_ids, module.http_https.security_group_ids]
  subnets                    = module.public_subnets.public_subnet_id
  enable_deletion_protection = false
  drop_invalid_header_fields = true

  target_id = module.ec2.instance_id
  vpc_id    = module.vpc.vpc_id

  https_enabled            = false
  http_enabled             = false
  https_port               = 443
  listener_type            = "forward"
  listener_certificate_arn = "arn:aws:acm:eu-west-1:XXXXXXXXXXX:certificate/ab889a8d-c7f8-4cb7-8c34-0fecbc5fdc01"
  target_group_port        = [22000, 4444, 8001, 8888]
  http_ports               = [4444, 8001, 8888]

  target_groups = [
    {
      backend_protocol     = "HTTP"
      backend_port         = 22000
      target_type          = "instance"
      deregistration_delay = 300
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 10
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    },
    {
      backend_protocol     = "HTTP"
      backend_port         = 4444
      target_type          = "instance"
      deregistration_delay = 300
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 10
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    },
    {
      backend_protocol     = "HTTP"
      backend_port         = 8001
      target_type          = "instance"
      deregistration_delay = 300
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 10
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    },
    {
      backend_protocol     = "HTTP"
      backend_port         = 8888
      target_type          = "instance"
      deregistration_delay = 300
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 10
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  ]
}
