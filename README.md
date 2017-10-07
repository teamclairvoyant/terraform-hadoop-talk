This demo will set up and manage the AWS infrastructure for a small Hadoop
cluster as well as install the Cloudera Manager server and agents.

**WARNING: Running this code *will* cost you money in AWS fees.**

* You must have [terraform](https://www.terraform.io/) and [awscli](https://aws.amazon.com/cli/) installed.
* You must have awscli credentials (`aws configure`) already set up.
* Assumes that `git` is installed locally.

```
terraform init  # only needed once

terraform plan
terraform apply

terraform destroy
```

**WARNING: Running this code *will* cost you money in AWS fees.**

