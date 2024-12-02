variable "vpc_cidr" {
  type        = string
  description = "Cidr Block for VPC ex: 10.0.0.0/16"
}
variable "vpc_name" {
  type        = string
  description = "Name of VPC"
}
variable "private_subnets_config" {
  type = map(any)
}
variable "public_subnets_config" {
  type = map(any)
}
variable "ec2_ami" {
     type = string
    default = "ami-0866a3c8686eaeeba"
}

variable "ec2_type" {
  type = string
  default = "t2.micro"
}


variable "eks_addons" {
  type = list 
  default = ["kube-proxy","kube-proxy","aws-ebs-csi-driver","vpc-cni"]
}


variable "backup_sechdule" {
  type = string
  default = "cron(0 12 * * ? *)"
}