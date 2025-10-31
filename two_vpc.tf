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
 



  
