resource "aws_vpc" "my-aws_vpc" {
    cidr_block = var.aws_vpc
    tags = {
        Name = "my-aws-vpc"
    }
}
resource "aws_subnet" "my-aws_public_subnet" {
    vpc_id = aws_vpc.my-aws_vpc.id
    cidr_block = var.aws_public_subnet_cidr
    availability_zone = "ap-south-1a"
    tags = {
        Name = "my-aws-public-subnet"
    }
}

resource "aws_subnet" "my-aws_private_subnet" {
    vpc_id = aws_vpc.my-aws_vpc.id
    cidr_block = var.aws_private_subnet_cidr
    availability_zone = "ap-south-1a"
    tags = {
        Name = "my-aws-private-subnet"
    }
}
resource "aws_internet_gateway" "myigw" {
    vpc_id = aws_vpc.my-aws_vpc.id
    tags = {
        Name = "my-internet-gateway"
    }
}

resource "aws_eip" "my-eip" {
    tags = {
        Name = "my-eip"
    }
}

resource "aws_nat_gateway" "my-nat-gateway" {
    allocation_id = aws_eip.my-eip.id
    subnet_id     = aws_subnet.my-aws_public_subnet.id
    tags = {
        Name = "my-nat-gateway"
    }
  
}
resource "aws_route_table" "my-aws_public_route_table" {
    vpc_id = aws_vpc.my-aws_vpc.id
    tags = {
        Name = "my-aws-public-route-table"
    }       
}

resource "aws_route_table" "my-aws_private_route_table" {
    vpc_id = aws_vpc.my-aws_vpc.id
    tags = {
        Name = "my-aws-private-route-table"
    }       
}
resource "aws_route" "my-aws_public_route" {
    route_table_id        = aws_route_table.my-aws_public_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id            = aws_internet_gateway.myigw.id
}

resource "aws_route" "my-aws_private_route" {
    route_table_id         = aws_route_table.my-aws_private_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.my-nat-gateway.id
}

resource "aws_route_table_association" "my-aws_public_route_table_association" {
    subnet_id = aws_subnet.my-aws_public_subnet.id
    route_table_id = aws_route_table.my-aws_public_route_table.id
}

resource "aws_route_table_association" "my-aws_private_route_table_association" {
    subnet_id = aws_subnet.my-aws_private_subnet.id
    route_table_id = aws_route_table.my-aws_private_route_table.id
}

resource "aws_security_group" "my-aws_security_group" {
    vpc_id = aws_vpc.my-aws_vpc.id
    name = "my-aws-security-group"
    description = "Security group for my VPC"
    
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }   
    egress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }       

    tags = {
        Name = "my-aws-security-group"
    }

}



