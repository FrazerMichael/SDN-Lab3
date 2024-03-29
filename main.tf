#Update 4
terraform {
  cloud {
    # The name of your Terraform Cloud organization.
    organization = "Michaelfrazer-demo"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "GithubAction"
    }
  }
}

locals {
  cluster-name = "SDN-Terraform-Lab3"
  key-name     = "KeyS144"
}

module "vpc" {
  source = "github.com/FrazerMichael/Terraform-Modules//aws-vpc"

  cluster      = local.cluster-name
  cidr-block   = "10.0.0.0/24"
  public-cidr  = "10.0.0.0/25"
  private-cidr = "10.0.0.128/25"
  azs          = ["us-east-1a", "us-east-1b"]
}

module "security-group" {
  source = "github.com/FrazerMichael/Terraform-Modules//aws-security-group"

  cluster = local.cluster-name
  vpc-id  = module.vpc.vpc-id
}

module "public-ec2" {
  source = "github.com/FrazerMichael/Terraform-Modules//aws-ec2"

  user-data   = file("userdata-webserver.sh")
  config-name = "1"
  cluster     = local.cluster-name
  sg-id       = module.security-group.sg-id
  SN-id       = module.vpc.public-SN-id
  key         = local.key-name

}

module "private-ec2" {
  source = "github.com/FrazerMichael/Terraform-Modules//aws-ec2"

  user-data   = file("userdata-webserver.sh")
  cluster     = local.cluster-name
  sg-id       = module.security-group.sg-id
  SN-id       = module.vpc.private-SN-id
  key         = local.key-name
  private     = true
  config-name = "2"
}