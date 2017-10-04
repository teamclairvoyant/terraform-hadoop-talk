#####
resource "aws_security_group" "SSH" {
  name = "${var.tag_name} SSH"
  description = "SSH Only"
  vpc_id = "${aws_vpc.main.id}"

  tags {
  Name = "SSH"
  owner = "${var.tag_owner}"
  project = "${var.tag_project}"
  }
}

resource "aws_security_group_rule" "SSH" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.SSH.id}"
}

resource "aws_security_group_rule" "SSH-1" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["${var.remote_ips}"]
  security_group_id = "${aws_security_group.SSH.id}"
}

resource "aws_security_group_rule" "SSH-2" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.MGMT.id}"
  security_group_id = "${aws_security_group.SSH.id}"
}

#####
resource "aws_security_group" "SCM" {
  name = "${var.tag_name} Manager"
  description = "Cloudera Manager"
  vpc_id = "${aws_vpc.main.id}"

  tags {
  Name = "Manager"
  owner = "${var.tag_owner}"
  project = "${var.tag_project}"
  }
}

resource "aws_security_group_rule" "SCM" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.SCM.id}"
}

resource "aws_security_group_rule" "SCM-1" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  source_security_group_id = "${aws_security_group.CLU.id}"
  security_group_id = "${aws_security_group.SCM.id}"
}

resource "aws_security_group_rule" "SCM-2" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  source_security_group_id = "${aws_security_group.MGMT.id}"
  security_group_id = "${aws_security_group.SCM.id}"
}

#####
resource "aws_security_group" "CLU" {
  name = "${var.tag_name} Cluster"
  description = "Hadoop Cluster"
  vpc_id = "${aws_vpc.main.id}"

  tags {
  Name = "Cluster"
  owner = "${var.tag_owner}"
  project = "${var.tag_project}"
  }
}

resource "aws_security_group_rule" "CLU" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.CLU.id}"
}

# Allow all from other CLU nodes.
resource "aws_security_group_rule" "CLU-1" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  self = true
  security_group_id = "${aws_security_group.CLU.id}"
}

# Allow all from MGMT nodes.
resource "aws_security_group_rule" "CLU-2" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  source_security_group_id = "${aws_security_group.MGMT.id}"
  security_group_id = "${aws_security_group.CLU.id}"
}

# Allow all from Cloudera Manager
resource "aws_security_group_rule" "CLU-3" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  source_security_group_id = "${aws_security_group.SCM.id}"
  security_group_id = "${aws_security_group.CLU.id}"
}

#####
resource "aws_security_group" "MGMT" {
  name = "${var.tag_name} MGMT"
  description = "MGMT Traffic"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "MGMT"
    owner = "${var.tag_owner}"
    project = "${var.tag_project}"
  }
}

resource "aws_security_group_rule" "MGMT" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.MGMT.id}"
}

