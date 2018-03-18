provider "opennebula" {
  endpoint = "${var.endpoint_url}"
  username = "${var.one_username}"
  password = "${var.one_password}"
}

data "template_file" "tf-kube-template" {
  template = "${file("kube-template.tpl")}"
}

resource "opennebula_template" "tf-kube-template" {
  name = "terraform-kube-template"
  description = "${data.template_file.tf-kube-template.rendered}"
  permissions = "600"
}


resource "opennebula_vm" "kube-master-vm" {
  name = "terraform-kube-master"
  template_id = "${opennebula_template.tf-kube-template.id}"
  permissions = "600"

  # This will create 1 instances
  count = 1
}

resource "opennebula_vm" "kube-node-vm" {
  name = "terraform-kube-node${count.index}"
  template_id = "${opennebula_template.tf-kube-template.id}"
  permissions = "600"

  # This will create 1 instances
  count = 2
}

resource "null_resource" "kubernetes" {
  provisioner "local-exec" {
    command = <<EOD
    cat <<EOF > opennebula_hosts
[master]
${join("\n", opennebula_vm.kube-master-vm.*.ip)}

[node]
${join("\n", opennebula_vm.kube-node-vm.*.ip)}


[kube-cluster:children]
master
node
EOF
EOD
  }

  provisioner "local-exec" {
     command =  "ansible-playbook -i opennebula_hosts site.yml --ask-sudo-pass"
  }

}


#-------OUTPUTS ------------

output "kube-master-vm_id" {
  value = "${join("\n", opennebula_vm.kube-master-vm.*.id)}"
}

output "kube-master-vm_ip" {
  value = "${join("\n", opennebula_vm.kube-master-vm.*.ip)}"
}


output "kube-node-vm_id" {
  value = "${join("\n", opennebula_vm.kube-master-vm.*.id)}"
}

output "kube-node-vm_ip" {
  value = "${join("\n", opennebula_vm.kube-master-vm.*.ip)}"
}

