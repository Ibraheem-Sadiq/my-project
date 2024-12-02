# resource "aws_vpc" "block_vpc" {
# cidr_block = var.vpc_cidr

# tags = {
#     Name = var.vpc_name
# }
# }

# resource "aws_subnet" "block_subnet_pub" {
# count =  var.pub_sub_count
# cidr_block =var.pub_sub_cidrs[count.index]
# availability_zone = var.pub_sub_azs[count.index]
# vpc_id = aws_vpc.block_vpc
# depends_on = [ aws_vpc.block_vpc ]
# }

# resource "aws_subnet" "block_subnet_priv" {
# count =  var.priv_sub_count
# cidr_block = var.priv_sub_cidrs[count.index]
# availability_zone = var.priv_sub_azs[count.index]
# vpc_id = aws_vpc.block_vpc
# depends_on = [ aws_vpc.block_vpc ]

# }

# resource "aws_internet_gateway" "block_igw" {
# vpc_id = aws_vpc.block_vpc.id

# tags = {
#     Name = "igw-1"
# }
# depends_on = [ aws_vpc.block_vpc ]
# }
# resource "aws_route_table" "block_gw_rt" {
# vpc_id = aws_vpc.block_vpc.id

# route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.block_igw.id
# }
# depends_on = [ aws_vpc.block_vpc,aws_internet_gateway.block_igw ]
# }

# resource "aws_route_table_association" "block_rt_assoc_pub" {
# subnet_id = aws_subnet.block_subnet_pub[count.index].id
# route_table_id = aws_route_table.block_gw_rt.id
# depends_on = [ aws_vpc.block_vpc ,aws_route_table.block_gw_rt,aws_subnet.block_subnet_pub ]
# }

# resource "aws_route_table" "nat_gw_rt" {
# vpc_id = aws_vpc.block_vpc.id
# route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.block_natgw[count.index].id
# }
#   depends_on = [ aws_vpc.block_vpc ,aws_route_table.block_natgw ]

# }
# resource "aws_nat_gateway" "block_natgw" {
# allocation_id = aws_eip.block_eip.id
# subnet_id = aws_subnet.block_subnet_priv[count.index].id
# depends_on = [ aws_subnet.block_subnet_priv ,aws_eip.block_eip ]
# }

# resource "aws_eip" "block_eip" {
# }

# resource "aws_route_table_association" "block_rt_assoc_priv" {
# count = 2
# subnet_id = aws_subnet.block_subnet_priv[count.index].id
# route_table_id = aws_route_table.block_natgw_rt.id
# depends_on = [ aws_vpc.block_vpc ,aws_route_table.block_natgw,aws_subnet.block_subnet_priv ]
# }



resource "aws_vpc" "vpc" {
    cidr_block       = var.vpc_cidr
    enable_dns_hostnames = true

    tags = {
    Name = var.vpc_name
    }
}

resource "aws_subnet" "public_subnet" {
  count             = var.public_subnets_config["subnet_count"][0]
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnets_config["subnet_cidrs"][count.index]
  availability_zone = var.public_subnets_config["subnet_azs"][count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "Public_Subnet-${count.index + 1}"
    "kubernetes.io/cluster/fp-cluster" = "shared"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
      Name: "${var.vpc_name}-igw"
    }
}
resource "aws_route_table" "igw-rtw" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
      Name: "${var.vpc_name}-rtb-public"
    }
}
resource "aws_route_table_association" "rtb_igw_association" {
    count = var.public_subnets_config["subnet_count"][0]
    subnet_id = aws_subnet.public_subnet[count.index].id
    route_table_id = aws_route_table.igw-rtw.id
}
resource "aws_subnet" "private_subnet" {
  count             = var.private_subnets_config["subnet_count"][0]
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnets_config["subnet_cidrs"][count.index]
  availability_zone = var.private_subnets_config["subnet_azs"][count.index]
  
  tags = {
    Name = "Private_Subnet-${count.index + 1}"
    "kubernetes.io/cluster/fp-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_nat_gateway" "ngw" {
  count = var.private_subnets_config["subnet_count"][0]
  subnet_id = aws_subnet.public_subnet[count.index].id
  allocation_id = aws_eip.eip[count.index].id
}
resource "aws_route_table" "ngw-rtw" {
    count = var.private_subnets_config["subnet_count"][0]
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.ngw[count.index].id
    }
    tags = {
      Name: "${var.vpc_name}-rtb-private"
    }
}
resource "aws_route_table_association" "rtb_ngw_association" {
    count = var.private_subnets_config["subnet_count"][0]
    subnet_id = aws_subnet.private_subnet[count.index].id
    route_table_id = aws_route_table.ngw-rtw[count.index].id
}
resource "aws_eip" "eip" {
  count = var.private_subnets_config["subnet_count"][0]
}



