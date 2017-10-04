#####
resource "aws_iam_role" "jumphost" {
  name = "${var.tag_name}-jumphost"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}

resource "aws_iam_instance_profile" "jumphost" {
  name = "${var.tag_name}-jumphost"
  role = "${aws_iam_role.jumphost.name}"
}

#####
resource "aws_instance" "jumphost" {
  ami = "${var.amis["${var.aws_region}"]}"
  instance_type = "t2.small"
  vpc_security_group_ids = ["${aws_security_group.SSH.id}", "${aws_security_group.MGMT.id}"]
  key_name = "${var.ssh_key_name}"
  subnet_id = "${aws_subnet.pub0.id}"
  associate_public_ip_address = true
  iam_instance_profile = "${aws_iam_instance_profile.jumphost.name}"
  user_data = "${file("userdata-jumphost")}"
  root_block_device = { "volume_type"= "gp2", "volume_size"= "8", "delete_on_termination"= true }

  tags {
    Name = "${var.tag_name}-jumphost"
    type = "jumphost"
    owner = "${var.tag_owner}"
    project = "${var.tag_project}"
  }

  volume_tags {
    Name = "${var.tag_name}-jumphost"
    type = "jumphost"
    owner = "${var.tag_owner}"
    project = "${var.tag_project}"
  }
}

#####
output "ec2_instance.jumphost.pub" {
  value = "${aws_instance.jumphost.public_dns}"
}

output "ec2_instance.jumphost.priv" {
  value = "${aws_instance.jumphost.private_dns}"
}

