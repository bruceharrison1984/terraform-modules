resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name_prefix}-igw"
  }
}

resource "aws_nat_gateway" "main" {
  count = local.number_of_azs

  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on    = [aws_internet_gateway.main]

  tags = {
    Name = "${var.name_prefix}-nat-${format("%03d", count.index + 1)}"
  }
}

resource "aws_eip" "nat" {
  count = local.number_of_azs

  vpc = true

  tags = {
    Name = "${var.name_prefix}-eip-${format("%03d", count.index + 1)}"
  }
}

resource "aws_subnet" "private" {
  count = local.number_of_azs

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 100)
  availability_zone = element(local.available_azs, count.index)

  tags = {
    Name = "${var.name_prefix}-private-subnet-${format("%03d", count.index + 1)}"
  }
}

resource "aws_subnet" "public" {
  count = local.number_of_azs

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 1)
  availability_zone       = element(local.available_azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name_prefix}-public-subnet-${format("%03d", count.index + 1)}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name_prefix}-routing-table-public"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table" "private" {
  count = length(aws_subnet.private)

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name_prefix}-routing-table-private-${format("%03d", count.index + 1)}"
  }
}

resource "aws_route" "private" {
  count = length(aws_subnet.private)

  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.main.*.id, count.index)
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
