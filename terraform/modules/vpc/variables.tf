

variable "pub_sub_count" {
  default = 2
}

variable "pub_sub_cidrs" {
  type = list
  default = ["10.0.1.0/24","10.0.2.0/24"]
 }
variable "vpc_cidr" {
  type = string
}
variable "vpc_name" {
  type = string
}
variable "private_subnets_config" {
    type = map(any)
}
variable "public_subnets_config" {
    type = map(any)
}