resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "${var.tag_name}"
    owner = "${var.tag_owner}"
    project = "${var.tag_project}"
  }
}

#####
resource "aws_subnet" "pub0" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.public_subnet0_cidr}"
  availability_zone = "${var.aws_region}a" #TODO: fix hardcoding.

  tags {
    Name = "${var.tag_name} Public subnet 0"
    owner = "${var.tag_owner}"
    project = "${var.tag_project}"
  }
}

#resource "aws_subnet" "pub1" {
#  vpc_id = "${aws_vpc.main.id}"
#  cidr_block = "${var.public_subnet1_cidr}"
#  availability_zone = "${var.aws_region}b" #TODO: fix hardcoding.
#
#  tags {
#    Name = "${var.tag_name} Public subnet 1"
#    owner = "${var.tag_owner}"
#    project = "${var.tag_project}"
#  }
#}

resource "aws_subnet" "priv0" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.private_subnet0_cidr}"
  availability_zone = "${var.aws_region}a" #TODO: fix hardcoding.

  tags {
    Name = "${var.tag_name} Private subnet 0"
    owner = "${var.tag_owner}"
    project = "${var.tag_project}"
  }
}

#resource "aws_subnet" "priv1" {
#  vpc_id = "${aws_vpc.main.id}"
#  cidr_block = "${var.private_subnet1_cidr}"
#  availability_zone = "${var.aws_region}b" #TODO: fix hardcoding.
#
#  tags {
#    Name = "${var.tag_name} Private subnet 1"
#    owner = "${var.tag_owner}"
#    project = "${var.tag_project}"
#  }
#}

#####
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.tag_name}"
    owner = "${var.tag_owner}"
    project = "${var.tag_project}"
  }
}

#####
resource "aws_default_network_acl" "main" {
  default_network_acl_id = "${aws_vpc.main.default_network_acl_id}"
  subnet_ids = ["${aws_subnet.pub0.id}", "${aws_subnet.priv0.id}"]
  egress {
    protocol = "-1"
    rule_no = 100
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }

  ingress {
    protocol = "-1"
    rule_no = 100
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }

  tags {
    Name = "${var.tag_name}"
    owner = "${var.tag_owner}"
    project = "${var.tag_project}"
  }
}

#####
resource "aws_route_table" "pub" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.tag_name} Public route"
    owner = "${var.tag_owner}"
    project = "${var.tag_project}"
  }
}

resource "aws_default_route_table" "priv" {
  default_route_table_id = "${aws_vpc.main.default_route_table_id}"

  tags {
    Name = "${var.tag_name} Private route"
    owner = "${var.tag_owner}"
    project = "${var.tag_project}"
  }
}

resource "aws_route" "pub" {
  route_table_id = "${aws_route_table.pub.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.gw.id}"
  depends_on = ["aws_route_table.pub"]
}

resource "aws_route" "priv" {
  route_table_id = "${aws_default_route_table.priv.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.gw.id}"
  depends_on = ["aws_default_route_table.priv"]
}


resource "aws_route_table_association" "pub" {
  subnet_id = "${aws_subnet.pub0.id}"
  route_table_id = "${aws_route_table.pub.id}"
}

#resource "aws_route_table_association" "pub" {
#  subnet_id = "${aws_subnet.pub1.id}"
#  route_table_id = "${aws_route_table.pub.id}"
#}

resource "aws_route_table_association" "priv" {
  subnet_id = "${aws_subnet.priv0.id}"
  route_table_id = "${aws_default_route_table.priv.id}"
}

#resource "aws_route_table_association" "priv1" {
#  subnet_id = "${aws_subnet.priv1.id}"
#  route_table_id = "${aws_default_route_table.priv.id}"
#}

#####
resource "aws_vpc_endpoint" "private-s3" {
  vpc_id = "${aws_vpc.main.id}"
  service_name = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids = ["${aws_default_route_table.priv.id}"]
#  policy = "FIXME"
}

#####
resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.pub0.id}"
  depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_eip" "nat" {
  vpc = true
}

