
// Workspace Data
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

module "aws_instance" {
  source  = "app.terraform.io/rogercorp/aws-instance-PMR/tfe"
  version = "1.0.5"

  name   = "rchao-test-1"
  instance_count = "1"
  instance_type = "t2.micro"
  owner = "rchao"
  ttl = "3"

  vpc_security_group_ids  = [data.terraform_remote_state.aws_security_group.outputs.security_group_id]
  subnet_id               = data.terraform_remote_state.aws_vpc_prod.outputs.public_subnets[0]
}
