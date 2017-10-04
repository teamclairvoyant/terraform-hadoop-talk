resource "aws_placement_group" "cluster-1" {
  name = "${var.tag_name}-Cluster-1"
  strategy = "cluster"
}

