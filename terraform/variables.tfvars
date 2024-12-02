vpc_name = "VPC"
vpc_cidr = "10.0.0.0/16"


public_subnets_config = {
  subnet_count = [2]
  subnet_cidrs = ["10.0.1.0/24" , "10.0.2.0/24"]
  subnet_azs   = ["eu-west-3a" , "eu-west-3b"]
}
private_subnets_config = {
  subnet_count = [0]
  subnet_cidrs = ["10.0.3.0/24" , "10.0.4.0/24"]
  subnet_azs   = ["eu-west-3a" , "eu-west-3b"]
}
# pub_sub_conf=
# {
# sub_cidrs = ["10.0.0.0/24","10.0.1.0/24"]
# sub_count = 2
# sub_azs = ["us-east-1b", "us-east-1v"]
# }
# priv_sub_conf={
# sub_cidrs = ["10.0.2.0/24","10.0.3.0/24"]
# sub_count= 2
# sub_azs = ["us-east-1b", "us-east-1c"]
# }
ec2_ami    = "ami-0866a3c8686eaeeba"
ec2_type   = "t2.micro"
eks_addons =["kube-proxy","kube-proxy","aws-ebs-csi-driver","vpc-cni"]
backup_sechdule    = "cron(0 12 * * ? *)"
