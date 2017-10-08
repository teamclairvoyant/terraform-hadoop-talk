This demo will use Terraform to set up and manage the AWS infrastructure for a small Hadoop cluster as well as install the Cloudera Manager server and agents.

**WARNING: Running this code *will* cost you money in AWS fees.**

* You must have an [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html).
* You must have [Terraform](https://www.terraform.io/) and [awscli](https://aws.amazon.com/cli/) installed.
* You must have awscli credentials (`aws configure`) already set up.
* You must have `git` installed locally.

# Summary Terraform commands

```
terraform init  # only needed once

terraform plan
terraform apply

terraform destroy
```

# Instructions

**WARNING: Running this code *will* cost you money in AWS fees.**

This demonstration will build a seven node [Cloudera](https://www.cloudera.com/) Hadoop environment using [CentOS](https://centos.org/) Linux that is ready for you to configure within Cloudera Manager.  All required and recommended OS preparation and tuning steps will be automatically performed.  There are three master nodes and four worker nodes.

There is also a jumphost ([Bastion server](https://aws.amazon.com/blogs/security/securely-connect-to-linux-instances-running-in-a-private-amazon-vpc/)) which allows you to SSH into the Hadoop environment.  This is required due to the Haddop server being on a private subnet in the AWS VPC.

Run Terraform to apply the configuration.  There will be some questions to answer and then you can wait about 16 minutes until the infrastructure is ready.

```
$ terraform apply
var.aws_profile
  AWS CLI profile name

  Enter a value: default

var.aws_region
  EC2 Region for the VPC

  Enter a value: ap-south-1

var.remote_ips
  Your IP address used to limit SSH access to the jumphost. (ex ["10.1.2.3/32"])

  Enter a value: ["1.2.3.4/32"]

var.ssh_key_file
  The full pathname of the file which holds the SSH private key. (ex ~/.ssh/id_rsa)

  Enter a value: ~/.ssh/id_demo

var.tag_name
  Your cluster name which will be added to object tags.

  Enter a value: PUNE-DEMO

var.tag_owner
  Your email address which will be added to object tags.

  Enter a value: hello@clairvoyantsoft.com

...
```

**NOTE: The SSH private key can not have a passphrase.**

If the `terraform apply` fails, attempt to fix the error and then run `terraform apply` again.

Once the `terraform apply` has completed successfully, there should be output listing the hostnames of the instances in EC2.  Find the value of `ec2_instance.jumphost.pub`.  You will use it to [SSH to the jumphost (step 1)](https://www.digitalocean.com/community/tutorials/how-to-route-web-traffic-securely-without-a-vpn-using-a-socks-tunnel) in order to further access the cluster environment.

```
ssh-add ~/.ssh/id_demo
ssh -ACD 8157 -i ~/.ssh/id_demo -l centos <EC2_INSTANCE.JUMPHOST.PUB VALUE>
# Example: ssh -ACD 8157 -i ~/.ssh/id_demo -l centos ec2-35-154-146-83.ap-south-1.compute.amazonaws.com
```

Now, you will [configure (step 2)](https://www.digitalocean.com/community/tutorials/how-to-route-web-traffic-securely-without-a-vpn-using-a-socks-tunnel) and use your web browser to connect to the Cloudera Manager server.
First, find your browser's network proxy settings.  Then change the value of the SOCKS proxy to use localhost and port 8157.  Finally, find the value of `ec2_instance.manager.priv` in the Terraform output and place that value in your browser's  navigation bar with the addition of port 7180.

Example: http://ip-192-168-100-84.ap-south-1.compute.internal:7180/

[Log in](https://www.cloudera.com/documentation/enterprise/latest/topics/cm_qs_quick_start.html#cmig_topic_6_5_2) to the Cloudera Manager server with the ussername "admin" and the password "admin".

Finish the CDH deployment by following the [new cluster deployment wizard](https://www.cloudera.com/documentation/enterprise/latest/topics/cm_qs_quick_start.html#cmig_topic_6_5_3).

Do not forget to run `terraform destroy` when you are done.

**WARNING: Running this code *will* cost you money in AWS fees.**

# License

Copyright (C) 2017 [Clairvoyant, LLC.](http://clairvoyantsoft.com/)

Licensed under the Apache License, Version 2.0.
