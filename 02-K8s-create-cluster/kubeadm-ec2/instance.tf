### VPC module to create vpc

locals {
  region = var.AWS_REGION
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"
  # insert the 23 required variables here


  name = "k8s-cluster"
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    Name = "overridden-name-public"
  }

  tags = {
    created       =   "terraform"
    Name          =  "k8s-cluster"
  }

}



resource "aws_instance" "master" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.medium"
  #for_each      = data.aws_subnet_ids.selected.ids
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  # the VPC subnet
  subnet_id = module.vpc.public_subnets[0]

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id,aws_security_group.Demo-kube-master-sg.id,aws_security_group.Demo-kube-mutual-sg.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name
  user_data = local.template_file_int

  tags = {
    Name = "kube-master"
    "kubernetes.io/cluster/kubeadm" = "owned"
    Role = "master"
    type = "terraform"
  }
}

resource "aws_instance" "worker" {
  count         = 1
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
  #for_each      = data.aws_subnet_ids.selected.ids
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  

  # the VPC subnet
  subnet_id = module.vpc.public_subnets[0]

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id,aws_security_group.Demo-kube-worker-sg.id,aws_security_group.Demo-kube-mutual-sg.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name
  user_data = local.template_file_int

  tags = {
    Name = "kube-worker"
    "kubernetes.io/cluster/kubeadm" = "owned"
    Role = "worker"
    type = "terraform"
    created = "terraform"
  }
}


locals {
   template_file_int  = templatefile("./install_docker_kubectl.tpl", {})
}

