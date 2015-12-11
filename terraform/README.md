# Terraform for a CoreOS etcd cluster

This directory contains a [Terraform](https://terraform.io) script to repeatably
create a [CoreOS](https://coreos.com/) etcd cluster.

It creates a VPC, Subnet, Internet Gateway, Routing Table linking the subnet to the gateway, a Security Group, and 3 EC2 instances in that subnet in an etcd cluster.

## Pre-reqs

* Terraform (brew install terraform)
* Curl (to get the cluster discovery token)
* AWS access keys

## Running

Firstly, create a file called terraform.tfvars with your access keys in it. These are used by Terraform when accessing AWS.

```bash
$ cat terraform.tfvars
aws_access_key = "<your_aws_access_key_here>"
aws_secret_key = "<your_aws_secret_key_here>"
```

If you're creating a new cluster from scratch, you'll need to get a new cluster token.

```bash
$ ./generate_etcd_cluster_token.sh
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    58  100    58    0     0     60      0 --:--:-- --:--:-- --:--:--    60
Next steps: terraform plan
```

This copies the template file (etcd.yml.template) to etcd.yml.template and inserts the token into the discovery line.

Check the planned changes with

```bash
$ terraform plan
Refreshing Terraform state prior to plan...

   <... data snipped for brevity... >

Plan: 9 to add, 0 to change, 0 to destroy.
```

and then you can make them happen with

```bash
$ terraform apply
aws_vpc.coreos-vpc-tf: Creating...
  cidr_block:                "" => "172.20.0.0/16"

  <... output snipped for brevity ...>

Apply complete! Resources: 9 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: terraform.tfstate
```

## Notes

The state file records all the things that Terraform created and knows about. Terraform [recommend that you place this into source control](https://www.terraform.io/intro/getting-started/build.html) to ensure everyone has the same copy.
