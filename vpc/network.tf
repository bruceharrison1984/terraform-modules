resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.default_tags, {
    Name = "${var.name}-igw"
  })
}

resource "aws_nat_gateway" "main" {
  count = length(data.aws_availability_zones.available.names)

  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on    = [aws_internet_gateway.main]

  tags = merge(var.default_tags, {
    Name = "${var.name}-nat-${format("%03d", count.index + 1)}"
  })
}

resource "aws_eip" "nat" {
  count = length(data.aws_availability_zones.available.names)

  vpc = true

  tags = merge(var.default_tags, {
    Name = "${var.name}-eip-${format("%03d", count.index + 1)}"
  })
}

resource "aws_subnet" "private" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 100)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = merge(var.default_tags, {
    Name = "${var.name}-private-subnet-${format("%03d", count.index + 1)}"
  })
}

resource "aws_subnet" "public" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 1)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = merge(var.default_tags, {
    Name = "${var.name}-public-subnet-${format("%03d", count.index + 1)}"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.default_tags, {
    Name = "${var.name}-routing-table-public"
  })
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table" "private" {
  count = length(aws_subnet.private)

  vpc_id = aws_vpc.main.id

  tags = merge(var.default_tags, {
    Name = "${var.name}-routing-table-private-${format("%03d", count.index + 1)}"
  })
}

resource "aws_route" "private" {
  count = length(data.aws_availability_zones.available.names)

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
