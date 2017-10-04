#####
resource "aws_instance" "worker3" {
  ami = "${var.amis["${var.aws_region}"]}"
  instance_type = "m4.xlarge"
  vpc_security_group_ids = ["${aws_security_group.SSH.id}", "${aws_security_group.CLU.id}"]
  key_name = "${var.ssh_key_name}"
  subnet_id = "${aws_subnet.priv0.id}"
  ebs_optimized = true
  placement_group = "${aws_placement_group.cluster-1.id}"
  iam_instance_profile = "${aws_iam_instance_profile.worker.name}"
  root_block_device = { "volume_type" = "gp2", "volume_size" = "50", "delete_on_termination" = true }
  ebs_block_device = { "device_name" = "/dev/sdf", "volume_type" = "gp2", "volume_size" = "100", "delete_on_termination" = true, "encrypted" = true }
  ebs_block_device = { "device_name" = "/dev/sdg", "volume_type" = "gp2", "volume_size" = "100", "delete_on_termination" = true, "encrypted" = true }
  user_data = "${file("userdata-worker")}"
  depends_on = ["aws_placement_group.cluster-1", "aws_route.priv", "null_resource.hadoop-deployment-bash", "aws_instance.jumphost"]

  tags {
    Name = "${var.tag_name}-worker3"
    type = "worker"
    owner = "${var.tag_owner}"
    project = "${var.tag_project}"
  }

  volume_tags {
    Name = "${var.tag_name}-worker3"
    type = "worker"
    owner = "${var.tag_owner}"
    project = "${var.tag_project}"
  }

  connection {
    bastion_host = "${aws_instance.jumphost.public_dns}"
    user = "${var.user}"
    private_key = "${file("${var.ssh_key_file}")}"
  }

  provisioner "file" {
    source = "${path.module}/hadoop-deployment-bash"
    destination = "/home/${var.user}"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.user}/hadoop-deployment-bash/*.sh /home/${var.user}/hadoop-deployment-bash/*/*.sh",
      "sudo bash /home/${var.user}/hadoop-deployment-bash/evaluate.sh >/home/${var.user}/evaluate.0.pre.out 2>/home/${var.user}/evaluate.0.pre.err",
      "sudo bash /home/${var.user}/hadoop-deployment-bash/utilities/set_hostname.sh $(hostname -f)",
      "sudo bash /home/${var.user}/hadoop-deployment-bash/install_tools.sh",
      "sudo bash /home/${var.user}/hadoop-deployment-bash/change_swappiness.sh",
      "sudo bash /home/${var.user}/hadoop-deployment-bash/disable_iptables.sh",
      "sudo bash /home/${var.user}/hadoop-deployment-bash/disable_selinux.sh",
      "sudo bash /home/${var.user}/hadoop-deployment-bash/disable_thp.sh",
      "sudo bash /home/${var.user}/hadoop-deployment-bash/install_ntp.sh",
      "sudo bash /home/${var.user}/hadoop-deployment-bash/install_nscd.sh",
      "sudo bash /home/${var.user}/hadoop-deployment-bash/install_jdk.sh 8",
      "sudo bash /home/${var.user}/hadoop-deployment-bash/configure_javahome.sh",
      "sudo bash /home/${var.user}/hadoop-deployment-bash/install_jce.sh",
      "sudo bash /home/${var.user}/hadoop-deployment-bash/install_krb5.sh",
      "sudo bash /home/${var.user}/hadoop-deployment-bash/configure_tuned.sh",
      "sudo bash /home/${var.user}/hadoop-deployment-bash/install_entropy.sh",
      "sudo bash /home/${var.user}/hadoop-deployment-bash/install_clouderamanageragent.sh ${aws_instance.manager.private_dns} ${var.cmver}",
      "sudo bash /home/${var.user}/hadoop-deployment-bash/evaluate.sh >/home/${var.user}/evaluate.1.post.out 2>/home/${var.user}/evaluate.1.post.err",
    ]
  }
}

#####
output "ec2_instance.worker3.priv" {
  value = "${aws_instance.worker3.private_dns}"
}

