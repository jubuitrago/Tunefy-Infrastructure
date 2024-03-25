resource "local_file" "bastion_provision_script" {
  filename = "${path.module}/bastion_provision_script.sh"
  content = templatefile("${path.module}/bastion_provision_script_template.sh", {
    CHEF_SERVER_VERSION = "14.11.21"
  })
}

resource "local_file" "nginx_provision_script" {
  filename = "${path.module}/nginx_provision_script.sh"
  content = templatefile("${path.module}/nginx_provision_script_template.sh", {
    BASTION_IP = var.bastion_instance_ip_list[0]
  })
}