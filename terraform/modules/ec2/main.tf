resource "aws_instance" "block_ec2" {
  ami = var.ami
  instance_type =var.type
  security_groups =[var.sg]
  subnet_id = var.sub_id
  associate_public_ip_address = true
  tags = {
    Name = "jenkins"
  }
}