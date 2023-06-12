# creation du vpc virtual private cloud
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags={
    Name="vpc-main"
  }
}

# creation des subnet : souvent un public et un privé, le public hebergera la nat gateway pour le subnet privé
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
    tags={
    Name="subnet-public"
  }

}
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
    tags={
    Name="subnet-private"
  }
}
# gateway permetant au vpc (ce qui transite par subnet public) de se connecter à internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}
# table de routage pour le subnet public afin de router le trafic autre que local vers la internet gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}
#association du subnet public avec la table de route public
resource "aws_route_table_association" "public" {
  subnet_id=aws_subnet.public.id
  route_table_id=aws_route_table.public.id
}


# elastic ip pour la nat gateway du subnet privé
resource "aws_eip" "ip-ngw" {
  domain = "vpc" # pour ipv4
}
# nat gateway pour que le subnet privé puisse effectuer des sorties sur internet mais ne permettant pas les entrée vers lui
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ip-ngw.id
  subnet_id = aws_subnet.public.id # toujours deployer dans subnet public
}
# table de routage pour le subnet privé afin de router le trafic autre que local vers la nat gateway
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block="0.0.0.0/0" # la source
    nat_gateway_id=aws_nat_gateway.ngw.id # la destination
  }
   tags={
    Name="private-rt"
  }
}
#association du subnet private avec la table de route private
resource "aws_route_table_association" "private" {
  subnet_id=aws_subnet.private.id
  route_table_id=aws_route_table.private.id
}