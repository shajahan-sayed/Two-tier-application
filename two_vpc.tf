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

#Creating elastic ip and assigning to nat gateway
resource "aws_eip" "nat_eip" {
 domain="vpc"
}

# NAT gateway for private subnets
resource "aws_nat_gateway" "NAT" {
 allowcation_id = aws_eip.nat_eip
 subnet_id = aws_subnet.public_subnet1

  tags = {
    Name = "NAT"
  }

 depends on = [aws_internet_gateway.igw]
}

#creating route table for private subnet
resource "aws_subnet" "private_rt" {
 vpc.id = aws_vpc.vpc_2tier

 tags = {
   Name = "private_rt"
 }
}

#attaching nat gateway to private subnets

resource "aws_route" "private_nat_gateway_rt" {
 route_table_id = aws_route_table_id.private_rt
 destination_cidr_block = "0.0.0.0/0"
 gateway_id = aws_nat_gateway.NAT
}

#associate private subnets with private route table
 resource "route" "private_subnet1_ association" {
  subnet_id = aws_subnet.private_subnet1
  route_table_id = aws.route_table_id.private_rt
 }
resource "route" "private_subnet_association" {
  subnet_id = aws_subnet.private_subnet2
  route_table_id = aws.route_table_id.private_rt
}

##security group
#EC2 security group allow (http & SSH)
resource "aws_security_group" "ec2_sg" {
 vpc_id = aws_vpc.vpc_2tier

 ingress {
 desscription = "allow SSH"
 from_port = 22
 to_port = 22
 protocol    = "tcp"
 cidr_blocks = ["0.0.0.0/0"] # Change to your IP for security
}

ingress {
 description = "Allow HTTP"
 from_port   = 80
 to_port     = 80
 protocol    = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
}
egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

  tags = {
     Name = "EC2-SG"
  }
}
## 🗄️ RDS Security Group (Allows MySQL from EC2)
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    description     = "Allow MySQL from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id] # Only allow EC2
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "RDS-SG" }
}

  


  
  






  
