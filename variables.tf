variable "aws_region" {
  description = "EC2 Region for the VPC"
}

variable "aws_profile" {
  description = "AWS CLI profile name"
}

variable "amis" {
  type = "map"
  description = "CentOS 7 (x86_64) - with Updates HVM, version 1704"
  default = {
    ap-south-1 = "ami-3c0e7353"
    eu-west-2 = "ami-e05a4d84"
    eu-west-1 = "ami-061b1560"
    ap-northeast-2 = "ami-08e93466"
    ap-northeast-1 = "ami-29d1e34e"
    sa-east-1 = "ami-b31a75df"
    ca-central-1 = "ami-28823e4c"
    ap-southeast-1 = "ami-7d2eab1e"
    ap-southeast-2 = "ami-34171d57"
    eu-central-1 = "ami-fa2df395"
    us-east-1 = "ami-46c1b650"
    us-east-2 = "ami-18f8df7d"
    us-west-1 = "ami-f5d7f195"
    us-west-2 = "ami-f4533694"
  }
}

variable "user" {
  description = "CentOS 7 SSH username. Must match the AMI."
  default = "centos"
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default = "192.168.100.0/24"
}

variable "public_subnet0_cidr" {
  description = "CIDR for the Public Subnet 0"
  default = "192.168.100.240/28"
}

variable "private_subnet0_cidr" {
  description = "CIDR for the Private Subnet 0"
  default = "192.168.100.0/25"
}

variable "private_subnet1_cidr" {
  description = "CIDR for the Private Subnet 1"
  default = "192.168.100.128/26"
}

variable "cmver" {
  description = "The version of CM to install."
  default = "5"
}

variable "tag_name" {
  description = "Your cluster name which will be added to object tags."
}

variable "tag_owner" {
  description = "Your email address which will be added to object tags."
}

variable "tag_project" {
  description = "Your project name which will be added to object tags."
  default = "Hadoop Cluster Testing"
}

variable "remote_ips" {
  description = "Your IP address used to limit SSH access to the jumphost. (ex [\"10.1.2.3/32\"])"
  type = "list"
  #default = ["10.1.2.3/32"]
}

variable "ssh_key_name" {
  description = "The name of the SSH key in AWS which will be installed to the instances."
  default = "HadoopClusterTestingDEMO"
}

variable "ssh_key_file" {
  description = "The full pathname of the file which holds the SSH private key. (ex ~/.ssh/id_rsa)"
  #default = "~/.ssh/id_rsa"
}

