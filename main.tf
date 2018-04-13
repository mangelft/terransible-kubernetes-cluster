terraform {
    backend "consul" {
    address         = "192.168.1.210:8500"
    path            = "terraform/tfstate"
    access_token    = "supersecure"
    lock            = true
  }
}

provider "opennebula" {
  endpoint = "${var.endpoint_url}"
  username = "${var.one_username}"
  password = "${var.one_password}"
}

data "template_file" "tf-one-template" {
  template = "${file("one-template.tpl")}"
}

resource "opennebula_template" "tf-one-template" {
  name = "terraform-one-template"
  description = "${data.template_file.tf-one-template.rendered}"
  permissions = "600"
}

resource "opennebula_vm" "one-vm" {
  name = "terraform-one-vm-${count.index}"
  template_id = "${opennebula_template.tf-one-template.id}"
  permissions = "600"

  # This will create 1 instances
  count = 1
  
  provisioner "local-exec" {
    command = "tower-cli host create --name ${self.ip} --inventory jenkins"
  }

  provisioner "local-exec" {
    command = "tower-cli host associate --host ${self.ip} --group webserver"
  }

}

#-------OUTPUTS ------------

output "one-vm-id" {
  value = "${opennebula_vm.one-vm.*.id}"
}

output "one-vm-ip" {
  value = "${opennebula_vm.one-vm.*.ip}"
}


