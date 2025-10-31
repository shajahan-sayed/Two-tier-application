#creating vpc
resource "aws_vpc" "vpc_2tier" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "vpc_2tier"
  }
}
#creating  public subnet1
resource "aws_subnet" "public_subnet1" {
  vpc.id = aws_vpc.vpc_2tier
  cidr_block = var.public1_cidr_block
  map_public_ip_on_launch = true
  availability_zone = ${var.region}.a

  tags = {
    Name = "public_subnet1"
  }
}
#creating public subnet2
resource "aws_subnet" "public_subnet2" {
  vpc.id = aws_vpc.vpc_2tier
  cidr_block = var.public2_cidr_block
  map_public_ip_on_launch = true
  availability_zone = ${var.region}.b
  tags = {
    Name = "public_subnet"
  }
  #creating private subnet1
  resource "aws_subnet" "private_subnet1" {
    vpc.id = aws_vpc.vpc_2tier
    cidr_block = var.private1_cidr_block
    map_public_ip_on_launch = true
    availability_zone= ${var.region}.a

    tags = {
      Name = "private_subnet1"
    }
  }
  #creating private subnet2
  resource "aws_subnet" "private_subnet2" {
    vpc.id = aws_vpc.vpc_2tier
    cidr_block = var.private2_cidr_block
    map_public_ip_on_launch = true
    avilability_zone = ${var.region}.b

    tags = {
      Name = "private_subnet2"
    }
  }

#creating internet gateway for public access
resource "aws_internet_gateway" "igw"{
  vpc.id = aws_vpc.vpc_2tier

  tags = {
    Name = "igw"
}

#creating route table for public subnet
resource "aws_route_table" "public_rt" {
 vpc.id = aws_vpc.vpc_2tier

 tags = {
   Name = "public_rt"
 }

#creating route for public internet access(connecting with internet gateway)
resource "aws_route" "public_internet_access" {
 route_table_id = aws_route_table.public_rt 
 destination_cidr_block  = "0.0.0.0/0"
 gate_way_id = aws_internet_gateway.igw
}
#associate public subnet with route table
resource "aws_route_table_association" "public_subnet_1_association" {
 subnet_id = aws_subnet.public_subnet1
 route_table_id = aws_route_table.public_rt
}
resource "aws_route_table_association" public_subnet_2_association" {
  subnet_id = aws_subnet.public_subnet2
  route_table_id = aws_route_table.public_rt
}

# NAT gateway for private subnets
resource "aws_nat_gateway" "NAT" {




  
