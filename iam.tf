resource "aws_iam_role" "master" {
  name = "${var.tag_name}-master"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}

resource "aws_iam_instance_profile" "master" {
  name = "${var.tag_name}-master"
  role = "${aws_iam_role.master.name}"
}

resource "aws_iam_role" "worker" {
  name = "${var.tag_name}-worker"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}

resource "aws_iam_instance_profile" "worker" {
  name = "${var.tag_name}-worker"
  role = "${aws_iam_role.worker.name}"
}

resource "aws_key_pair" "user" {
  key_name = "${var.ssh_key_name}"
  public_key = "${file("${var.ssh_key_file}.pub")}"
}

