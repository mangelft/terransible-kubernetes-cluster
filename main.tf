provider "opennebula" {
  endpoint = "${var.endpoint_url}"
  username = "${var.one_username}"
  password = "${var.one_password}"
}

data "template_file" "tf-kube-master-template" {
  template = "${file("kube-master.tpl")}"
}

resource "opennebula_template" "tf-kube-master-template" {
  name = "terraform-kube-master-template"
  description = "${data.template_file.tf-kube-master-template.rendered}"
  permissions = "600"
}


data "template_file" "tf-kube-node-template" {
  template = "${file("kube-node.tpl")}"
}

resource "opennebula_template" "tf-kube-node-template" {
  name = "terraform-kube-node-template"
  description = "${data.template_file.tf-kube-node-template.rendered}"
  permissions = "600"
}

resource "opennebula_vm" "kube-master-vm" {
  name = "terraform-kube-master"
  template_id = "${opennebula_template.tf-kube-master-template.id}"
  permissions = "600"
}


resource "opennebula_vm" "kube-node-vm" {
  name = "terraform-kube-node"
  template_id = "${opennebula_template.tf-kube-node-template.id}"
  permissions = "600"
}

resource "null_resource" "kubernetes" {
  provisioner "local-exec" {
    command = <<EOD
    cat <<EOF > opennebula_hosts
[master]
${opennebula_vm.kube-master-vm.ip}

[node]
${opennebula_vm.kube-node-vm.ip}

[kube-cluster:children]
master
node
EOF
EOD
  }

  provisioner "remote-exec" {
    inline = ["# Master Connected!"]
    
    connection {
       host = "${opennebula_vm.kube-master-vm.ip}" 
       user = "root"
       private_key = "${file("/root/.ssh/id_rsa")}"
    }   
  }

  provisioner "remote-exec" {
    inline = ["# Node Connected!"]

    connection {
       host = "${opennebula_vm.kube-node-vm.ip}"
       user = "root"
       private_key = "${file("/root/.ssh/id_rsa")}"
    }
  }

  provisioner "local-exec" {
     command =  "ansible-playbook -i opennebula_hosts site.yml"
  }

}


#-------OUTPUTS ------------

output "kube-master-vm_id" {
  value = "${opennebula_vm.kube-master-vm.id}"
}

output "kube-master-vm_ip" {
  value = "${opennebula_vm.kube-master-vm.ip}"
}
