## Deploying a Kubernetes Cluster to ONE with Ansible and Terraform

### Installation information

####  Installing Terraform 

To install Terraform, find the appropriate package for your system and download it

$ curl -O  https://releases.hashicorp.com/terraform/0.11.3/terraform_0.11.3_linux_amd64.zip

After downloading Terraform, unzip the package

$ mkdir /bin/terraform
$ unzip terraform_0.11.3_linux_amd64.zip -d /bin/terraform/


After installing Terraform, verify the installation worked by opening a new terminal session and checking that terraform is available. 

$ export PATH=$PATH:/bin/terraform
$ terraform --version



You need to install go first: https://golang.org/doc/install

After go is installed and set up, just type:

    $ go get github.com/runtastic/terraform-provider-opennebula
    $ go install github.com/runtastic/terraform-provider-opennebula






Created by:

Miguel Ángel Flores - (miguel.angel.flores@csuc.cat)

