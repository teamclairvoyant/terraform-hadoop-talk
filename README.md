This demo will set up and manage the infrastructure for a small, HA Hadoop cluster.

*All AWS configuration is manged from here.*


* You must have [terraform](https://www.terraform.io/) and [awscli](https://aws.amazon.com/cli/) installed.
* You must have awscli credentials (`aws configure`) already set up.
* Assumes deployment to us-west-2.

```
AWS_PROFILE=clairvoyant terraform init  # only needed once

AWS_PROFILE=clairvoyant terraform plan
AWS_PROFILE=clairvoyant terraform apply
```

