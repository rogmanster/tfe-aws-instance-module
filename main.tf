terraform {
  required_version = ">= 0.11.0"
}

data "terraform_remote_state" "aws_vpc_prod" {
  backend = "remote"

  config = {
    organization = "rogercorp"
    workspaces = {
      name = "aws-vpc-prod"
    }
  }
}

data "terraform_remote_state" "aws_security_group" {
  backend = "remote"

  config = {
    organization = "rogercorp"
    workspaces = {
      name = "aws-security-group-prod"
    }
  }
}

data "aws_key_pair" "example" {
  key_name           = "rchao-key"
  include_public_key = true
}

module "aws_instance" {
  source  = "app.terraform.io/rogercorp/aws-instance-PMR/tfe"
  version = "1.2.4"

  name   = "rchao-test"
  instance_count = "1"
  instance_type = "t2.micro"
  env = "module"
  ttl = "3"
  key_name = data.aws_key_pair.example.key_name

  security_group_id       = [data.terraform_remote_state.aws_security_group.outputs.security_group_id]
  subnet_id               = data.terraform_remote_state.aws_vpc_prod.outputs.public_subnets[0]
  description             = "v0.1.5"
}
