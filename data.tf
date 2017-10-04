data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = [ "sts:AssumeRole" ]
    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

